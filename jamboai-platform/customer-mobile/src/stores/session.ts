import { defineStore } from 'pinia';

export const useJamboaiCustomerSession = defineStore('jamboaiCustomerSession', {
  state: () => ({
    tenantId: '',
    memberId: '',
    merchantId: '',
    whatsappId: ''
  }),
  actions: {
    bindWhatsapp(whatsappId: string) {
      this.whatsappId = whatsappId;
    }
  }
});
