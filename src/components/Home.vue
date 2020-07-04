<template>
  <div id="home">
    <md-button 
      class="md-raised md-accent"
      @click="$root.$emit('connect-to-account')"
    >
      Connect to your Eth account!
    </md-button>
  </div>
</template>

<script>
export default {
  name: 'Home',
}
</script>
