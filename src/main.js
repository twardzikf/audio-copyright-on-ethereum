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
  },
  data: {
    web3Provider: null,
    web3: null,
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
      // console.log(web3.eth.getAccounts());
      // web3.eth.defaultAccount = accounts[0]
    },
    initContract: function () {
        // Get the necessary contract artifact file and instantiate it with @truffle/contract
        $.getJSON("/static/idDatabase.json", function(data) {
          this.contracts.ipDatabase = TruffleContract(data);
          this.contracts.ipDatabase.setProvider(this.web3Provider);
        }.bind(this));
        
  
        // Set the provider for our contract
        
  
        // Use our contract to retrieve and mark the adopted pets
        // return App.markAdopted();
    },
  },
  template: '<App />'
})
