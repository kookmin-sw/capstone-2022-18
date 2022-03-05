import firebase_admin
from firebase_admin import firestore

cred = firebase_admin.credentials.Certificate('../confidential/firebase_python_key.json')
firebase_admin.initialize_app(cred, {
    'project_id': 'capstone-2022-18',
})

db = firestore.client()

doc_ref = db.collection(u'cafe').document(u'writie_test')
doc_ref.set({
    u'addr': u'한글123eng'
})


cafe_ref = db.collection(u'cafe')
docs = cafe_ref.stream()

for doc in docs:
    print(u'{} => {}'.format(doc.id, doc.to_dict()))