from bm_util import get_bs_obj, get_hash, BMCafe, BMThema, BMWebsite
import re

class NextEdition(BMWebsite):
    url = 'https://www.nextedition.co.kr/'
    
    def renew_theme_info(self):
        bsobj = get_bs_obj(self.url + 'themes')
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
        bsobj = get_bs_obj(self.url + 'shops')
        cafe_list = bsobj.find_all("div", class_="listing-content-alt")
        for cafe in cafe_list:
            bmc = BMCafe(self.url)

            bmc.name = cafe.find('h3').text.strip()
            bmc.destination = cafe.find('span', class_='listing-location').text.strip()
            bmc.phone = re.findall('[0-9\-]+', cafe.find_all('li', class_='list-inline-item')[1].text)[0]

            self.fs.write_bm_object(u'cafe', bmc)
