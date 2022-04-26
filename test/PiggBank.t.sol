// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/PiggyBank.sol";

contract PiggyBankTest is Test {
    event Deposit(address indexed depositor, uint256 value);

    PiggyBank internal bank;

    function setUp() public {
        vm.deal(address(this), 1 ether);
        bank = new PiggyBank();
    }

    function testDeposit() public {
        vm.expectEmit(true, true, true, true);
        emit Deposit(address(this), 1 ether);
        (bool success,) = address(bank).call{value: 1 ether}("");
        assertTrue(success);
    }

    function testWithdraw() public {
        (bool success,) = address(bank).call{value: 1 ether}("");
        assertTrue(success);
        assertEq(address(this).balance, 0);
        bank.withdraw();
        assertEq(address(this).balance, 1 ether);
    }
}
