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
  },
  data: {
    web3Provider: null,
    web3: null,
    account: null,
    contracts: {},

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
    initContract: function () {
        // Get the necessary contract artifact file and instantiate it with @truffle/contract
        $.getJSON("/static/idDatabase.json", function(data) {
          this.contracts.ipDatabase = TruffleContract(data);
          this.contracts.ipDatabase.setProvider(this.web3Provider);
        }.bind(this));
    },
    initAddress: function() {
      web3.eth.getAccounts(function(error, accounts) {
        console.log(this);
        
        this.$data.account = accounts[0]
        console.log('account: ' + this.$data.account);
        if (error) {
          console.log(error);
        }
      }.bind(this));
    }
  },
  template: '<App />'
})
