import { createRouter, createWebHistory } from '@ionic/vue-router';
import MerchantHome from '../views/MerchantHome.vue';

export default createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'merchant-home',
      component: MerchantHome
    }
  ]
});
