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
    return similarity

def get_similar_theme(rating_df, user_id):
    # read visited themes
    rated = rating_df[rating_df[user_id] > 0][user_id].index
    # get top 3
    similarity = clac_similarity(rating_df)
    calc_sum = similarity.mean(axis=1).drop(rated)
    res = calc_sum.sort_values(ascending=False)
    print(list(res.index[:3]))
    return list(res.index)

if __name__ == '__main__':
    bmfs = BangMoaFireStroe(sys.argv[1])
    df = init_rating_dataframe(bmfs)
    users = bmfs.db.collection(u'user').stream()
    for doc in users:
        rec = get_similar_theme(df, doc.id)
        bmfs.db.collection(u'user').document(doc.id).update({'recommand': rec})