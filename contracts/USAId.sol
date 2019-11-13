pragma solidity ^0.5.6;

import "../contracts/Country.sol";
import "../contracts/PersonLib.sol";
import "../contracts/Organization.sol";

contract USAId is Country{
    using Counters for Counters.Counter;

    PersonLib public pLib;
    Organization public iniOrgAddr;
    uint256 public tk;

    event addingFromAuc(uint256, uint256, string);
    constructor(Organization _orgAddr) public{
        iniOrgAddr = _orgAddr;
        pLib = new PersonLib();
        iniOrgAddr.registerCountry(this, owner(), "USA");
    }
    modifier inAuction(uint256 tokenId){
        require(pLib.auctionStatus(tokenId), "Check if this token is in auction.");
        _;
    }
    modifier onlyOrg(address org){
        require(address(iniOrgAddr) == org, "Only Organization can make calls");
        _;
    }
    modifier checkStatus(uint256 tokenId){
        require(pLib.identityStatus(tokenId), "Check if the token is active");
        _;
    }
    function addPersonFromAuction(
        uint256 uTokenId,
        uint256 _value,
        bytes8 _name,
        bytes8 _originCountry) public onlyOrg(msg.sender) returns(uint256){
            uint256 tok =  pLib.addPerson(uTokenId, _name, _value, _originCountry, "USA", this, owner());
            emit addingFromAuc(uTokenId, tok, "USA");
        }
    function addPerson(
        bytes8 _name,
        bytes8 _originCountry
    )  public onlyOwner returns(uint256){
        uint256 uTokenId = iniOrgAddr.createToken(this, owner(), "USA");
        //tk = uTokenId;
        uint tokenId = pLib.addPerson(uTokenId, _name, 10000, _originCountry, "USA", this, owner());
        return tokenId;
    }

    function getPopulation() public view returns(uint256){
        return pLib.getPopulation();
    }
    //There is a bug here.
    //Because if this is not included as a default impl in the Country contract, people can change the state of auction
    //which will not enable the people to transfer the asset.
    function getIntoAuction(uint256 tokenId) public onlyOwner{
        //First check if this token is already in auction
        pLib.setForAuction(tokenId);
        iniOrgAddr.getIntoAuction(pLib.getUTokenID(tokenId), pLib.getValue(tokenId), owner(), "USA");
    }
    function getDetails(uint256 tokenId, uint256 value) public  onlyOrg(msg.sender) returns(bytes8, bytes8){
        pLib.resetStatus(tokenId);
        pLib.setPresentCountry(tokenId, 0x0);
        pLib.setValue(tokenId, value);
        pLib.decresePopulation();
        return (pLib.getDetails(tokenId));
    }
    function endAuction(uint256 tokenId) public inAuction(tokenId) checkStatus(tokenId){
        uint256 uTI = pLib.getUTokenID(tokenId);
        tk = uTI;
        iniOrgAddr.endAuction(uTI, tokenId, owner(), "USA");
    }
    function resetAuction(uint256 tokenId) public onlyOrg(msg.sender){
        pLib.resetAuction(tokenId);
    }
    function checkAuctionState(uint256 tokenId) public view returns(bool){
        return pLib.auctionStatus(tokenId);
    }
    function checkActiveState(uint256 tokenId) public view returns(bool){
        return pLib.identityStatus(tokenId);
    }
    function getUniversalToken(uint256 tokenId) public view returns(uint256){
        return pLib.getUTokenID(tokenId);
    }
}