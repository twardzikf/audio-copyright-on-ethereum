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
          <md-table-cell>{{ auction.title }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ auction.minPrice }}</md-table-cell>
          <md-table-cell>{{ auction.highestOffer }}</md-table-cell>
          <md-table-cell>{{ auction.expiry }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-icon-button" @click="isEditDialogActive = true">
              <md-icon>edit</md-icon>
            </md-button>
            <md-button class="md-icon-button md-accent" @click="isRemoveDialogActive = true">
              <md-icon>delete</md-icon>
            </md-button>
          </md-table-cell>

          <md-dialog :md-active.sync="isEditDialogActive">
            <md-dialog-title>Edit auction conditions</md-dialog-title>
            <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
              <md-field>
                <md-icon>attach_money</md-icon>
                <label>Minimal Price</label>
                <md-input type="number" v-model="editForm.minPrice"></md-input>
              </md-field>
              <md-datepicker v-model="editForm.expiry">
                <label>Expires</label>
              </md-datepicker>
            </div>
            <md-dialog-actions>
              <md-button class="md-primary" @click="isEditDialogActive = false">Close</md-button>
              <md-button class="md-primary" @click="onEditProperty(auction.fingerprint)">Save</md-button>
            </md-dialog-actions>
          </md-dialog>

          <md-dialog :md-active.sync="isRemoveDialogActive">
            <md-dialog-title>Cancel auction</md-dialog-title>
            <div class="md-layout" style="margin-left: 1.5rem; margin-right: 1.5rem;">
              <p>
                Are you sure you want to cancel this auction?
              </p>
            </div>
            <md-dialog-actions>
              <md-button class="md-primary" @click="isRemoveDialogActive = false">Close</md-button>
              <md-button class="md-accent" @click="onRemoveFromToSell(auction.fingerprint)">Remove</md-button>
            </md-dialog-actions>
          </md-dialog>

        </md-table-row>
      </md-table>
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
          <md-table-cell>{{ auction.title }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ auction.minPrice }}</md-table-cell>
          <md-table-cell>{{ auction.highestOffer }}</md-table-cell>
          <md-table-cell>{{ auction.expiry }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-icon-button md-primary">
              <md-icon md-src="/static/money-check-alt-solid.svg" />
              <md-tooltip md-direction="top">Make an offer</md-tooltip>
            </md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
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
        expiry: null
      },
      isRemoveDialogActive: false,
    };
  },
  methods: {
    onEditProperty(fingerprint) {
      console.log({ fingerprint: fingerprint, minPrice:  this.editForm.minPrice, expiry: this.editForm.expiry });
      
      this.$root.$emit('change-property-to-sell', { fingerprint: fingerprint, minPrice:  this.editForm.minPrice, expiry: this.editForm.expiry })
      this.isEditDialogActive = false;
    },
    onRemoveFromToSell(fingerprint) {
      this.$root.$emit('remove-from-to-sell', {fingerprint: fingerprint});
      this.isRemoveDialogActive = false;
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