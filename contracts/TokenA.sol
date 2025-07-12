// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <=0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenA is ERC20, ERC20Pausable, Ownable {
    uint256 private _initial_supply = 10000 * 10 ** 18; // 1 million tokens with 18 decimals
    constructor(address initialOwner)
        ERC20("TokenA", "MTKA")
        Ownable(initialOwner)
    {_mint(msg.sender, _initial_supply);}

    // Override _update to resolve inheritance conflict
    function _update(address from, address to, uint256 value) internal override(ERC20, ERC20Pausable) {
        super._update(from, to, value);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    // Function for "Bridge Simulation" - allow users to mint small amounts
    // (In a real scenario, this would be a bridge contract function)
    function mintForUserSimulation(address to, uint256 amount) public {
        // Add checks if needed, e.g., restrict total minted or frequency
        _mint(to, amount);
    }
}

// TokenB.sol will be similar, just change name and symbol