from bm_util import get_bs_obj, get_hash, BMCafe, BMThema, BMWebsite
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import re

class NextEdition(BMWebsite):
    url = 'https://www.nextedition.co.kr'
    
    def renew_theme_info(self):
        bsobj = get_bs_obj(self.url + '/themes')
        thema_list = bsobj.find_all("div", class_="property-listing-row")
        for theme in thema_list:
            bmt = BMThema(self.url)

            bmt.name = theme.find('h3').text.strip()
            bmt.poster = theme.find('img')['src']
            _cafe = theme.find('p', class_='listing-location').text.strip()
            _info = theme.find_all('li', class_='list-inline-item')
            bmt.genre = _info[0].text.split()[1]
            bmt.difficulty = len(theme.find('span', class_='rating').find_all('i'))
            bmt.description.append(_info[1].text.split()[-1] + ' players')
            self.fs.write_bm_object(u'thema', bmt)

            bmc = BMCafe(self.url)
            bmc.from_dict(self.fs.read_doc(u'cafe', get_hash(self.url + _cafe)))
            bmc.themes.append(bmt.get_id())
            self.fs.write_bm_object(u'cafe', bmc)
    
    def renew_cafe_info(self):
        bsobj = get_bs_obj(self.url + '/shops')
        cafe_list = bsobj.find_all("div", class_="listing-content-alt")
        for cafe in cafe_list:
            bmc = BMCafe(self.url)

            bmc.name = cafe.find('h3').text.strip()
            bmc.destination = cafe.find('span', class_='listing-location').text.strip()
            bmc.phone = re.findall('[0-9\-]+', cafe.find_all('li', class_='list-inline-item')[1].text)[0]

            self.fs.write_bm_object(u'cafe', bmc)

    def get_reservation_info(date_str, theme_name):
        res = {}
        driver = NextEdition.get_webdriver()
        bsobj = get_bs_obj(NextEdition.url + '/themes')
        themes = bsobj.find_all('div', class_='listing-content-alt')
        for th in themes:
            _t = th.find('h3').find('a')
            if theme_name == _t.text.strip():
                driver.get(NextEdition.url + _t['href'])
                break
        _cafe_name = driver.find_element(By.TAG_NAME, 'h1').text.strip()
        res[_cafe_name] = {
            theme_name: {}
        }
        date_input = driver.find_element(By.ID, 'datepicker')
        date_input.clear()
        date_input.send_keys(date_str, Keys.ENTER, Keys.ENTER)
        try:
            driver.switch_to.alert.accept()
            return res
        except:
            date_input = driver.find_element(By.ID, 'datepicker')
        if date_input.get_attribute('value') != date_str:
            return res
        
        themes = driver.find_elements(By.CLASS_NAME, 'col-md-8')
        for th in themes:
            if theme_name == th.find_element(By.TAG_NAME, 'h2').text.strip():
                times = th.find_elements(By.CLASS_NAME, 'res-btn')
                for each_time in times:
                    res[_cafe_name][theme_name][each_time.find_element(By.CLASS_NAME, 'time').text.strip()] = 'res-true' in each_time.get_attribute('class')
                break
                if len(res[_cafe_name][theme_name]) == 0:
                    res = {}
        return res

if __name__ == '__main__':
    NextEdition.get_reservation_info('2022-05-01', '세렌디피티(SERENDIPITY)')