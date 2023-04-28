// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract MetaDeployer {
    event FactoryDeployed(address addr);

    function createBankDeployer() public {
        BankDeployer d = (new BankDeployer){salt: "0xFARM"}();
        emit FactoryDeployed(address(d));
    }
}

contract BankDeployer {
    event BankDeployed(address addr);

    function deployPiggyBank() public {
        PiggyBank p = new PiggyBank(msg.sender);
        emit BankDeployed(address(p));
    }

    function destroy() public {
        selfdestruct(payable(address(msg.sender)));
    }
}

contract PiggyBank {
    address internal immutable owner;

    event Deposit(address indexed depositor, uint256 value);

    constructor (address sender) {
        owner = sender;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function smash() external {
        require(msg.sender == owner, "Not the owner"); 
        selfdestruct(payable(msg.sender));
    }
}
