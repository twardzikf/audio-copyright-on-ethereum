<template>
  <div class="properties">
    <div class="section md-layout">
      <md-field class="md-layout-item md-size-70">
        <label>Choose audio file</label>
        <md-file name="song" id="song-input" v-on:change="getFileBytesArray" />
      </md-field>
      <md-button
        class="md-raised md-primary md-layout-item md-size-10"
        v-on:click="calculateFingerprint"
      >Upload</md-button>
    </div>
    <div class="section">
      <span class="title">My properties</span>
    </div>
    <div class="section">
      <span class="title">Properties for sell</span>
    </div>
  </div>
</template>
<script>
import BlockchainService from "../js/BlockchainService";
export default {
  name: "Properties",
  props: {},
  data: function() {
    return {
      file: null,
      root: this.$root
    };
  },
  created: function() {
    console.log(this.$root);
  },
  methods: {
    calculateFingerprint: function() {
      const baseURI = "http://localhost:3000/";
      const ABI = [
        {
          constant: false,
          inputs: [
            {
              internalType: "string",
              name: "_fingerprint",
              type: "string"
            }
          ],
          name: "addCopyright",
          outputs: [],
          payable: false,
          stateMutability: "nonpayable",
          type: "function"
        },
        {
          constant: false,
          inputs: [
            {
              internalType: "string",
              name: "_fingerprint",
              type: "string"
            }
          ],
          name: "buyCopyright",
          outputs: [],
          payable: true,
          stateMutability: "payable",
          type: "function"
        }
      ];
      var formData = new FormData();
      formData.append("song", this.file);
      this.$http
        .post(baseURI, formData, {
          headers: {
            "Content-Type": "multipart/form-data"
          }
        })
        .then(data => {
          console.log(data);
          const blockchainService = new BlockchainService(
            document.web3,
            "7545",
            ABI,
            "2Cf0DB0A674db2ABC35518e2E9edc87234c4F883"
          );
          // blockchainService.addCopyright(data.data.fingerprint);

          var fingerprint = data.data.fingerprint;

          var ipDb;

          this.$root.$data.web3.eth.getAccounts(function(error, accounts) {
            console.log(error + '\n' + accounts);
            if (error) {
              console.log(error);
            }

            var account = accounts[0];

            this.$root.$data.contracts.ipDatabase
              .deployed()
              .then(function(instance) {
                ipDb = instance;

                // Execute adopt as a transaction by sending account
                return ipDb.addCopyright(fingerprint);
              })
              .then(function(result) {
                console.log(result);
                // return Aprp.markAdopted();
              })
              .catch(function(err) {
                console.log(err.message);
              });
          });
        });
    },
    getFileBytesArray: function(event) {
      this.file = event.target.files[0];
    }
  }
};
</script>
<style scoped>
.section {
  padding: 0.5rem 0;
  border-bottom: 1px solid #00c0f5;
}
.title {
  font-size: 1.25rem;
  color: black;
}

input {
  appearance: none;
  border: none;
  min-width: 0;
  font-family: sans-serif;
  line-height: 1;
  background: transparent;
}
</style>