<template>
  <div>
    <div class="section">
      <span class="title">Properties available for buying:</span>
      <md-table>
        <md-table-row>
          <md-table-head md-numeric>#</md-table-head>
          <md-table-head>Name</md-table-head>
          <md-table-head>Fingerprint</md-table-head>
          <md-table-head>Owner</md-table-head>
          <md-table-head>Price</md-table-head>
          <md-table-head></md-table-head>
        </md-table-row>
        <md-table-row
          v-for="(property, index) in propertiesForSell"
          :key="property.fingerprint"
        >
          <md-table-cell md-numeric>{{ (index + 1) }}</md-table-cell>
          <md-table-cell>{{ property.title }}</md-table-cell>
          <md-table-cell>{{ property.fingerprint }}</md-table-cell>
          <md-table-cell>{{ property.owner }}</md-table-cell>
          <md-table-cell>{{ property.price }}</md-table-cell>
          <md-table-cell>
            <md-button class="md-raised" @click="$root.$emit('buy-ip', property.fingerprint, property.price)">
                Buy
            </md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
    </div>
  </div>
</template>
<script>
export default {
  name: "Market",
  computed: {
    propertiesForSell() {
      return this.$root.$data.propertiesForSell;
    },
  },
  methods: {
  }
};
</script>
<style scoped>
.section {
  padding: 0.5rem 0;
  border-bottom: 2px solid #03DAC6;
}
.title {
  font-size: 1.25rem;
  color: black;
  margin-bottom: 0.5rem;
}
</style>