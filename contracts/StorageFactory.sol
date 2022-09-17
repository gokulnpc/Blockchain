// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

//importing Simple storage contract
import "./SimpleStorage.sol";
 
contract StorageFactory
{
    SimpleStorage[] public simpleStorageArray;
    function createSimpleStorageContract() public
    {
        SimpleStorage simpleStorage = new SimpleStorage();
        simpleStorageArray.push(simpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public
    {
        //to interact with contract we need
        //address of the contract
        //ABI -> application binary interface
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_simpleStorageNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) 
    {
        return SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    }
}