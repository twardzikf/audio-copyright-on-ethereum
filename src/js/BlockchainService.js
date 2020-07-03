
import Web3 from 'web3';

export default (web3, localProviderPort, contractABI) => {
      this.web3 = web3;
      if (typeof web3 !== 'undefined') {
        this.web3 = new Web3(web3.currentProvider);
      } else { // set the provider you want from Web3.providers
       this.web3 = new Web3(new Web3.providers.HttpProvider(`http://localhost:${localProviderPort}`));
      }

      this.web3.eth.defaultAccount = this.web3.eth.accounts[0];
      this.database = this.web3.eth.contract(contractABI);

      this.addCopyright = (fingerprint) => {
        const response = this.database.addCopyright(fingerprint)
        console.log(response)
      },
      this.sellCopyright = (fingerprint, price) => {
        const response = this.database.sellCopyright(fingerprint)
        console.log(response)
      },
      this.buyCopyright = (fingerprint) => {
        const response = this.database. buyCopyright(fingerprint)
        console.log(response)
      }
    }
}