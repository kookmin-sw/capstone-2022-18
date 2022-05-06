import sys

from sklearn.metrics.pairwise import cosine_similarity
import pandas as pd

from util import BangMoaFireStroe


def init_rating_dataframe(bmfs):
    df = pd.DataFrame()

    users = bmfs.db.collection('user').stream()
    for user in users:
        df[user.id] = pd.Series(dtype=int)

    themes = bmfs.db.collection('theme').stream()
    for theme in themes:
        df = df.append(pd.Series(name=theme.id, dtype=int))
    
    reviews = bmfs.db.collection('review').stream()
    for doc in reviews:
        review = doc.to_dict()
        df.at[review['themaID'], review['writerID']] = review['rating']
    
    df = df.fillna(0)
    return df


def clac_similarity(rating_dataframe):
    similarity = pd.DataFrame(
        data=cosine_similarity(rating_dataframe),
        index=rating_dataframe.index,
        columns=rating_dataframe.index
    )
    print(similarity)

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
    bmfs = BangMoaFireStroe(sys.argv[1])
    clac_similarity(init_rating_dataframe(bmfs))