import { defineStore, Pinia } from "pinia";

interface DocumentApiResponse {
  code: number;
  data: {
    [key: string]: {
      doc_content: string;
      doc_name: string;
    }
  }
}

export interface Document {
  id: number;
  title: string;
  content: string;
  checked: boolean;
}

export const useDocumentStore = defineStore("document", {
  state: () => ({
    documentId: -1,
    documentName: "",
    documentContent: "",
    listOfDocuments: [] as DocumentApiResponse[],
  }),
  actions: {
    /**
     * Sets the document ID to the given value and fetches the document details from the backend.
     *
     * @param {number} docId - The ID of the document to be opened.
     */
    openDocument(docId: number, docName: string, docContent: string) {
      this.documentId = docId
      this.documentName = docName
      this.documentContent = docContent
    },

    /**
     * Sets the content of the document to the given value.
     *
     * @param {string} content - The new content of the document.
     */
    setDocumentContent(content: string) {
      this.documentContent = content
    },

    async addDocument(docName: string) {
      const response = await fetch("http://localhost:8000/api/create/document", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ documentName: docName })
      }).then(response => console.log("Added document: ", response));
    },

    async getListOfDocuments(): Promise<Document[]> {
      try {
        const response = await fetch("http://localhost:8000/api/documents");
        const resp = await (response.json() as Promise<DocumentApiResponse>);
        const documents: Document[] = Object.entries(resp.data).map(([id, { doc_name, doc_content }]) => ({
          id: Number(id),
          title: doc_name,
          content: doc_content,
          checked: false
        }));

        console.log(documents);
        return documents;
      } catch (error) {
        console.error('Error fetching documents:', error);
        throw error;
      }
    }

  }
})

