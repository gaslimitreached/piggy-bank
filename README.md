# 🐷 Piggy Bank with Self-Destruct Functionality

This repository contains an Ethereum smart contract that demonstrates the use of Solidity's `selfdestruct` opcode. The contract is a piggy bank that allows users to deposit Ethereum into it. When the owner of the contract calls the self-destruct function, the contract will be destroyed, and the balance of the contract will be sent to the owner.

In addition to the piggy bank contract, this repository also includes a mechanism to redeploy the piggy bank to the same address. This mechanism involves two factory contracts. The first factory uses Solidity's `CREATE` opcode to create the piggy bank contract, and the second factory uses Solidity's `CREATE2` opcode to create the first factory. This is called the meta factory.

## Warning

**This code is provided as-is and is untested. It should not be used in a production environment without a thorough review and testing. The use of this code may result in loss of funds. Use at your own risk.**

Please note that the `selfdestruct` opcode is scheduled to be removed from the Solidity language in the future. This means that using this opcode may not be a viable option in the long term.

## Getting Started

To use the piggy bank contract and the factory contracts, you will need to have a local development environment set up for Ethereum development. This repository uses [foundry](https://github.com/foundry-rs/foundry)

Once you have your development environment set up, you can clone this repository to your local machine:

```bash
git clone https://github.com/gaslimitreached/piggy-bank.git
```

## Using the Repo

```bash
forge build
```

This will compile the piggy bank contract, the two factory contracts, and generate the binary and ABI files in the `build/` directory.

Once the contracts are compiled, you can deploy them to your local development environment using Forge. To deploy the piggy bank contract, you can use the following command:

```bash
forge deploy PiggyBank --network local
```

Tests are also provided.

```bash
forge test
```

To use the piggy bank contract, you can deposit Ethereum into the contract by sending the amount of Ethereum you wish to deposit to the piggy bank.

To destroy the contract and retrieve the balance, the owner of the contract can call the `smash` function which calls `selfdestruct`.

To redeploy the piggy bank contract using the factory contracts, you can follow the instructions in the `README.md` file for the `PiggyBankFactory` and `MetaFactory` contracts.

## Contributing

If you would like to contribute to this repository, please fork the repository and create a pull request with your changes. Please make sure to follow the contribution guidelines outlined in the `CONTRIBUTING.md` file.

## License

This repository is provided without a license and is considered to be unlicensed. This means that anyone can use the code for any purpose without restrictions or obligations.

