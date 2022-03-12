from bm_util import BangMoaFireStroe

from beat_phobia import BeatPhobia

if __name__ == '__main__':
    bmfs = BangMoaFireStroe()
    bmfs.clear_collection('cafe')
    bmfs.clear_collection('thema')

    BeatPhobia.renew_cafe_info(bmfs)
    BeatPhobia.renew_theme_info(bmfs)
