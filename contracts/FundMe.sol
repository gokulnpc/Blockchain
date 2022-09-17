// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";
contract FundMe
{ 
   
    //it will use safemathchainlink for all of uint256
    //it doesn't allow overflow to occur 
    using SafeMathChainlink for uint256;
    
    mapping(address => uint256) public addressToAmountFunded;
    
    address owner;
    constructor()
    {
        owner = msg.sender;
    }
    //we can send value because it is payable
    //msg.sender => my account public address
    //msg.value => gas value that I allocated
    function fund() public payable
    {
        //minimum 50$
        uint256 minimumUSD = 50*10**18;

        //if it is not satisfied then it will stop executing and print error message
        require(getConversionRate(msg.value) >= minimumUSD,"You need to spend more ETH");


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

    function withDraw(uint256 _amount) payable public
    {
        //require msg.sender == owner
        require(msg.sender == owner,"Only owner can withdraw");

        //transfer function transfer fund from one address to another
        //here we are transferrring to msg.sender (me)
        //to transfer we need addresses
        //this refers to the contract that we are currently in
        //address(this) gives adress of the current contract
        //address.balance gives balance in that address
        payable(msg.sender).transfer(address(this).balance);
    }
}