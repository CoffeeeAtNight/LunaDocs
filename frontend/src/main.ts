/* eslint-disable vue/multi-word-component-names */
import { createApp } from 'vue'
import PrimeVue from 'primevue/config';
import App from './App.vue'
import router from './router'
import Card from 'primevue/card';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';


import 'primevue/resources/themes/aura-dark-pink/theme.css'
import 'primevue/resources/primevue.min.css'


const app = createApp(App)
app.use(router)
app.use(PrimeVue)
app.component('Card', Card)
app.component('Button', Button)
app.component('Dialog', Dialog)
app.mount('#app')
