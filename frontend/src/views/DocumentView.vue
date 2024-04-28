<script setup lang="ts">
import { ref } from 'vue';
import Editor, { EditorTextChangeEvent } from 'primevue/editor';

const value = ref('');

const onTextChange = (event: EditorTextChangeEvent) => {
  console.log(event.textValue);
}
</script>

<template>
  <Editor v-model="value" editorStyle="height: 75vh" @text-change="onTextChange" />
</template>
