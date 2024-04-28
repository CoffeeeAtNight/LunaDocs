import { defineStore, Pinia } from "pinia";



export const useDocumentStore = defineStore("document", {
  state: () => ({
    documentId: -1,
    documentName: "",
    documentContent: "",
    listOfDocumentIds: []
  }),
  actions: {
    /**
     * Sets the document ID to the given value and fetches the document details from the backend.
     *
     * @param {number} docId - The ID of the document to be opened.
     */
    openDocument(docId: number) {
      this.documentId = docId
      // TODO GET NAME FROM BACKEND BY ID
    },

    /**
     * Sets the content of the document to the given value.
     *
     * @param {string} content - The new content of the document.
     */
    setDocumentContent(content: string) {
      this.documentContent = content
    },

    getListOfDocumentIds(listOfDocumentIds: number[]) {
      // TODO GET FROM BACKEND
    }
  }
})