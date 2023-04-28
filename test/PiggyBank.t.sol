// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, Vm} from "forge-std/Test.sol";
import {BankDeployer, MetaDeployer, PiggyBank} from "../src/PiggyBank.sol";

contract PiggyBankTest is Test {
    event Deposit(address indexed depositor, uint256 value);

    BankDeployer internal deployer;
    MetaDeployer internal factory;
    PiggyBank internal bank;

    address internal bob = address(0xb0b);
    address internal initial;

    function setUp() public {
        // MetaDeployer is a CREATE2 factory that creates piggy bank factories.
        factory = new MetaDeployer();

        // 1. Deploy mutable piggy bank factory
        vm.recordLogs();
        vm.prank(bob);
        factory.createBankDeployer();

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("FactoryDeployed(address)"));

        deployer = BankDeployer(abi.decode(entries[0].data, (address)));

        // 2. Deploy a piggy bank
        vm.prank(bob);
        vm.recordLogs();
        deployer.deployPiggyBank();

        entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("BankDeployed(address)"));

        bank = PiggyBank(abi.decode(entries[0].data, (address)));
        // store initial address for comparison
        initial = address(bank);
    }

    function testDepositAndWithdraw() public {
        // send eth to the piggy bank
        vm.deal(bob, 1 ether);
        vm.expectEmit();
        emit Deposit(bob, 1 ether);
        vm.prank(bob);
        (bool success,) = address(bank).call{value: 1 ether}("");
        assertTrue(success);
        assertEq(bob.balance, 0);
        assertEq(address(bank).balance, 1 ether);

        // 3. destroy mutable piggy bank
        assertEq(address(bank).balance, 1 ether);
        vm.prank(bob);
        bank.smash();
        assertEq(bob.balance, 1 ether);

        // 4. destroy the factory created in step one. 
        deployer.destroy();
    }
}
