<template>
  <div class="header">
    <div class="header__title">
      Copyright Blockchain Solution 
    </div>
    <div class="header_menu">
      <router-link to="/properties" class="menu-link" :class="{ 'active-link': isRouteActive('/properties') }">
        Properties      
      </router-link>
      <router-link to="/auctions" class="menu-link" :class="{ 'active-link': isRouteActive('/auctions') }">
        Auctions
      </router-link>
    </div>
  </div>
</template>
<script>
export default {
  name: 'Header',
  props: {
  },
  methods: {
    isRouteActive(name) {
      return this.$route.path === name
    }
  }
}
</script>
<style scoped>
.header {
  height: 100px;
  width: 100%;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  border-bottom: 2px solid #00C0F5;
  padding-bottom: 0.5rem;
}

.header__title {
  font-size: 1.5rem;
  color: #094074;
}

.header__menu {

}
.menu-link {
  text-decoration: none;
  margin-left: 0.5rem;
  color: darkgray;
}
.active-link {
  color: #00C0F5;
}


</style>