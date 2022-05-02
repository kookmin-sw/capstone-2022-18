import sys

from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd


def init_rating_dataframe(bmfs):
    df = pd.DataFrame()

    users = bmfs.db.collection('user').stream()
    for user in users:
        df[user.id] = pd.Series(dtype=int)

    themes = bmfs.db.collection('theme').stream()
    for theme in themes:
        df = df.append(pd.Series(name=theme.id, dtype=int))


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

def get_similar_theme(user_id):
    # read visited themes
    rating = pd.read_pickle('./confidential/rating.pkl')
    rated = rating[rating[user_id] > 0][user_id].index
    # get top 3
    similarity = pd.read_pickle('./confidential/similarity.pkl')[rated]
    calc_sum = similarity.mean(axis=1).drop(rated)
    res = calc_sum.sort_values(ascending=False)
    print(res.index[:3])

if __name__ == '__main__':
    key_file = sys.argv[1]
    #init_rating_dataframe(key_file)
    get_similar_theme('te03st')