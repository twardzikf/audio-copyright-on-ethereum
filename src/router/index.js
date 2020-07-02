import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Auctions from '@/components/Auctions'
import Properties from '@/components/Properties'
import Web3Message from '@/components/sections/Web3Message.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      mode: 'history',
      path: '/',
      name: 'Root',
      component: Home,
      meta: { view: Web3Message }
    },
    {
      mode: 'history',
      path: '/auctions',
      name: 'Auctions',
      component: Auctions,
      meta: { view: Web3Message }
    },
    {
      mode: 'history',
      path: '/properties',
      name: 'Properties',
      component: Properties,
      meta: { view: Web3Message }
    },
  ]
})
