// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//Fund 
// withdraw

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";
contract FundFundMe is Script{

    function fundFundMe(address mostRecentDeployed) public{
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).fund{value:0.1 ether}();
        vm.stopBroadcast();
        console.log("Funded FundMe contract with 0.1 ETH");
    }
    function run() external{
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);

        fundFundMe(mostRecentDeployed);
        
    }
}

contract WithdrawFundMe is Script{}