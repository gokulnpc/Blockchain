// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

//if you want to interact with an already deployed smart contract / interface contract then you will need an ABI

// interface AggregatorV3Interface {
//   function decimals() external view returns (uint8);

//   function description() external view returns (string memory);

//   function version() external view returns (uint256);

//   function getRoundData(uint80 _roundId)
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );

//   function latestRoundData()
//     external
//     view
//     returns (
//       uint80 roundId,
//       int256 answer,
//       uint256 startedAt,
//       uint256 updatedAt,
//       uint80 answeredInRound
//     );
// }

contract FundMe
{ 
   
    mapping(address => uint256) public addressToAmountFunded;
    
    //we can send value because it is payable
    //msg.sender => my account public address
    //msg.value => gas value that I allocated
    function fund() public payable
    {
        addressToAmountFunded[msg.sender] += msg.value;
        //what the USD to ETH conversion rate 
    }

    function getVersion() public view returns(uint256)
    {
        //AggregatorV3Interface is not a contract (Class)
        //it is a interface
        //we need ETH to USD address 
        //we can get it from 'ethereum price feeds'
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return pricefeed.version();  
    }

    function getPrice() public view returns(uint256)
    {
        AggregatorV3Interface pricefeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        (
            /*uint80 roundID*/,
            int256 answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = pricefeed.latestRoundData();
        return uint256(answer*10000000000) ;
    }

    function getConversionRate(uint256 _ethAmount) public view returns(uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice*_ethAmount)/1000000000000000000;
        return ethAmountInUsd;
    }
}