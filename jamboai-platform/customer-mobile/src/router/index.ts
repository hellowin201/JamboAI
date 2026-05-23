import { createRouter, createWebHistory } from '@ionic/vue-router';
import CustomerHome from '../views/CustomerHome.vue';

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'customer-home',
      component: CustomerHome
    }
  ]
});
