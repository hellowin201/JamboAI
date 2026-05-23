import { defineStore } from 'pinia';

export const useJamboaiMerchantSession = defineStore('jamboaiMerchantSession', {
  state: () => ({
    tenantId: '',
    merchantId: '',
    staffId: '',
    activeSessionId: ''
  }),
  actions: {
    selectConversation(sessionId: string) {
      this.activeSessionId = sessionId;
    }
  }
});
