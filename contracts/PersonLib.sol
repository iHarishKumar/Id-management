pragma solidity ^0.5.6;

import "../node_modules/@openzeppelin/contracts/drafts/Counters.sol";
import "../contracts/Country.sol";

contract PersonLib{
    using Counters for Counters.Counter;
    struct Person{
        bytes8 _name;
        uint256 uTokenId;
        uint256 _value;
        bytes8 _originCountry;
        bytes8 _presentCountry;
        Country _coName;
        address _coOwner;
        bool inAuction;
        bool isActive;
    }
    Person[] private per;
    Counters.Counter totalPopulation;

    function addPerson(
        uint256 tokenId,
        bytes8 _name,
        uint256 _value,
        bytes8 _originCountry,
        bytes8 _presentCountry,
        Country _coName,
        address _coOwner) public returns(uint256) {

            Person memory p = Person(
                                _name,
                                tokenId,
                                _value,
                                _originCountry,
                                _presentCountry,
                                _coName,
                                _coOwner,
                                false,
                                true);
            per.push(p);
            totalPopulation.increment();
            return (uint256(totalPopulation.current())-1);
    }
    function setValue(uint256 tokenId, uint256 _value) public{
        per[tokenId]._value = _value;
    }
    function setPresentCountry(uint256 tokenId, bytes8 _presentCountry) public{
        per[tokenId]._presentCountry = _presentCountry;
    }
    function setForAuction(uint256 tokenId) public{
        per[tokenId].inAuction = true;
    }
    function resetAuction(uint256 tokenId) public{
        per[tokenId].inAuction = false;
    }
    function resetStatus(uint256 tokenId) public{
        per[tokenId].isActive = false;
    }
    function getPopulation() public view returns(uint256){
        return totalPopulation.current();
    }
    function getDetails(uint256 tokenId) public view returns(bytes8, bytes8){
        Person memory p = per[tokenId];
        return (p._name, p._originCountry);
    }
    function getUTokenID(uint256 tokenId) public view returns(uint256){
        return per[tokenId].uTokenId;
    }
    function auctionStatus(uint256 tokenId) public view returns(bool){
        return per[tokenId].inAuction;
    }
    function identityStatus(uint256 tokenId) public view returns(bool){
        return per[tokenId].isActive;
    }
    function getValue(uint256 tokenId) public view returns(uint256){
        return per[tokenId]._value;
    }
    function decresePopulation() public {
        totalPopulation.decrement();
    }
}
