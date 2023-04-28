// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import {Test, Vm} from "forge-std/Test.sol";
import {BankDeployer, MetaDeployer, PiggyBank} from "../src/PiggyBank.sol";

contract DeliSlicerTest is Test {
    event Deposit(address indexed depositor, uint256 value);

    BankDeployer internal deployer;
    MetaDeployer internal factory;
    PiggyBank internal bank;
    address internal initial;

    function setUp() public {
        vm.recordLogs();
        vm.deal(address(this), 1 ether);
        // 1. Deploy factory
        factory = new MetaDeployer();
        // 2. Deploy mutable piggy bank
        vm.recordLogs();
        factory.createBankDeployer();

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("FactoryDeployed(address)"));
        deployer = BankDeployer(abi.decode(entries[0].data, (address)));

        vm.recordLogs();
        deployer.deployPiggyBank();
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("BankDeployed(address)"));
        // store initial address to compare in step seven
        bank = PiggyBank(abi.decode(entries[0].data, (address)));
        initial = address(bank);

        // 3. destroy mutable piggy bank
        bank.smash();
        assertEq(address(this).balance, 1 ether);

        // 4. destroy the factory created in step one. 
        deployer.destroy();
        vm.getRecordedLogs();
    }


    function testRecreate() public {
        // 5. recreate the bank deployer
        // nonce == 1
        vm.recordLogs();
        factory.createBankDeployer();
        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("FactoryDeployed(address)"));
        deployer = BankDeployer(abi.decode(entries[0].data, (address)));

        vm.recordLogs();
        deployer.deployPiggyBank();
        entries = vm.getRecordedLogs();
        assertEq(entries.length, 1);
        assertEq(entries[0].topics.length, 1);
        assertEq(entries[0].topics[0], keccak256("BankDeployed(address)"));

        // 6. deploy new piggy bank 
        // the bank can be modified here
        // https://mixbytes.io/blog/metamorphic-smart-contracts-is-evm-code-truly-immutable
        bank = PiggyBank(abi.decode(entries[0].data, (address)));

        // 7. address for both should be the same.
        assertEq(address(bank), initial);
    }
}
