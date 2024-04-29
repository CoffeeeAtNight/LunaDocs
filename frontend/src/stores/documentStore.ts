import { defineStore, Pinia } from "pinia";

interface DocumentApiResponse {
  code : number
  data : Map<number, {doc_content: string, doc_name: string}>
}

export const useDocumentStore = defineStore("document", {
  state: () => ({
    documentId: -1,
    documentName: "",
    documentContent: "",
    listOfDocumentIds: [] as number[],
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

    getListOfDocumentIds() {
      fetch("http://localhost:8000/api/documents")
        .then((response) => response.json())
        .then((resp: DocumentApiResponse) => {
          resp.data.forEach((value: {doc_content: string, doc_name: string}, key: number) => {
            this.listOfDocumentIds.push(key)
          })
        })
    }
  }
})