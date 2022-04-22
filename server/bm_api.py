import sys

from flask import Flask, request, jsonify
from google.cloud import storage

from util import BangMoaFireStroe

from cafe_website.beat_phobia import BeatPhobia
from cafe_website.next_edition import NextEdition

from recommendation import get_similar_theme

url_class = {
    'https://www.xphobia.net/': BeatPhobia,
    'https://www.nextedition.co.kr': NextEdition
}

app = Flask(__name__)
bmfs = BangMoaFireStroe(sys.argv[1])
gcs = storage.Client()
bucket = gcs.get_bucket('capstone-2022-18.appspot.com')

@app.route('/')
def hello_world():
    return "Hi zzz"

@app.route('/reservation', methods=['POST'])
def reservation():
    input_data = request.get_json()

    theme_doc = bmfs.read_doc(u'thema', input_data['id'])

    output_data = url_class[theme_doc['url']].get_reservation_info(
        input_data['date'], 
        theme_doc['name']
    )

    return jsonify(output_data)

@app.route('/recommendation', methods=['POST'])
def recommendation():
    input_data = request.get_json()

    user_id = input_data['id']

    return get_similar_theme(user_id)

@app.route('/login/manager', methods=['POST'])
def login_manager():
    input_data = request.get_json()

    output_data = {}
    doc = bmfs.db.collection(u'manager').document(input_data['id'])
    if doc.get().exists:
        doc_dict = doc.get().to_dict()
        if input_data['pw'] == doc_dict['pw']:
            output_data['result'] = 'true'
            return jsonify(output_data)
    output_data['result'] = 'false'
    return jsonify(output_data)

@app.route('/signup/manager', methods=['POST'])
def signup_manager():
    input_data = request.get_json()
    output_data = {'result': 'false'}

    doc = bmfs.db.collection(u'manager').document(input_data['id'])
    if doc.get().exists:
        return jsonify(output_data)
    data = {
        u'pw': input_data['pw']
        u'name': input_data['name']
        u'address': input_data['address']
        u'phone': input_data['phone']
    }
    doc.set(data)
    output_data['result'] = 'true'
    return jsonify(output_data)

@app.route('/theme/add', methods=['POST'])
def signup_manager():
    input_data = request.get_json()
    print(input_data)
    output_data = {'result': 'false'}
    doc_ref = bmfs.db.collection(u'theme').document()

    doc_ref.add(input_data)
    poster_file = request.files.get('poster')
    if not poster_file:
        return output_data

    filename = doc_ref.id + poster_file.filename.split('.')[1]
    blob = bucket.blob('theme/' + filename)
    blob.upload_from_string(
        poster_file.read(),
        content_type=poster_file.content_type
    )

    return jsonify(output_data)

if __name__ == '__main__':
    app.run(host='0.0.0.0')