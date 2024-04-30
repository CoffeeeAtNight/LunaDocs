/* eslint-disable vue/multi-word-component-names */
import { createApp } from 'vue'
import PrimeVue from 'primevue/config';
import App from './App.vue'
import router from './router'
import Card from 'primevue/card';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';
import ToastService from 'primevue/toastservice';
import Editor from 'primevue/editor';
import { createPinia } from 'pinia'


import 'primevue/resources/themes/aura-dark-pink/theme.css'
import 'primevue/resources/primevue.min.css'
import "primeflex/primeflex.css"
import 'primeicons/primeicons.css'


const app = createApp(App)
const pinia = createPinia()

app.use(router)
app.use(PrimeVue)
app.use(ToastService);
app.use(pinia)

app.component('Card', Card)
app.component('Button', Button)
app.component('Dialog', Dialog)
app.component('Editor', Editor);
app.mount('#app')
