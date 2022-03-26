from flask import Flask, request, jsonify

from bm_util import BangMoaFireStroe

from cafe_website.beat_phobia import BeatPhobia
from cafe_website.next_edition import NextEdition

url_class = {
    'https://www.xphobia.net/': BeatPhobia,
    'https://www.nextedition.co.kr': NextEdition
}

app = Flask(__name__)
bmfs = BangMoaFireStroe()

@app.route('/')
def hello_world():
    return "Hi zzz"

@app.route('/reservation', methods=['POST'])
def reservation_check():
    input_data = request.get_json()

    theme_doc = bmfs.read_doc(u'thema', input_data['id'])

    output_data = url_class[theme_doc['url']].get_reservation_info(
        input_data['date'], 
        theme_doc['name']
    )

    return jsonify(output_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0')