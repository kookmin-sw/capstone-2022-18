import requests
from bs4 import BeautifulSoup
import hashlib

from bm_fs_util import BangMoaFireStroe

def get_bs_obj(url):
    return BeautifulSoup(requests.get(url).text, "html.parser")


class BMObject:
    def __init__(self, page_name):
        self.page = page_name
        self.name = ''
        self.description = []

    def get_id(self):
        id_origin = self.page + self.name
        return hashlib.sha256(id_origin.encode('utf-8')).hexdigest()

class BMThema(BMObject):
    def __init__(self, page_name):
        super().__init__(page_name)
        self.genre = ''
        self.difficulty = 0
        self.poster = ''

    def to_dict(self):
        return {
            'name': self.name, 
            'genre': self.genre, 
            'difficulty': self.difficulty, 
            'poster': self.poster, 
            'description': '\n'.join(self.description)
        }

class BMCafe(BMObject):
    def __init__(self, page_name):
        super().__init__(page_name)
        self.destination = ''
        self.phone = ''
    
    def to_dict(self):
        return {
            'name': self.name, 
            'destination': self.destination, 
            'phone': self.phone, 
            'description': '\n'.join(self.description)
        }



class BeatPhobia:
    url = 'https://www.xphobia.net/'
    
    def renew_thema_info(bmfs):
        bsobj = get_bs_obj(BeatPhobia.url + 'quest/quest_list.php')
        thema_list = bsobj.find_all("div", class_="txt_wrap")
        for thema in thema_list:
            bmt = BMThema(BeatPhobia.url)

            thema_page = get_bs_obj(thema.find("a")["href"])
            title_block = thema_page.find("div", class_="tit_block")
            quest_type = thema_page.find("div", class_="quest_type").find_all("dd")
            txt_inner = thema_page.find("div", class_="txt_inner")

            bmt.name = title_block.find("h5").text
            bmt.difficulty = int(title_block.find("img")["src"][-5])
            bmt.genre = quest_type[0].text
            bmt.description.append(quest_type[1].text)
            #_cafe = quest_type[2:]
            bmt.poster = thema_page.find("div", class_="thumbs").find("img")["src"]
            for line in txt_inner:
                bmt.description.append(line.text.replace('\n', ''))
            bmt.description = bmt.description[:-2]

            bmfs.update_db(u'thema', bmt.get_id(), bmt.to_dict())
            break
    
    def renew_cafe_info(bmfs):
        bsobj = get_bs_obj(BeatPhobia.url + 'directions/directions.php')
        cafe_list = bsobj.find("div", class_="sear_bot").find_all('a')
        for cafe in cafe_list:
            bmc = BMCafe(BeatPhobia.url)

            cafe_info_page = get_bs_obj(cafe["href"]).find("div", class_="shop_info")
            td_all = cafe_info_page.find_all("td")

            bmc.name = cafe_info_page.find("h5").text
            bmc.description.append(td_all[0].text)
            bmc.phone = td_all[1].text
            bmc.destination = td_all[2].text
            bmc.description.append(td_all[3].text)

            bmfs.update_db(u'cafe', bmc.get_id(), bmc.to_dict())
            break

bmfs = BangMoaFireStroe()
BeatPhobia.renew_thema_info(bmfs)
BeatPhobia.renew_cafe_info(bmfs)