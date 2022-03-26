import sys

from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd

from util import BangMoaFireStroe


def init_rating_dataframe(key_file):
    # new theme-user dataframe from review
    bmfs = BangMoaFireStroe(key_file)
    reviews = bmfs.db.collection('review').stream()
    review_data = {}
    for r in reviews:
        review = r.to_dict()
        if review['writerID'] not in review_data:
            review_data[review['writerID']] = {}
        review_data[review['writerID']][review['themaID']] = review['rating']
    df = pd.DataFrame.from_dict(review_data)
    df.fillna(0, inplace=True)
    df.to_pickle('./confidential/rating.pkl')
    clac_similarity()


def clac_similarity():
    df = pd.read_pickle('./confidential/rating.pkl')
    similarity = pd.DataFrame(
        data=cosine_similarity(df),
        index=df.index,
        columns=df.index
    )
    similarity.to_pickle('./confidential/similarity.pkl')

def get_similar_theme(theme_id):
    similarity = pd.read_pickle('./confidential/similarity.pkl')[theme_id]
    calc_sum = similarity.mean(axis=1).drop(theme_id)
    res = calc_sum.sort_values(ascending=False)
    print(res.index[:3])

if __name__ == '__main__':
    key_file = sys.argv[1]
    #init_rating_dataframe(key_file)
    theme_li = [
        '61e06a7cb6f6947c9bbc97a0b53aae6db3147e093725cbd1435f4ce4c99fa293',
        'a04a74c6291ecee84ef07d31d392f980cfe08455a3d872e484111e83350ba188'
    ]
    get_similar_theme(theme_li)