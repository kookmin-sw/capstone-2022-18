from flask import Flask, request, jsonify

from bm_util import BangMoaFireStroe

from beat_phobia import BeatPhobia

url_class = {
    'https://www.xphobia.net/': BeatPhobia
}

app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hi zzz"

@app.route('/reservation', method=['POST'])
def reservation_check():
    input_data = request.get_json()

    bmfs = BangMoaFireStroe()
    theme_doc = bmfs.read_doc(u'thema', input_data['theme_id'])

    output_data = url_class[theme_doc['url']].get_reservation_info(
        input_data['date'], theme_doc['title']
    )

    return jsonify(output_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0')