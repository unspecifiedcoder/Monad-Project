// Sources flattened with hardhat v2.25.0 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (utils/introspection/IERC165.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[ERC].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[ERC section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.20;

/**
 * @dev Required interface of an ERC-721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC-721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or
     *   {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon
     *   a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC-721
     * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
     * understand this adds an external call which potentially creates a reentrancy vulnerability.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the address zero.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v5.3.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}


// File contracts/MonadAMM.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.20;
interface ILPToken {
    function mint(address to, uint256 amount) external;
    function burn(address from, uint256 amount) external;
    function totalSupply() external view returns (uint256);
}

interface ILPBadge {
    function mintBadge(address to, string calldata uri) external;
}

contract MonadAMM is Ownable {
    address public immutable tokenA; // address(0) for native
    address public immutable tokenB; // address(0) for native

    ILPToken public lpToken;
    IERC721 public lpBadge;
    uint256 public constant LP_BADGE_THRESHOLD = 5e18;
    string public constant LP_BADGE_METADATA_URI = "ipfs://bafkreigbqlikf7bg5hfqvkxac6ia53jeunkhdm4eaf2eo2imbxkn4u4amq/lp_badge.json    ";

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
        charityRecipient = msg.sender; // Default to contract deployer
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

    function setLPToken(address _lpToken) public onlyOwner {
        require(address(lpToken) == address(0), "LP token already set");
        lpToken = ILPToken(_lpToken);
    }

    function setLPBadge(address _lpBadge) public onlyOwner {
        require(address(lpBadge) == address(0), "LP badge already set");
        lpBadge = IERC721(_lpBadge);
    }

    // --- Helper functions for native/ERC20 handling ---

    function _balanceOf(address token, address account) internal view returns (uint256) {
        if (token == address(0)) {
            return account.balance;
        } else {
            return IERC20(token).balanceOf(account);
        }
    }

    function _transferIn(address token, uint256 amount) internal {
        if (token == address(0)) {
            require(msg.value == amount, "Incorrect native value sent");
        } else {
            require(msg.value == 0, "No native value expected");
            require(IERC20(token).transferFrom(msg.sender, address(this), amount), "ERC20 transfer failed");
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

    // --- Liquidity Functions ---

    function addLiquidity(
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin
    ) external payable returns (uint256 lpMintedAmount) {
        // Determine which token is native and handle accordingly
        uint256 reserveA = _balanceOf(tokenA, address(this));
        uint256 reserveB = _balanceOf(tokenB, address(this));

        uint256 amountA;
        uint256 amountB;

        // Handle native token input
        if (tokenA == address(0) && tokenB == address(0)) {
            revert("Both tokens cannot be native");
        }

        // Accept native token if needed
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

        // Initial liquidity
        if (reserveA == 0 || reserveB == 0) {
            require(amountA >= amountAMin && amountB >= amountBMin, "Insufficient initial liquidity");
            uint256 initialLP = 1000e18;
            lpMintedAmount = initialLP;
            require(amountA * amountB > 1000, "Too little initial liquidity");
        } else {
            // Optimal amounts
            uint256 amountBOptimal = (amountA * reserveB) / reserveA;
            if (amountBOptimal <= amountB) {
                amountB = amountBOptimal;
            } else {
                uint256 amountAOptimal = (amountB * reserveA) / reserveB;
                require(amountAOptimal <= amountA, "Excessive slippage in A");
                amountA = amountAOptimal;
            }
            require(amountA >= amountAMin, "Insufficient A provided");
            require(amountB >= amountBMin, "Insufficient B provided");

            uint256 totalLP = lpToken.totalSupply();
            lpMintedAmount = (totalLP * amountA) / reserveA;
            require(lpMintedAmount > 0, "Too little liquidity added");
        }

        // Refund any excess native token
        if (tokenA == address(0) && msg.value > amountA) {
            _transferOut(address(0), msg.sender, msg.value - amountA);
        }
        if (tokenB == address(0) && msg.value > amountB) {
            _transferOut(address(0), msg.sender, msg.value - amountB);
        }

        // Mint LP tokens
        lpToken.mint(msg.sender, lpMintedAmount);

        // LP Badge logic (optional)
        uint256 addedValueInA = amountA + (amountB * reserveA) / (reserveB == 0 ? 1 : reserveB);
        if (addedValueInA >= LP_BADGE_THRESHOLD && address(lpBadge) != address(0)) {
            ILPBadge(address(lpBadge)).mintBadge(msg.sender, LP_BADGE_METADATA_URI);
        }

        emit AddLiquidity(msg.sender, amountA, amountB, lpMintedAmount);
        return lpMintedAmount;
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

    // Allow contract to receive native tokens
    receive() external payable {}
}
