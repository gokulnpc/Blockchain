// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
contract FundMe
{ 
    using SafeMathChainlink for uint256;
    mapping(address => uint256) public addressToAmountFunded;
    address owner;
    address[] public funders;

    constructor()
    {
        owner = msg.sender;
    }
    function fund() public payable
    {
        uint256 minimumUSD = 50*10*18;
        require(getConversionRate(msg.value) >= minimumUSD,"You need to spend more ETH");
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256)
    {
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


    //withdraw function to withdraw all ethers from the contract
    //modifiers: to chainge function in a declarative way
    modifier onlyOwner
    {
        require(msg.sender == owner,"Only owner can withdraw");
        _;
    }
    function withDraw() payable onlyOwner public
    {
        //require(msg.sender == owner,"Only owner can withdraw");
        //Withdraw function
        payable(msg.sender).transfer(address(this).balance);
        for(uint256 i=0;i<funders.length;i++)
        {
            addressToAmountFunded[funders[i]]=0;
        }
        funders = new address[](0);
    }
}