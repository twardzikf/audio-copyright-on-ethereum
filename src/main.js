import Vue from 'vue'
import App from './components/App.vue'
import router from './router'
import store from './store'
import axios from 'axios'


import VueMaterial from 'vue-material'
import 'vue-material/dist/vue-material.min.css'
import 'vue-material/dist/theme/default.css'

Vue.use(VueMaterial)

Vue.config.devtools = true
Vue.config.productionTip = false
Vue.prototype.$http = axios

/* eslint-disable no-new */

new Vue({
  el: '#app',
  router,
  store,
  components: { App },

  created: function () {
  },
    
  template: '<App />'
})
