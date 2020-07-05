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
          <md-table-head>Actions</md-table-head>
        </md-table-row>
        <md-table-row v-for="(auction, index) in ownAuctions" :key="auction.fingerprint">
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ auction.title }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ auction.minPrice }}</md-table-cell>
          <md-table-cell>{{ auction.highestOffer }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-icon-button">
              <md-icon>edit</md-icon>
            </md-button>
            <md-button class="md-icon-button md-accent">
              <md-icon>delete</md-icon>
            </md-button>
          </md-table-cell>
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
          <md-table-head>Actions</md-table-head>
        </md-table-row>
        <md-table-row v-for="(auction, index) in auctions" :key="auction.fingerprint">
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ auction.title }}</md-table-cell>
          <!-- <md-table-cell>{{ auction.fingerprint }}</md-table-cell> -->
          <md-table-cell>{{ auction.minPrice }}</md-table-cell>
          <md-table-cell>{{ auction.highestOffer }}</md-table-cell>
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
  methods: {}
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