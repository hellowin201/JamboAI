<template>
  <ion-page>
    <ion-header translucent>
      <ion-toolbar>
        <ion-title>JamboAI Customer</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content fullscreen>
      <ion-list inset>
        <ion-item>
          <ion-label>
            <h2>Merchant Chats</h2>
            <p>Continue WhatsApp conversations and orders</p>
          </ion-label>
        </ion-item>
        <ion-item>
          <ion-label>
            <h2>Recommendations</h2>
            <p>AI matched products and services</p>
          </ion-label>
        </ion-item>
        <ion-item>
          <ion-label>
            <h2>Payments</h2>
            <p>Flutterwave payment links and receipts</p>
          </ion-label>
        </ion-item>
      </ion-list>
    </ion-content>
  </ion-page>
</template>

<script setup lang="ts">
import {
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
