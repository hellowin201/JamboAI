<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>JamboAI Merchant</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-list inset>
        <ion-item>
          <ion-label>
            <h2>WhatsApp Inbox</h2>
            <p>AI assisted sessions and handover alerts</p>
          </ion-label>
          <ion-badge color="warning">3</ion-badge>
        </ion-item>
        <ion-item>
          <ion-label>
            <h2>Orders</h2>
            <p>Pending payment and fulfillment queue</p>
          </ion-label>
        </ion-item>
        <ion-item>
          <ion-label>
            <h2>Products & Services</h2>
            <p>Catalog used by the agent runtime</p>
          </ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import {
  IonBadge,
  IonContent,
  IonHeader,
  IonItem,
  IonLabel,
  IonList,
  IonPage,
  IonTitle,
  IonToolbar
} from '@ionic/vue';
</script>
