<template>
  <div id="app">
    <Header />
    <div class="main">
      <router-view
        :is-d-app-ready="isDAppReady"
        :current-view="currentView"
        :is-valid-user-but="isValidUserBut"
        @log-user-in="logUserIn"
        @log-user-out="logUserOut"
      />
    </div>
    
  </div>
</template>

<script>
import Header from './Header'
export default {
  name: 'App',
  components: {
    Header,
  },
  props: {
    isDAppReady: {
      type: Boolean,
      default: false
    },
    currentView: {
      type: Object,
      default: null
    },
    isValidUserBut: {
      type: String,
      default: '0'
    }
  },
  methods: {
    logUserIn (evt) {
      this.$emit('log-user-in', evt)
    },
    logUserOut (evt) {
      this.$emit('log-user-out', evt)
    }
  }
}

</script>

<style>
  body {
    margin: 0;
    width: 100%;
    font-family: Arial, Helvetica, sans-serif;
  }

  * {
    box-sizing: border-box;
  }

  textarea {
    resize: none;
  }

  #app {
    display: flex;
    flex-direction: column;
    color: #2c3e50;
    width: 100%;
    max-width: 960px;
    margin: auto;
  }
</style>
