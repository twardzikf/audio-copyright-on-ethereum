import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/components/Home'
import Auctions from '@/components/Auctions'
import Properties from '@/components/Properties'

Vue.use(Router)

export default new Router({
  routes: [
    {
      mode: 'history',
      path: '/',
      name: 'Root',
<<<<<<< HEAD
      component: Home
=======
      component: Home,
>>>>>>> 030266fdc4cb6049de79687a352f432f0d7d7525
    },
    {
      mode: 'history',
      path: '/auctions',
      name: 'Auctions',
<<<<<<< HEAD
      component: Auctions
=======
      component: Auctions,
>>>>>>> 030266fdc4cb6049de79687a352f432f0d7d7525
    },
    {
      mode: 'history',
      path: '/properties',
      name: 'Properties',
<<<<<<< HEAD
      component: Properties
=======
      component: Properties,
>>>>>>> 030266fdc4cb6049de79687a352f432f0d7d7525
    },
  ]
})
