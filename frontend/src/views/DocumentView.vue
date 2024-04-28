<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useDocumentStore } from '@/stores/documentStore';
import { useToast } from "primevue/usetoast";
import Toolbar from 'primevue/toolbar';
import Button from 'primevue/button';
import Editor, { EditorTextChangeEvent } from 'primevue/editor';


const documentStore = useDocumentStore();
const toast = useToast();

const documentId = ref('');
const documentName = ref('');
const documentContent = ref('');

const listOfEditors = ref([] as string[]);

onMounted(() => {
  listOfEditors.value.push("Me");
  documentId.value = documentStore.documentId.toString();
  documentName.value = documentStore.documentName.toString();
  documentContent.value = documentStore.documentContent.toString();
});

const onTextChange = (event: EditorTextChangeEvent) => {
  console.log(event.textValue);
}
</script>

<template>
  <Toolbar>
    <template #start>
      <div class="header-details text-left">
        <h1 class="text-primary m-0">{{ documentName }}</h1>
      </div>
    </template>

    <template #center>
      <ButtonGroup>
        <Button label="Save" icon="pi pi-check" class="mr-3"/>
        <Button label="Go back" icon="pi pi-sign-out" />
      </ButtonGroup>
    </template>

    <template #end>
      <div class="people-editing-currently flex py-1">
        <h5 class="text-primary m-0">Peps currently editing:</h5>
        <p class="text-sm text-color font-light m-0 px-1" v-for="editor in listOfEditors" :key="editor">
          <span class="font-semibold">{{ editor }} <span
              v-if="listOfEditors.length > 1 && editor !== listOfEditors[listOfEditors.length - 1]">,</span></span>
        </p>
      </div>
    </template>
  </Toolbar>


  <Editor v-model="documentContent" editorStyle="height: 83vh" class="pt-3" @text-change="onTextChange" />

  <Toast />
</template>
