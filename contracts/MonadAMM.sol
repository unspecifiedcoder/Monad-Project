// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILPBadge {
    function mintBadge(address to) external;
}

interface ILPToken {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function totalSupply() external view returns (uint256);
}

contract MonadAMM is Ownable {
    address public immutable tokenA; // address(0) for native
    address public immutable tokenB; // address(0) for native

    ILPToken public lpToken;
    IERC721 public lpBadge;
    uint256 public constant LP_BADGE_THRESHOLD = 5e18;
    // This URI is now used by the LPBadge contract itself, not passed in the call.
    string public constant LP_BADGE_METADATA_URI = "ipfs://bafkreigbqlikf7bg5hfqvkxac6ia53jeunkhdm4eaf2eo2imbxkn4u4amq/lp_badge.json";

    uint256 public constant FEE_BPS = 30;
    uint256 public constant BASIS_POINTS_MAX = 10000;
    uint256 public charityFeeBps = 5; // 0.05% by default
    address public charityRecipient;

    event CharityRecipientChanged(address indexed newRecipient);
    event CharityFeeChanged(uint256 newFeeBps);
    event AddLiquidity(address indexed provider, uint256 amountA, uint256 amountB, uint256 lpMinted);
    event RemoveLiquidity(address indexed provider, uint256 amountA, uint256 amountB, uint256 lpBurned);
    event Swap(address indexed swapper, address indexed tokenIn, uint256 amountIn, address indexed tokenOut, uint256 amountOut);
    event LPBadgeMinted(address indexed provider, uint256 badgeTokenId);

    constructor(address _tokenA, address _tokenB) Ownable(msg.sender) {
        tokenA = _tokenA;
        tokenB = _tokenB;
        charityRecipient = msg.sender;
    }
    
    function setLPToken(address _lpToken) public onlyOwner {
        require(address(lpToken) == address(0), "LP token already set");
        lpToken = ILPToken(_lpToken);
    }

    function setLPBadge(address _lpBadge) public onlyOwner {
        require(address(lpBadge) == address(0), "LP badge already set");
        lpBadge = IERC721(_lpBadge);
    }


    function _transferIn(address token, uint256 amount) internal {
        if (token == address(0)) {
            require(msg.value == amount, "Incorrect native value sent");
        } else {
            require(IERC20(token).transferFrom(msg.sender, address(this), amount), "ERC20 transfer failed");
        }
    }


    function addLiquidity(
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) external payable returns (uint256 lpMintedAmount) {
        uint256 reserveA = _balanceOf(tokenA, address(this));
        uint256 reserveB = _balanceOf(tokenB, address(this));

        // Adjust reserves for incoming native currency to prevent calculation errors on first deposit
        if(tokenA == address(0)) {
            reserveA -= msg.value;
        } else if (tokenB == address(0)) {
            reserveB -= msg.value;
        }

        uint256 amountA;
        uint256 amountB;

        if (tokenA == address(0)) {
            amountA = msg.value;
            amountB = amountBDesired;
            _transferIn(tokenB, amountB);
        } else if (tokenB == address(0)) {
            amountA = amountADesired;
            amountB = msg.value;
            _transferIn(tokenA, amountA);
        } else {
            amountA = amountADesired;
            amountB = amountBDesired;
            _transferIn(tokenA, amountA);
            _transferIn(tokenB, amountB);
        }

        if (reserveA == 0 && reserveB == 0) {
            require(amountA >= amountAMin && amountB >= amountBMin, "Insufficient initial liquidity");
            lpMintedAmount = 1000e18;
            require(amountA * amountB > 1000, "Too little initial liquidity");
        } else {
            uint256 amountBOptimal = (amountA * reserveB) / reserveA;
            if (amountBOptimal <= amountB) {
                amountB = amountBOptimal;
            } else {
                uint256 amountAOptimal = (amountB * reserveA) / reserveB;
                require(amountAOptimal <= amountA, "Slippage");
                amountA = amountAOptimal;
            }
            require(amountA >= amountAMin && amountB >= amountBMin, "Insufficient amounts");
            uint256 totalLP = lpToken.totalSupply();
            lpMintedAmount = (totalLP * amountA) / reserveA;
            require(lpMintedAmount > 0, "Too little liquidity added");
        }

        if (tokenA == address(0) && msg.value > amountA) {
            _transferOut(address(0), msg.sender, msg.value - amountA);
        }
        if (tokenB == address(0) && msg.value > amountB) {
            _transferOut(address(0), msg.sender, msg.value - amountB);
        }

        lpToken.mint(msg.sender, lpMintedAmount);

        uint256 addedValueInA = amountA + (amountB * reserveA) / (reserveB == 0 ? 1 : reserveB);
        if (addedValueInA >= LP_BADGE_THRESHOLD && address(lpBadge) != address(0)) {
            // --- FIX 2: Corrected the call ---
            // Call mintBadge with only the recipient's address.
            ILPBadge(address(lpBadge)).mintBadge(msg.sender);
        }

        emit AddLiquidity(msg.sender, amountA, amountB, lpMintedAmount);
        return lpMintedAmount;
    }

        function setCharityRecipient(address _recipient) external onlyOwner {
        require(_recipient != address(0), "Zero address");
        charityRecipient = _recipient;
        emit CharityRecipientChanged(_recipient);
    }

    function setCharityFeeBps(uint256 _feeBps) external onlyOwner {
        require(_feeBps <= 100, "Max 1%"); // safety: max 1%
        charityFeeBps = _feeBps;
        emit CharityFeeChanged(_feeBps);
    }

    function _balanceOf(address token, address account) internal view returns (uint256) {
        if (token == address(0)) {
            return account.balance;
        } else {
            return IERC20(token).balanceOf(account);
        }
    }

        function _transferOut(address token, address to, uint256 amount) internal {
        if (token == address(0)) {
            (bool sent, ) = to.call{value: amount}("");
            require(sent, "Native transfer failed");
        } else {
            require(IERC20(token).transfer(to, amount), "ERC20 transfer failed");
        }
    }

    function removeLiquidity(uint256 lpBurnAmount) external returns (uint256 amountA, uint256 amountB) {
        require(lpBurnAmount > 0, "Must burn > 0 LP tokens");
        uint256 totalLP = lpToken.totalSupply();
        require(totalLP > 0, "No liquidity in pool");

        uint256 reserveA = _balanceOf(tokenA, address(this));
        uint256 reserveB = _balanceOf(tokenB, address(this));

        amountA = (lpBurnAmount * reserveA) / totalLP;
        amountB = (lpBurnAmount * reserveB) / totalLP;
        require(amountA > 0 && amountB > 0, "Too little LP to withdraw tokens");

        lpToken.burn(msg.sender, lpBurnAmount);

        _transferOut(tokenA, msg.sender, amountA);
        _transferOut(tokenB, msg.sender, amountB);

        emit RemoveLiquidity(msg.sender, amountA, amountB, lpBurnAmount);
        return (amountA, amountB);
    }

    // --- Swap Function ---

    function swap(address tokenIn, uint256 amountIn, uint256 amountOutMin) external payable returns (uint256 amountOut) {
        require(tokenIn == tokenA || tokenIn == tokenB, "Invalid token");
        require(amountIn > 0, "Amount in must be greater than 0");

        address tokenOut = (tokenIn == tokenA) ? tokenB : tokenA;
        uint256 reserveIn = _balanceOf(tokenIn, address(this));
        uint256 reserveOut = _balanceOf(tokenOut, address(this));
        require(reserveIn > 0 && reserveOut > 0, "Insufficient liquidity in pool");

        // Accept input
        if (tokenIn == address(0)) {
            require(msg.value == amountIn, "Incorrect native value sent");
        } else {
            require(msg.value == 0, "No native value expected");
            require(IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn), "ERC20 transfer failed");
        }
    // --- Calculate fees ---
        uint256 totalFee = (amountIn * FEE_BPS) / BASIS_POINTS_MAX;
        uint256 charityFee = (amountIn * charityFeeBps) / BASIS_POINTS_MAX;
        uint256 amountInWithFee = amountIn - totalFee;

        // --- Transfer charity fee ---
        if (charityFee > 0 && charityRecipient != address(0)) {
            _transferOut(tokenIn, charityRecipient, charityFee);
        }
        
        
        uint256 numerator = reserveOut * amountInWithFee;
        uint256 denominator = reserveIn + amountInWithFee;
        amountOut = numerator / denominator;

        require(amountOut >= amountOutMin, "Insufficient output amount due to slippage");
        require(amountOut < reserveOut, "Invalid output amount");

        _transferOut(tokenOut, msg.sender, amountOut);

        emit Swap(msg.sender, tokenIn, amountIn, tokenOut, amountOut);
        return amountOut;
    }

    // --- View Functions ---

    function getReserves() public view returns (uint256 reserveA, uint256 reserveB) {
        return (_balanceOf(tokenA, address(this)), _balanceOf(tokenB, address(this)));
    }

    function getPrice() public view returns (uint256 priceA_per_B_scaled, uint256 priceB_per_A_scaled) {
        (uint256 reserveA, uint256 reserveB) = getReserves();
        if (reserveA == 0 || reserveB == 0) return (0, 0);
        priceA_per_B_scaled = (reserveA * 1e18) / reserveB;
        priceB_per_A_scaled = (reserveB * 1e18) / reserveA;
    }

    function getLPSupply() public view returns (uint256) {
        require(address(lpToken) != address(0), "LP token not set");
        return lpToken.totalSupply();
    }

    function getAmountOut(uint256 amountIn, address tokenIn) public view returns (uint256 amountOut) {
        require(tokenIn == tokenA || tokenIn == tokenB, "Invalid token");
        require(amountIn > 0, "Amount in must be greater than 0");
        address tokenOut = (tokenIn == tokenA) ? tokenB : tokenA;
        uint256 reserveIn = _balanceOf(tokenIn, address(this));
        uint256 reserveOut = _balanceOf(tokenOut, address(this));
        if (reserveIn == 0 || reserveOut == 0) return 0;
        uint256 amountInWithFee = (amountIn * (BASIS_POINTS_MAX - FEE_BPS)) / BASIS_POINTS_MAX;
        uint256 numerator = reserveOut * amountInWithFee;
        uint256 denominator = reserveIn + amountInWithFee;
        amountOut = numerator / denominator;
    }



    
    receive() external payable {}
}