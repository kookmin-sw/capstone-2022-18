from abc import *

import firebase_admin
from firebase_admin import firestore


class BangMoaFireStroe:
    # firestore
    def __init__(self, key_file):
        cred = firebase_admin.credentials.Certificate(key_file)
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def write(self, collection_name, data_dict):
        doc_ref = self.db.collection(collection_name).document()

        for key in data_dict:
            if data_dict[key].isdigit():
                data_dict[key] = int(data_dict)
            elif data_dict[key][0] == '[' and data_dict[-1] == ']':
                data_dict[key] = data_dict[key][1:-1].split(', ')

        doc_ref.set(data_dict)
        return doc_ref

    def clear_collection(self, col):
        docs = self.db.collection(col).stream()
        for doc in docs:
            doc.reference.delete()
    
    def read_doc(self, col, doc_id):
        doc_ref = self.db.collection(col).document(doc_id)
        doc = doc_ref.get()
        if doc.exists:
            return doc.to_dict()
