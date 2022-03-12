from bm_util import get_bs_obj, get_hash, BMCafe, BMThema

class BeatPhobia:
    url = 'https://www.xphobia.net/'
    
    def renew_theme_info(bmfs):
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
            bmt.poster = thema_page.find("div", class_="thumbs").find("img")["src"]
            for line in txt_inner:
                bmt.description.append(line.text.replace('\n', ''))
            bmt.description = bmt.description[:-2]

            bmfs.write_bm_object(u'thema', bmt)

            # add theme to cafe
            _cafe = quest_type[2].text.strip()
            cafe_list = []
            if 'Phobia' in _cafe:
                temp = _cafe.split(' ')
                for i in range(0, len(temp), 2):
                    cafe_list.append(' '.join(temp[i:i+2]))
            elif ' 던전' in _cafe:
                temp = _cafe.split(' ')
                for i in range(0, len(temp), 2):
                    cafe_list.append(' '.join(temp[i:i+2]))
            else:
                cafe_list.append(_cafe)
            print(cafe_list)
            for cafe in cafe_list:
                cafe_ref = bmfs.db.collection(u'cafe').document(get_hash(BeatPhobia.url + cafe))
                cafe_doc = cafe_ref.get()
                if cafe_doc.exists:
                    bmc = BMCafe(BeatPhobia.url)
                    bmc.from_dict(cafe_doc.to_dict())
                    bmc.themes.append(bmt.get_id())
                    bmfs.write_bm_object(u'cafe', bmc)
    
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

            bmfs.write_bm_object(u'cafe', bmc)