// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;
// defining solidity version 

contract SimpleStorage
{

    uint256 favouriteNumber;
    bool favouriteBool;

    struct People
    {
        uint256 favouriteNumber;
        string name;        
    }

    People[] public people;

    function store(uint256 _favouriteNumber) public
    {
        favouriteNumber = _favouriteNumber;
    }

    function retrieve() public view returns(uint256)
    {
        return favouriteNumber;
    } 

    mapping(string => uint256) public nameToFavouriteNumber;
    
    function addPerson(string memory _name,uint256 _favouriteNumber) public 
    {
        people.push(People(_favouriteNumber,_name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }

    


}
