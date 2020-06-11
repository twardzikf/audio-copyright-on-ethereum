# Inflation Copyright Blockchain

 <<<<<<<<<<<<<<<<<<<<<<<<< WIP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
## 1. Techstack
- [VueJS](https://vuejs.org/v2/guide/) (Put in the project just for now, we don't have to use it if we decide not to)
- [Truffle](https://www.trufflesuite.com/docs)
- [Ganache](https://www.trufflesuite.com/ganache)

## 2. Product management

[**development board**](https://trello.com/b/IQxPefLs/backend)

## 3. Setup

#### Make sure you have npm installed and install truffle
`npm i -g truffle`

#### Download ganache
https://www.trufflesuite.com/ganache

#### Give permission for execution
`chmod a+x ganache-1.1.0-x86_64.AppImage`

#### Run the ganache blockchain
`./ganache-1.1.0-x86_64.AppImage`

#### Clone repository
`git clone https://gitlab.tubit.tu-berlin.de/blockchain2020/inflation.git && cd inflation`

#### Install dependencies
`npm install`

## 3. Development

#### Run the development server
`npm run dev`

#### Compile solidity contracts
`truffle compile`

#### Migrate contracts to the Blockchain
`truffle migrate`

### Run tests of contracts
`truffle test`

## Links & sources
- https://blog.openzeppelin.com/the-hitchhikers-guide-to-smart-contracts-in-ethereum-848f08001f05/
- https://www.trufflesuite.com/tutorials/pet-shop
