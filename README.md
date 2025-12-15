# **FundMe — Foundry & Solidity Project**

A minimal FundMe smart contract built using Foundry, demonstrating Solidity fundamentals, Chainlink price feeds, automated testing, and deployment workflows.
This project is designed as a learning + portfolio project following best practices in modern Ethereum development.


**🚀 Overview**
The FundMe contract allows users to fund the contract with ETH while enforcing a minimum USD value using Chainlink ETH/USD price feeds.
Only the contract owner can withdraw the funds.

The project showcases:

1. Solidity best practices
2. Foundry testing & scripting
3. Chainlink oracle integration
4. Environment-based network configuration


**Features**

1. Fund the contract with ETH
2. Enforces minimum contribution in USD (via Chainlink Price Feeds)
3. Owner-only withdrawal
4. Network-aware configuration using HelperConfig
5. Unit & fork tests with Foundry
6. Automated deployment scripts
7. Makefile for common commands