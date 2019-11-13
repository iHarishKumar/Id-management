pragma solidity ^0.5.6;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Full.sol";

contract IDMToken is ERC721Full{

    constructor() ERC721Full("IDMToken", "IDMT") public{
    }

    function mintNewTokenForIndividual(address _to, uint256 tokenId) public {
        super._mint(_to, tokenId);
        //super.approve(msg.sender, tokenId);
    }

    function transfer(address from, address to, uint256 tokenId) public{
        super.transferFrom(from, to, tokenId);
        //super.approve(msg.sender, tokenId);
    }
}