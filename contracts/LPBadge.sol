// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract LPBadge is ERC721, Ownable {
    uint256 private _tokenIdCounter;
    string private _baseTokenURI;

    constructor(address initialOwner, string memory baseTokenURI_)
        ERC721("LP Badge", "LPB")
        Ownable(initialOwner)
    {
        _baseTokenURI = baseTokenURI_;
    }

    // Only owner can mint
    function mintBadge(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter += 1;
        _safeMint(to, tokenId);
    }

    // Override tokenURI to use base URI + tokenId
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "ERC721: URI query for nonexistent token");
        return string(abi.encodePacked(_baseTokenURI, Strings.toString(tokenId)));
    }

    // Owner can update base URI
    function setBaseURI(string memory baseTokenURI_) public onlyOwner {
        _baseTokenURI = baseTokenURI_;
    }
}