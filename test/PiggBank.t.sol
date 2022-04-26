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
        bank.call{value: 1 ether}("");
    }
}
