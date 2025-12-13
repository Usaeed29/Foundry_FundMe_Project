// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Test, console} from "../../lib/forge-std/src/Test.sol";   
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe} from "../../script/Interactions.s.sol";

contract FundMeTestIntegration is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 10 ether;   
    uint256 constant GAS_PRICE = 1 ;
   function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();   

        vm.deal(USER, SEND_VALUE);

}

}