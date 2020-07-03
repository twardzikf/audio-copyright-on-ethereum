
import Web3 from 'web3';

export default class BlockchainService {

  constructor(web3, localProviderPort, contractABI, contractAddress) {
    this.web3 = web3;
    this.contractAddress = contractAddress;
    if (typeof web3 !== 'undefined') {
      this.web3 = new Web3(web3.currentProvider);
    } else { // set the provider you want from Web3.providers
      this.web3 = new Web3(new Web3.providers.HttpProvider(`http://localhost:${localProviderPort}`));
    }
    this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
    console.log(this.web3.eth.accounts[0]);
    this.database = this.web3.eth.contract(contractABI).at(contractAddress);
    console.log(this.database);
  }

  addCopyright(fingerprint) {
    const response = this.database.addCopyright(fingerprint)
    console.log(response)
  }
  sellCopyright(fingerprint, price) {
    const response = this.database.sellCopyright(fingerprint, price)
    console.log(response)
  }
  buyCopyright(fingerprint) {
    const response = this.database.buyCopyright(fingerprint)
    console.log(response)
  }
  checkBalance() {
    // this.web3._eth.getBalance(this.contractAddress).then(function (balance) {
    //   console.log(`Balance of ${this.contractAddress}: ${balance}`);
    // })
    // console.log(this.web3.eth);
    // this.web3.eth.getGasPrice((price) => console.log(price));
    console.log(this.database._eth.getBalance());
    
    // console.log(this.web3.eth.getGasPrice((data) => console.log(data)));
    
    // this.web3.eth.getGasPrice().then(function (gasPrice) {
    //   console.log(`Gas Price: ${gasPrice}`);
    // })
  }
}
