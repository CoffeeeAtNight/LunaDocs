<template>
  <div class="outer-padding">
    <Toolbar class="px-5 mb-5">
      <template #start>
        <h1 class="text-primary	">LunaDocs🌙</h1>
      </template>

      <template #end>
        <Button label="Delete" class="mr-3" icon="pi pi-trash" :disabled="!items.some(item => item.checked)"
          @click="deleteVisible = true" />
        <Button icon="pi pi-plus" label="Add" @click="visible = true" />
      </template>
    </Toolbar>

    <div class="grid-container">
      <div class="grid">
        <Card v-for="item in items" :key="item.id" class="card" @click="openDocument(item.id)">
          <template #title>
            <div class="title-container">
              <p class="title-text text-primary m-0">{{ item.title }}</p>
              <Checkbox v-model="item.checked" :binary="true" @click.stop />
            </div>
          </template>
          <template #content>
            <p v-if="item.content" class="m-0 px-1 text-sm">
              <span>Content preview: <br></span>
              <span class="font-light">{{ item.content.slice(0, 40) + '...' }}</span>
            </p>
          </template>
        </Card>
      </div>
    </div>

    <Dialog v-model:visible="visible" modal header="Add a new document" :style="{ width: '25rem' }">
      <span class="p-text-secondary block mb-5">Document details</span>
      <div class="flex align-items-center gap-3 mb-3">
        <label for="document-name" class="font-semibold w-6rem">Title</label>
        <InputText id="document-name" class="flex-auto" autocomplete="off" v-model="newDocName" />
      </div>
      <div class="flex justify-content-end gap-2">
        <Button type="button" label="Cancel" severity="secondary" @click="visible = false"></Button>
        <Button type="button" label="Create" @click="addDocument(0, newDocName); visible = false"></Button>
      </div>
    </Dialog>

    <Dialog v-model:visible="deleteVisible" modal header="Are you sure you want to remove?" :style="{ width: '25rem' }">
      <div class="flex justify-content-end gap-2">
        <Button type="button" label="Cancel" severity="secondary" @click="visible = false"></Button>
        <Button type="button" label="Remove" @click="removeSelectedDocuments(); visible = false"></Button>
      </div>
    </Dialog>
  </div>

  <div v-if="isLoading" class="loading-screen">
    <div class="loading-overlay">
      <ProgressSpinner style="width: 50px; height: 50px" strokeWidth="8" fill="var(--surface-ground)"
        animationDuration=".5s" aria-label="Custom ProgressSpinner" />
    </div>
  </div>


  <Toast />
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import Card from 'primevue/card';
import Button from 'primevue/button';
import Dialog from 'primevue/dialog';
import InputText from 'primevue/inputtext';
import Toolbar from 'primevue/toolbar';
import Checkbox from 'primevue/checkbox';
import Toast from 'primevue/toast';
import { useToast } from "primevue/usetoast";
import ProgressSpinner from 'primevue/progressspinner';
import { useDocumentStore } from '@/stores/documentStore';

const toast = useToast();
const router = useRouter();
const documentStore = useDocumentStore();

const items = ref([
  { id: 1, title: 'Test Document 1', content: 'Super cool document with very important information here', checked: false },
  { id: 2, title: 'Test Document 2', content: Array(Math.floor(Math.random() * 10) + 10).fill('Lorem ipsum ').join(''), checked: false },
  { id: 3, title: 'Test Document 3', content: Array(Math.floor(Math.random() * 10) + 10).fill('Dolor sit amet ').join(''), checked: false },
  { id: 4, title: 'Test Document 4', content: Array(Math.floor(Math.random() * 10) + 10).fill('Consectetur adipiscing ').join(''), checked: false },
  { id: 5, title: 'Test Document 5', content: Array(Math.floor(Math.random() * 10) + 10).fill('Elit sed do eiusmod ').join(''), checked: false },
  { id: 6, title: 'Test Document 6', content: Array(Math.floor(Math.random() * 10) + 10).fill('Tempor incididunt ut labore ').join(''), checked: false },
  { id: 7, title: 'Test Document 7', content: Array(Math.floor(Math.random() * 10) + 10).fill('Et dolore magna aliqua ').join(''), checked: false },
]);

const visible = ref(false);
const deleteVisible = ref(false);
const isLoading = ref(false);


const newDocName = ref('');

const addDocument = (docId: number, docName: string) => {
  items.value.push({ id: docId, title: docName, content: "", checked: false });
  toast.add({ severity: 'success', summary: 'Document Created', detail: 'Document created successfully', life: 3000 });
};

const removeSelectedDocuments = () => {
  items.value = items.value.filter(item => !item.checked);
  deleteVisible.value = false;
  toast.add({ severity: 'success', summary: 'Document Deleted', detail: 'Document deleted successfully', life: 3000 });
};

const openDocument = async (docId: number) => {
  isLoading.value = true; 
  console.log("Loading started");
  try {
    documentStore.openDocument(docId);
    documentStore.documentName = items.value.find(item => item.id === docId)?.title ?? "";
    setTimeout(async () => { 
      await router.push({ name: 'document', params: { id: docId.toString() } });
      toast.add({ severity: 'success', summary: 'Document Opened', detail: 'You have been redirected to the document.', life: 3000 });
      console.log("Loading finished");
      isLoading.value = false; 
    }, 1500);
  } catch (error) {
    console.error("Failed to open document:", error);
    toast.add({ severity: 'error', summary: 'Error', detail: 'Failed to open document.', life: 3000 });
  }
}
</script>

<style scoped>
.grid-container {
  width: 100%;
  margin: 0 auto;
}

.outer-padding {
  padding: 2rem;
}

.content-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
}

.card {
  display: flex;
  flex-direction: column;
  transition: box-shadow 0.3s ease-in-out, transform 0.3s ease-in-out, border-color 0.3s ease-in-out;
  border: 1px solid transparent;
}

.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0, 0.5);
  z-index: 1000;
  display: flex;
  justify-content: center;
  align-items: center;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  border: 1px solid var(--primary-color);
  cursor: pointer;
}

.heading-container h1 {
  margin: 0;
}

.card-image {
  width: 100%;
  height: auto;
  margin-bottom: 1rem;
}

.title-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
}

.title-text {
  flex-grow: 1;
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

@media (max-width: 768px) {
  .content-row {
    display: block;
  }

  .add-button-container {
    text-align: left;
  }
}

@media (min-width: 1024px) {
  .grid {
    grid-template-columns: repeat(5, 1fr);
  }
}
</style>
