<template>
  <div class="auctions">
    <div class="section">
      <span class="title">My auctions:</span>
      <md-table>
        <md-table-row>
          <md-table-head md-numeric>#</md-table-head>
          <md-table-head>Title</md-table-head>
          <!-- <md-table-head>Fingerprint</md-table-head> -->
          <md-table-head>Minimal Price</md-table-head>
          <md-table-head>Highest Offer</md-table-head>
          <md-table-head>Expires</md-table-head>
          <md-table-head>Actions</md-table-head>
        </md-table-row>
        <md-table-row v-for="(auction, index) in ownAuctions" :key="auction.fingerprint">
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ auction.fingerprint | truncate(20, '...') }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ ( parseInt(auction.startPrice) / Math.pow(10, 18)) + 'Eth' }}</md-table-cell>
          <md-table-cell>{{ (parseInt(auction.highestOffer) / Math.pow(10, 18)) + 'Eth' }}</md-table-cell>
          <md-table-cell>{{ new Date(parseInt(auction.endTime) * 1000).toDateString() }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-icon-button" @click="openEditDialog(auction.fingerprint)" :disabled="auction.highestOffer !== '0'">
              <md-icon>edit</md-icon>
            </md-button>
            <md-tooltip md-direction="left" v-if="auction.highestOffer !== '0'">Auction already in progress</md-tooltip>
            <md-button
              class="md-icon-button md-accent"
              @click="openRemoveDialog(auction[0])"
            >
              <md-icon md-src="/static/stop.svg" />
            </md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
      <md-dialog :md-active.sync="isEditDialogActive">
        <md-dialog-title>Edit auction conditions</md-dialog-title>
        <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
          <md-field>
            <md-icon md-src="/static/ethereum.svg" />
            <label>Minimal Price</label>
            <md-input type="number" v-model="editForm.minPrice"></md-input>
          </md-field>
          <md-datepicker v-model="editForm.expiry">
            <label>Expires</label>
          </md-datepicker>
        </div>
        <md-dialog-actions>
          <md-button class="md-primary" @click="isEditDialogActive = false">Cancel</md-button>
          <md-button class="md-primary" @click="onEditProperty(editForm.fingerprint)">Save</md-button>
        </md-dialog-actions>
      </md-dialog>

      <md-dialog :md-active.sync="isRemoveDialogActive">
        <md-dialog-title>Finish auction</md-dialog-title>
        <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
          <p>Are you sure you want to finish this auction?</p>
        </div>
        <md-dialog-actions>
          <md-button class="md-primary" @click="isRemoveDialogActive = false">Cancel</md-button>
          <md-button class="md-accent" @click="onRemoveFromToSell(removeForm.fingerprint)">Finish</md-button>
        </md-dialog-actions>
      </md-dialog>
    </div>
    <div class="section">
      <span class="title">Auctions:</span>
      <md-table>
        <md-table-row>
          <md-table-head md-numeric>#</md-table-head>
          <md-table-head>Title</md-table-head>
          <!-- <md-table-head>Fingerprint</md-table-head> -->
          <md-table-head>Minimal Price</md-table-head>
          <md-table-head>Highest Offer</md-table-head>
          <md-table-head>Expires</md-table-head>
          <md-table-head>Actions</md-table-head>
        </md-table-row>
        <md-table-row v-for="(auction, index) in auctions" :key="auction.fingerprint">
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ auction.fingerprint | truncate(20, '...') }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ ( parseInt(auction.startPrice) / Math.pow(10, 18)) + 'Eth' }}</md-table-cell>
          <md-table-cell>{{ (parseInt(auction.highestOffer) / Math.pow(10, 18)) + 'Eth' }}</md-table-cell>
          <md-table-cell>{{ new Date(parseInt(auction.endTime) * 1000).toDateString() }}</md-table-cell>
          <md-table-cell>
            <md-button
              class="md-icon-button md-primary"
              @click="openOfferDialog(auction.fingerprint)"
            >
              <md-icon md-src="/static/money-check-alt-solid.svg" />
              <md-tooltip md-direction="top">Make an offer</md-tooltip>
            </md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
      <md-dialog :md-active.sync="isOfferDialogActive">
        <md-dialog-title>Make an offer</md-dialog-title>
        <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
          <md-field>
            <md-icon md-src="/static/ethereum.svg" />
            <label>Your offer</label>
            <md-input type="number" v-model="offerForm.offerValue"></md-input>
          </md-field>
        </div>
        <md-dialog-actions>
          <md-button class="md-primary" @click="isOfferDialogActive = false">Cancel</md-button>
          <md-button class="md-primary" @click="onMakeOffer(offerForm.fingerprint)">Save</md-button>
        </md-dialog-actions>
      </md-dialog>
    </div>
  </div>
</template>
<script>
export default {
  name: "Auctions",
  computed: {
    ownAuctions() {
      return this.$root.$data.ownAuctions;
    },
    auctions() {
      return this.$root.$data.auctions;
    }
  },
  data() {
    return {
      isEditDialogActive: false,
      editForm: {
        minPrice: null,
        expiry: null,
        fingerprint: null
      },
      isRemoveDialogActive: false,
      removeForm: {
        fingerprint: null
      },
      isOfferDialogActive: false,
      offerForm: {
        fingerprint: null,
        offerValue: null
      }
    };
  },
  methods: {
    onEditProperty(fingerprint) {
      console.log({
        fingerprint: fingerprint,
        minPrice: this.editForm.minPrice,
        expiry: this.editForm.expiry
      });

      this.$root.$emit("change-property-to-sell", {
        fingerprint: fingerprint,
        minPrice: this.editForm.minPrice,
        expiry: this.editForm.expiry
      });
      this.isEditDialogActive = false;
    },
    onRemoveFromToSell(fingerprint) {
      this.$root.$emit("remove-from-to-sell", { fingerprint: fingerprint });
      this.isRemoveDialogActive = false;
    },
    onMakeOffer(fingerprint) {
      this.$root.$emit("make-offer", {
        fingerprint: fingerprint,
        offerValue: this.offerForm.offerValue
      });
      this.isOfferDialogActive = false;
    },
    openRemoveDialog(fingerprint) {
      this.isRemoveDialogActive = true;
      this.removeForm.fingerprint = fingerprint;
    },
    openEditDialog(fingerprint) {
      this.isEditDialogActive = true;
      this.editForm.fingerprint = fingerprint;
    },
    openOfferDialog(fingerprint) {
      this.isOfferDialogActive = true;
      this.offerForm.fingerprint = fingerprint;
    }
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
</style>