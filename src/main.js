import Vue from 'vue'
import App from './components/App.vue'
import router from './router'
import axios from 'axios'
import TruffleContract from 'truffle-contract'


import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'

Vue.use(VueMaterial)

Vue.config.devtools = true
Vue.config.productionTip = false
Vue.prototype.$http = axios

/* eslint-disable no-new */

new Vue({
  el: '#app',
  router,
  components: { App },
  created: async function () {
    await this.initWeb3();
    await this.initContract();
    await this.initAddress();
    this.fetchProperties();

    this.$root.$on('connect-to-account', () => {
      console.log('Connect to account')
    })
    this.$root.$on('buy-ip', (fingerprint) => {
      console.log(`Buy ip ${fingerprint}`)
    })
    this.$root.$on('offer-ip-for-sell', (data) => {
      console.log(`Offer ip for sell ${data.fingerprint} for: ${data.price}`)
      this.offerIpForSell(data.fingerprint, data.price);
    })
    this.$root.$on('add-fingerprint', (file, title) => {
      console.log(`add fingerpint`)
      this.calculateFingerprint(file, title)
    })
  },
  data: function () {
    return {
      web3Provider: null,
      web3: null,
      account: null,
      contracts: {},
      ownProperties: [],
      propertiesForSell: [
        { fingerprint: 'xyzjapierdole', title: 'An audio file #3', owner: '0xSomeone', price: '0.003 ETH' },
        { fingerprint: 'noichujnoiczesc', title: 'An audio file #4', owner: '0xNoone', price: '0.0009 ETH' },
      ],
    }
  },
  methods: {
    initWeb3: async function () {
      if (window.ethereum) {
        this.web3Provider = window.ethereum;
        try {
          // Request account access
          await window.ethereum.enable();
        } catch (error) {
          // User denied account access...
          console.error("User denied account access");
        }
      }
      // Legacy dapp browsers...
      else if (window.web3) {
        this.web3Provider = window.web3.currentProvider;
      }
      // If no injected web3 instance is detected, fall back to Ganache
      else {
        this.web3Provider = new Web3.providers.HttpProvider(
          "http://localhost:7545"
        );
      }
      web3 = new Web3(this.web3Provider);
    },
    initContract: async function () {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      await $.getJSON("/static/PropertiesDB.json", function (data) {
        this.contracts.propertiesDB = TruffleContract(data);
        this.contracts.propertiesDB.setProvider(this.web3Provider);
        // this.fetchProperties(this);
      }.bind(this));
    },
    initAddress: function () {
      web3.eth.getAccounts(function (error, accounts) {
        console.log(this);

        this.$data.account = accounts[0]
        console.log('account: ' + this.$data.account);
        if (error) {
          console.log(error);
        }
      }.bind(this));
    },
    calculateFingerprint(file, title) {
      const baseURI = "http://localhost:3000/";
      var formData = new FormData();
      formData.append("song", file);

      this.$http
        .post(baseURI, formData, {
          headers: {
            "Content-Type": "multipart/form-data"
          }
        })
        .then(data => {
          const fingerprint = data.data.data.fingerprint;
          let ipDb;
          const account = this.$root.$data.account;

          console.log(web3);
          this.$root.$data.contracts.propertiesDB
            .deployed()
            .then(function (instance) {
              ipDb = instance;

              console.log(ipDb);

              return ipDb.addProperty(fingerprint, title, { from: account });
            })
            .then(function (result) {
              console.log(result);
              this.fetchProperties();
            }.bind(this))
            .catch(function (err) {
              console.log(err.message);
            });
        });
    },
    fetchProperties: function () {
      this.$root.$data.contracts.propertiesDB
        .deployed()
        .then(function (instance) {
          return instance.fetchProperties({ from: this.$root.$data.account })
        }.bind(this))
        .then(function (result) {
          this.$root.$data.ownProperties = result;
        }.bind(this))
    },
    offerIpForSell: function (fingerpint, price) {
      this.$root.$data.contracts.propertiesDB
        .deployed()
        .then(function (instance) {
          return instance.offerPropertyForSale(fingerpint, price, { from: this.$root.$data.account })
        }.bind(this))
        .then(function (result) {
          console.log(result);
        });
    }
  },
  template: '<App />'
})
