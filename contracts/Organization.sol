pragma solidity ^0.5.6;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/drafts/Counters.sol";
import "../contracts/IDMToken.sol";
import "../contracts/Country.sol";
import "../contracts/SimpleAuction.sol";

contract Organization is Ownable{
    using Counters for Counters.Counter;
    
    event SuccessfulBid(address, address, uint256);
    event UnSuccessfulBid(address, uint256, string);

    IDMToken token;
    Counters.Counter totalPopulation;
    mapping(bytes6 => Country) countryNames;
    mapping(address => bytes6) countryOwners;
    mapping(uint256 => SimpleAuction) auctions;
    bytes6 public someVal1;
    bytes6 public someVal2;
    
    function () payable external {
    }
    constructor() public{
        token = new IDMToken();
    }
    modifier onlyCountryOwner(bytes6 _coName, address _coOwnerAddr){
        require(countryOwners[_coOwnerAddr] == _coName, "Only country owner has right to access its artifacts.");
        _;
    }
    modifier onlyCountry(bytes6 _coName, Country _coAddr){
        require(countryNames[_coName] == _coAddr, "Check which country does this belong to.");
        _;
    }
    function registerCountry(Country _coAddr, address _coOwnerAddr, bytes6 _coName) public{
        countryNames[_coName] = _coAddr;
        countryOwners[_coOwnerAddr] = _coName;
    }
    function createToken(
        Country _coAddr,
        address _coOwnerAddr,
        bytes6 _coName) public
        onlyCountry(_coName, _coAddr)
        onlyCountryOwner(_coName, _coOwnerAddr)
        returns(uint256) {

        totalPopulation.increment();
        uint256 tokenId = totalPopulation.current();
        token.mintNewTokenForIndividual(_coOwnerAddr, tokenId);
        return tokenId;
    }

    function getIntoAuction(uint256 utokenId, uint256 _value, address _coOwnerAddr, bytes6 _coName) public onlyCountryOwner(_coName, _coOwnerAddr) {
        SimpleAuction  auc = new SimpleAuction(_value);
        auctions[utokenId] = auc;
    }
    function getAuctionContractAddress(uint256 tokenId) public view returns(address){
        return address(auctions[tokenId]);
    }
    function endAuction(
        uint256 uTokenId,
        uint256 lTokenId,
        address _coOwnerAddr,
        bytes6 _coName)
        public
        payable
        onlyCountryOwner(_coName, _coOwnerAddr) {

        SimpleAuction auc = auctions[uTokenId];
        auc.auctionEnd();
        address highestBidder = auc.highestBidder();
        uint256 highestBid = auc.highestBid();
        someVal2 = countryOwners[highestBidder];
        
        //  Check if the bidder is other than country owner.
        if(countryOwners[highestBidder] != 0x0){
            //transfer ownership
            addingPersonFromAuction(uTokenId, lTokenId, highestBid, highestBidder, _coOwnerAddr);
            //First transfer the token
            token.transfer(_coOwnerAddr, highestBidder, uTokenId);
            address(uint160(_coOwnerAddr)).transfer(highestBid);
            
            emit SuccessfulBid(_coOwnerAddr, highestBidder, uTokenId);
        }
        else if(highestBidder != address(0x0)){
            emit UnSuccessfulBid(highestBidder, uTokenId, "Unsuccessful");
            resetAuctionStatus(lTokenId, _coOwnerAddr);
            address(uint160(highestBidder)).transfer(highestBid);
        }
        else{
           emit UnSuccessfulBid(highestBidder, uTokenId, "No bid"); 
           resetAuctionStatus(lTokenId, _coOwnerAddr);
        }
    }
    function addingPersonFromAuction(uint256 uTokenId, uint256 lTokenId, uint256 value, address highestBidder, address _coOwnerAddr) internal{
        (bytes8 name,
            bytes8 originCountry) = countryNames[countryOwners[_coOwnerAddr]].getDetails(lTokenId, value);
        Country co = countryNames[countryOwners[highestBidder]];
        co.addPersonFromAuction(uTokenId, value, name, originCountry);
    }
    function resetAuctionStatus(uint256 tokenId, address _coOwnerAddr) internal{
        Country co = countryNames[countryOwners[_coOwnerAddr]];
        someVal1 = "harish";
        co.resetAuction(tokenId);
    }
    function getBalance() public returns(uint256){
        return address(this).balance;
    }
}