import requests
from bs4 import BeautifulSoup

from bm_fs_util import BangMoaFireStroe


class BMThema:
    def __init__(self):
        self.name = ''
        self.genre = ''
        self.difficulty = 0
        self.poster = ''
        self.description = ''
    
    def to_dict(self):
        return {
            'name': self.name, 
            'genre': self.genre, 
            'difficulty': self.difficulty, 
            'poster': self.poster, 
            'description': self.description
        }


bmfs = BangMoaFireStroe()

url = 'https://www.xphobia.net/quest/quest_list.php'
html = requests.get(url).text
bsobj = BeautifulSoup(html, "html.parser")

thema_list = bsobj.find_all("div", class_="txt_wrap")
i = 1
for thema in thema_list:
    thema_page = BeautifulSoup(requests.get(thema.find("a")["href"]).text, "html.parser")
    title_block = thema_page.find("div", class_="tit_block")
    quest_type = thema_page.find("div", class_="quest_type").find_all("dd")
    txt_inner = thema_page.find("div", class_="txt_inner")

    bmt = BMThema()
    _description = []
    bmt.name = title_block.find("h5").text
    bmt.difficulty = int(title_block.find("img")["src"][-5])
    bmt.genre = quest_type[0].text
    _description.append(quest_type[1].text)
    #_cafe = quest_type[2:]
    bmt.poster = thema_page.find("div", class_="thumbs").find("img")["src"]
    for line in txt_inner:
        _description.append(line.text.replace('\n', ''))
    bmt.description = '\n'.join(_description[:-2])

    bmfs.update_db(u'thema', u'th' + str(i), bmt.to_dict())
    i += 1