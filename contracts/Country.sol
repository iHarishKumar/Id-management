pragma solidity ^0.5.6;

import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";

contract Country is Ownable {

    function addPerson(
        bytes8 _name,
        bytes8 _originCountry
    )  external returns(uint256);

    function getPopulation() external view returns(uint256);

    function getDetails(
        uint256 tokenId,
        uint256 value) external returns(bytes8, bytes8);

    function addPersonFromAuction(
        uint256 tokenId,
        uint256 _value,
        bytes8 _name,
        bytes8 _originCountry) external returns(uint256);
        
    function resetAuction(uint256 tokenId) external;
}
