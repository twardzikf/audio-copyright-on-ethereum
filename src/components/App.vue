<template>
  <div id="app">
    <md-app class="md-app">
      <md-app-drawer md-permanent="full" class="header">
        <md-toolbar  md-elevation="0">
          <span class="md-title" @click="$router.push({ path: '/' })">Blockchain Copyright Manager</span>
        </md-toolbar>

        <md-list>
          <md-list-item @click="$router.push({ path: '/properties' })">
            <md-icon>audiotrack</md-icon>
            <span class="md-list-item-text">My IPs</span>
          </md-list-item>

          <md-list-item @click="$router.push({ path: '/market' })">
            <md-icon>storefront</md-icon>
            <span class="md-list-item-text">IP Market</span>
          </md-list-item>

          <md-list-item @click="$router.push({ path: '/auctions' })">
            <md-icon>connect_without_contact</md-icon>
            <span class="md-list-item-text">IP Auction House</span>
          </md-list-item>
        </md-list>
      </md-app-drawer>

      <md-app-content>
        <router-view />
      </md-app-content>
    </md-app>    
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style>
.md-app {
  height: 100vh;
}
.md-toolbar {
  background-color: #03DAC6 !important;
}
</style>
