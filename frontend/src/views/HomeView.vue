<template>
  <div class="grid-container">
    <div class="add-button-container">
      <Button icon="pi pi-plus" label="Add Document" class="p-button-success" @click="visible = true" />
    </div>

    <div class="grid">
      <Card v-for="item in items" :key="item.id" class="card">
        <template #title>
          <h3>{{ item.title }}</h3>
          <Button icon="pi pi-external-link" class="p-button-rounded p-button-text p-button-plain" />
        </template>
        <template #content>
          <img :src="item.imageUrl" class="card-image">
          <p class="card-content">{{ item.content }}</p>
        </template>
      </Card>
    </div>
  </div>

  <Dialog v-model:visible="visible" modal header="Add a new document" :style="{ width: '25rem' }">
    <span class="p-text-secondary block mb-5">Document details</span>
    <div class="flex align-items-center gap-3 mb-3">
      <label for="document-name" class="font-semibold w-6rem">Name of Document</label>
      <InputText id="document-name" class="flex-auto" autocomplete="off" v-model="newDocName" />
    </div>
    <div class="flex justify-content-end gap-2">
      <Button type="button" label="Cancel" severity="secondary" @click="visible = false"></Button>
      <Button type="button" label="Save" @click="addDocument(0, newDocName, 'Document content here...'); visible = false"></Button>
    </div>
  </Dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import Card from 'primevue/card';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';


const items = ref([
  { id: 1, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 2, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 3, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 4, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 5, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 6, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  { id: 7, title: 'Horrid Nodewar Guide', imageUrl: '../assets/images/img_1.png', content: 'Document content here...' },
  // ...other items
]);

const visible = ref(false);

const newDocName = ref('');

const addDocument = (docId: number, docName: string) => {
  // Add the new document to the items array
  items.value.push({ id: docId, title: docName, imageUrl: '../assets/images/img_1.png', content: "" });
  console.log(docId, docName);
};

</script>

<style scoped>
.grid-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.card {
  display: flex;
  flex-direction: column;
}

.card-image {
  width: 100%;
  height: auto;
  margin-bottom: 1rem;
}

.card-content {
  margin-top: auto;
}

.add-button-container {
  margin-bottom: 1rem;
  text-align: right;
}

@media (min-width: 640px) {
  .grid {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (min-width: 768px) {
  .grid {
    grid-template-columns: repeat(4, 1fr);
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(5, 1fr);
  }
}
</style>
