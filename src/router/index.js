import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Market from '@/components/Market'
import Auctions from '@/components/Auctions'
import Properties from '@/components/Properties'

Vue.use(Router)

export default new Router({
  routes: [
    {
      mode: 'history',
      path: '/',
      name: 'Root',
      component: Properties
    },
    {
      mode: 'history',
      path: '/auctions',
      name: 'Auctions',
      component: Auctions
    },
    {
      mode: 'history',
      path: '/properties',
      name: 'Properties',
      component: Properties
    },
    {
      mode: 'history',
      path: '/market',
      name: 'Market',
      component: Market
    },
  ]
})
