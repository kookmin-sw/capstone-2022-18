import firebase_admin
from firebase_admin import firestore



class BangMoaFireStroe:
    def __init__(self):
        #cred = firebase_admin.credentials.ApplicationDefault()
        cred = firebase_admin.credentials.Certificate('../confidential/firebase_python_key.json')
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def update_db(self, col, doc_id, data_dict):
        doc_ref = self.db.collection(col).document(doc_id)
        doc_ref.set(data_dict)

    def read_db(self, collection):
        docs = db.collection(col).stream()
        for doc in docs:
            print(u'{} => {}'.format(doc.id, doc.to_dict()))
