// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Waveportal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Yo, I am a smart contract");
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );        
        lastWavedAt[msg.sender] = block.timestamp;
        totalWaves+= 1;
        console.log("%s has waved!", msg.sender);
        waves.push(Wave(msg.sender,_message,block.timestamp));

        seed=(block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # created: %d, seed");



        if(seed<50){
            console.log("%s won!", seed);
        }

        uint256 prizeAmount = 0.0001 ether;
        require(
            prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has"
        );
        (bool success,) = (msg.sender).call{value:prizeAmount}("");
        require(success, "Failed to withdraw money from the contract");

        emit NewWave(msg.sender, block.timestamp, _message);


    }

    function getAllWaves() public view returns(Wave[] memory){
        return waves;
    }

    function getTotalWaves() public view returns (uint256){
        console.log("we have %d total waves!",totalWaves);
        return totalWaves;
    }
}