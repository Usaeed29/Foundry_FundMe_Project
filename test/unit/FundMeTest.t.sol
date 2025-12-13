// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user");
    uint256 constant STARTING_BALANCE = 10 ether;
    
    function setUp() external {
        //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 6e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.getOwner(), msg.sender);
    }

      function testPriceFeedVersionIsAccurate() public {
        if (block.chainid == 11155111) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 4);
        } else if (block.chainid == 1) {
            uint256 version = fundMe.getVersion();
            assertEq(version, 6);
        }
  }       
  function testFundFailWithoutEnoughETH() public{
    vm.expectRevert(); // the next line should revert
    fundMe.fund(); // test result will pass if this reverts
  }
    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // the next tx will be sent by USER
        fundMe.fund{value: 10e18}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER); // msg.sender = the caller ; address(this) = the contract

        assertEq(amountFunded, 10e18);
}
    function testAddsFunderToArrayOfFunders() public {
        vm.prank(USER);
        fundMe.fund{value: 10e18}();

        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: 10e18}();
        _;
    } 
    function testOnlyOwnerCanWithdraw() public funded{

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }
    function testWithdrawWithASingleFunder() public funded {

        // three methodologies of testing
        // 1. arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        // 2. act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // 3. assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            startingFundMeBalance + startingOwnerBalance,
            endingOwnerBalance
        );

}

    function testWithdrawFromMultipleFunders() public funded {
        // arrange
        uint160 numberOfFunders = 10;
        

        for (uint160 i = 1; i <= numberOfFunders; i++) {
            //vm.prank(address(i));
            //fundMe.fund{value: 1 ether}();
            hoax(address(i), 1 ether); //hoax does both prank and deal
            fundMe.fund{value: 1 ether}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        
        // act
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        // assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance
        );
    }

    function testWithdrawFromMultipleFundersCheaper() public funded {
        // arrange
        uint160 numberOfFunders = 10;
        

        for (uint160 i = 1; i <= numberOfFunders; i++) {
            //vm.prank(address(i));
            //fundMe.fund{value: 1 ether}();
            hoax(address(i), 1 ether); //hoax does both prank and deal
            fundMe.fund{value: 1 ether}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        
        // act
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        // assert
        assert(address(fundMe).balance == 0);
        assert(
            startingFundMeBalance + startingOwnerBalance == fundMe.getOwner().balance
        );
    }
}
//four types of test:
//1. Unit - testing a specific part of the code
//2. Integration - testing how our code works with other parts of our code
//3. Forked - Testing our code on a simulated real environment
//4. Staging - Testing our code in a real environment that is not prod
 