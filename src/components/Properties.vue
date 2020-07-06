<template>
  <div class="properties">
    <div class="section md-layout">
      <span class="title">Add property</span>
      <div class="md-layout md-gutter">
        <md-field class="md-layout-item md-size-40">
          <label style="margin-left: 0.5rem;">Choose audio file</label>
          <md-file name="song" id="song-input" @change="getFileBytesArray" />
        </md-field>
        <md-field class="md-layout-item md-size-30">
          <label>Title</label>
          <md-input name="title" id="title-input" v-model="title" />
        </md-field>
        <md-button
          class="md-raised md-primary md-layout-item md-size-10"
          @click="$root.$emit('add-fingerprint', file, title)"
        >Upload</md-button>
      </div>
    </div>
    <div class="section">
      <span class="title">My properties</span>
      <md-table>
        <md-table-row>
          <md-table-head md-numeric>#</md-table-head>
          <md-table-head>Name</md-table-head>
          <md-table-head>
            Fingerprint
            <!-- <md-icon>fingerprint</md-icon> -->
          </md-table-head>
          <md-table-head></md-table-head>
        </md-table-row>
        <md-table-row v-for="(property, index) in ownProperties" :key="property.fingerprint">
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ property.title }}</md-table-cell>
          <md-table-cell>{{ property.fingerprint | truncate(20, '...') }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-raised md-dense md-primary" @click="openDialog(property.fingerprint)">Offer for sell</md-button>
            <md-button class="md-raised md-dense md-primary" @click="openAuctionDialog(property.fingerprint)">Create an auction</md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
    </div>
    <md-dialog-prompt
      :md-active.sync="isDialogActive"
      md-title="Set price for your IP"
      md-input-maxlength="15"
      md-input-placeholder
      md-confirm-text="Offer for sell"
      @md-confirm="onConfirmOfferForSell"
    />
    <md-dialog :md-active.sync="isAuctionDialogActive">
      <md-dialog-title>Create an auction</md-dialog-title>
      <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
        <md-field>
          <md-icon md-src="/static/ethereum.svg" />
          <label>Minimum price</label>
          <md-input type="number" v-model="auctionForm.minPrice"></md-input>
        </md-field>
        <md-datepicker v-model="auctionForm.expires">
          <label>Expires</label>
        </md-datepicker>
      </div>
      <md-dialog-actions>
        <md-button class="md-primary" @click="isAuctionDialogActive = false">Close</md-button>
        <md-button class="md-primary" @click="onCreateAuction(auctionForm.fingerprint)">Save</md-button>
      </md-dialog-actions>
    </md-dialog>
  </div>
</template>
<script>
export default {
  name: "Properties",
  data() {
    return {
      file: null,
      title: "",
      isDialogActive: false,
      selectedFingerprint: "",
      isAuctionDialogActive: false,
      auctionForm: {
        minPrice: null,
        expires: null,
        fingerprint: null
      }
    };
  },
  computed: {
    ownProperties() {
      return this.$root.$data.ownProperties;
    }
  },
  methods: {
    openDialog(fingerprint) {
      this.selectedFingerprint = fingerprint;
      console.log(this.selectedFingerprint);
      this.isDialogActive = true;
    },
    openAuctionDialog(fingerprint) {
      this.auctionForm.fingerprint = fingerprint;
      this.isAuctionDialogActive = true;
    },
    getFileBytesArray(event) {
      this.file = event.target.files[0];
    },
    onConfirmOfferForSell(value) {
      this.$root.$emit("offer-ip-for-sell", {
        fingerprint: this.selectedFingerprint,
        price: value
      });
    },
    onCreateAuction(fingerprint) {
      this.$root.$emit("create-auction", { 
        fingerprint: fingerprint,
        minPrice: this.auctionForm.minPrice,
        expires: this.auctionForm.expires
      });
      this.isAuctionDialogActive = false
    },
  }
};
</script>
<style scoped>
.section {
  padding: 0.5rem 0;
  border-bottom: 2px solid #03dac6;
}
.title {
  font-size: 1.25rem;
  color: black;
  margin-bottom: 0.5rem;
}
.md-field {
  margin-right: 0.5rem;
}
</style>