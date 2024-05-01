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

interface DocumentUpdatedContentResponse {
  code: number,
  data: string
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

  /**
   * Adds a document to the API.
   *
   * @param {string} docName - The name of the document to be added.
   * @return {Promise<void>} A promise that resolves when the document is added successfully.
   */
    async addDocument(docName: string): Promise<void> {
      const response = await fetch("http://localhost:8000/api/document", {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({ documentName: docName })
      }).then(response => console.log("Added document: ", response));
    },

  /**
   * Retrieves a list of documents from the API.
   *
   * @return {Document[]} A promise that resolves with an array of Document objects representing the documents fetched from the API.
   * @throws {Error} If there is an error fetching the documents from the API.
   */
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
        throw Error("Error fetching documents")
      }
    },

    /**
     * Handles updating the document content on the server.
     * @param {number} newDocumentContent - The ID of the document to be updated.
     * @param {string} documentIdToUpdate - The new content of the document.
     * @return {void} This function does not return anything.
     */
    async updateDocumentContent(documentIdToUpdate: number, document: any): Promise<void> {
      try {
        console.log("DOCUMENT IS: ", JSON.stringify(document))
        const request = {
          method: "PUT",
          headers: { 'Content-Type': 'application/json' },
          body: document
        }
        const response = await fetch(`http://localhost:8000/api/document/${documentIdToUpdate}`, request);
        const responseBody = await response.json()
        if (responseBody != "ok") console.error("Error occurred updating document");
      } catch (error) {
        console.error('Error fetching documents:', error);
      }
    },

  /**
   * Retrieves the content of a document by its ID.
   *
   * @param {number} documentId - The ID of the document.
   * @return {Promise<String>} A promise that resolves to the content of the document.
   * @throws {Error} If there is an error fetching the document.
   */
    async getDocumentContentById(documentId: number): Promise<string> {
      try {
        const response = await fetch(`http://localhost:8000/api/document/${documentId}`);
        const changedContentResponse = await response.json() as DocumentUpdatedContentResponse;
        return changedContentResponse.data;
      } catch (error) {
        console.error('Error getting content of document by id :', error);
        throw error;
      }
    },

  }
})

