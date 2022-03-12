from abc import *
import hashlib

import requests
from bs4 import BeautifulSoup

import firebase_admin
from firebase_admin import firestore


# method alias
def get_bs_obj(url):
    return BeautifulSoup(requests.get(url).text, "html.parser")
def get_hash(origin_text):
    return hashlib.sha256(origin_text.encode('utf-8')).hexdigest()


class BangMoaFireStroe:
    # firestore
    def __init__(self):
        cred = firebase_admin.credentials.Certificate('../confidential/firebase_python_key.json')
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def write_bm_object(self, col, bm_object):
        doc_ref = self.db.collection(col).document(bm_object.get_id())
        doc_ref.set(bm_object.to_dict())

    def clear_collection(self, col):
        docs = self.db.collection(col).stream()
        for doc in docs:
            doc.reference.delete()


class BMObject(metaclass=ABCMeta):
    # each document of firestore
    def __init__(self, page_name):
        # common attribute
        self.page = page_name
        self.name = ''
        self.description = []
        self.doc_dict = {}

    def get_id(self):
        # id is hash of (web_URL + name)
        return get_hash(self.page + self.name)
    
    @abstractmethod
    def to_dict(self):
        self.doc_dict['name'] = self.name
        self.doc_dict['description'] = '\n'.join(self.description)
    
    @abstractmethod
    def from_dict(self, data_dict):
        self.name = data_dict['name']
        self.description = data_dict['description'].split('\n')


class BMThema(BMObject):
    def __init__(self, page_name):
        super().__init__(page_name)
        self.genre = ''
        self.difficulty = 0
        self.poster = ''

    def to_dict(self):
        super().to_dict()
        self.doc_dict['genre'] = self.genre
        self.doc_dict['difficulty'] = self.difficulty
        self.doc_dict['poster'] = self.poster
        return self.doc_dict

    def from_dict(self, data_dict):
        super().from_dict(data_dict)
        self.genre = data_dict['genre']
        self.difficulty = data_dict['difficulty']
        self.poster = data_dict['poster']


class BMCafe(BMObject):
    def __init__(self, page_name):
        super().__init__(page_name)
        self.destination = ''
        self.phone = ''
        self.themes = []
    
    def to_dict(self):
        super().to_dict()
        self.doc_dict['destination'] = self.destination
        self.doc_dict['phone'] = self.phone
        self.doc_dict['themes'] = self.themes
        return self.doc_dict
    
    def from_dict(self, data_dict):
        super().from_dict(data_dict)
        self.destination = data_dict['destination']
        self.phone = data_dict['phone']
        self.themes = data_dict['themes']