from abc import *
import hashlib

import requests
from bs4 import BeautifulSoup
from selenium import webdriver

import firebase_admin
from firebase_admin import firestore


# method alias
def get_bs_obj(url):
    return BeautifulSoup(requests.get(url).text, "html.parser")
def get_hash(origin_text):
    return hashlib.sha256(origin_text.encode('utf-8')).hexdigest()


class BangMoaFireStroe:
    # firestore
    def __init__(self, key_file):
        cred = firebase_admin.credentials.Certificate(key_file)
        firebase_admin.initialize_app(cred)
        self.db = firestore.client()
    
    def write_bm_object(self, col, bm_object):
        doc_ref = self.db.collection(col).document(bm_object.get_id())
        doc_ref.set(bm_object.to_dict())

    def clear_collection(self, col):
        docs = self.db.collection(col).stream()
        for doc in docs:
            doc.reference.delete()
    
    def read_doc(self, col, doc_id):
        doc_ref = self.db.collection(col).document(doc_id)
        doc = doc_ref.get()
        if doc.exists:
            return doc.to_dict()


class BMWebsite(metaclass=ABCMeta):
    sleep_time = 0.1
    # each website for crawling
    def __init__(self, bmfs):
        self.fs = bmfs

    @abstractmethod
    def renew_theme_info(self):
        pass
    
    @abstractmethod
    def renew_cafe_info(self):
        pass
    
    @abstractmethod
    def get_reservation_info(date_str, theme_name):
        '''
        return {
            'cafe1': {
                'theme1': {
                    'time1': available(bool)
                    'time2': available(bool)
                }
            }, 
            'cafe2': {
                'theme1': {
                    'time1': available(bool)
                    'time2': available(bool)
                }
            }
        }
        '''
        pass

    
    def update_information(self):
        self.renew_cafe_info()
        self.renew_theme_info()
    
    def get_webdriver():
        options = webdriver.ChromeOptions()
        options.add_argument('headless')
        options.add_argument('window-size=1920x1080')
        options.add_argument("disable-gpu")
        return webdriver.Chrome('../confidential/chromedriver', options=options)


class BMObject(metaclass=ABCMeta):
    # each document of firestore
    def __init__(self, page_name):
        # common attribute
        self.page = page_name
        self.name = ''
        self.description = []

    def get_id(self):
        # id is hash of (web_URL + name)
        return get_hash(self.page + self.name)
    
    @abstractmethod
    def to_dict(self):
        res = {}
        res['name'] = self.name
        res['description'] = '\n'.join(self.description)
        return res
    
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
        res = super().to_dict()
        res['genre'] = self.genre
        res['difficulty'] = self.difficulty
        res['poster'] = self.poster
        res['url'] = self.page
        return res

    def from_dict(self, data_dict):
        super().from_dict(data_dict)
        self.genre = data_dict['genre']
        self.difficulty = data_dict['difficulty']
        self.poster = data_dict['poster']
        self.url = data_dict['url']

class BMCafe(BMObject):
    def __init__(self, page_name):
        super().__init__(page_name)
        self.destination = ''
        self.phone = ''
        self.themes = []
    
    def to_dict(self):
        res = super().to_dict()
        res['destination'] = self.destination
        res['phone'] = self.phone
        res['themes'] = self.themes
        return res
    
    def from_dict(self, data_dict):
        super().from_dict(data_dict)
        self.destination = data_dict['destination']
        self.phone = data_dict['phone']
        self.themes = data_dict['themes']