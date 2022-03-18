from bm_util import BangMoaFireStroe

from beat_phobia import BeatPhobia
from next_edition import NextEdition

if __name__ == '__main__':
    bmfs = BangMoaFireStroe()
    bmfs.clear_collection('cafe')
    bmfs.clear_collection('thema')

    site_list = [BeatPhobia, NextEdition]
    #site_list = [NextEdition]
    for site in site_list:
        bmw = site(bmfs)
        #bmw.renew_cafe_info()
        #bmw.renew_theme_info()
        bmw.update_information()
