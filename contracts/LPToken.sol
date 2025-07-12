// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LPToken is ERC20, Ownable {

    constructor() ERC20("LPToken", "AMMLP") Ownable(msg.sender)   {
        _mint(msg.sender, 1000 * 10 ** 18); // Initial supply of 1000 LP tokens with 18 decimals
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyOwner {
        
        _burn(from, amount);
    }
}