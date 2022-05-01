import sys
import json

from flask import Flask, request, jsonify
from google.cloud import storage

from util import BangMoaFireStroe

app = Flask(__name__)
bmfs = BangMoaFireStroe(sys.argv[1])
gcs = storage.Client()
bucket = gcs.get_bucket('capstone-2022-18.appspot.com')


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
    doc_ref = bmfs.db.collection(u'review').document()
    output_data = {'result': 'false'}

    doc = bmfs.db.collection(u'manager').document(input_data['id'])
    if doc.get().exists:
        return jsonify(output_data)

    doc_ref.set(input_data)
    output_data = {'result': 'true'}
    return jsonify(output_data)


@app.route('/theme/add', methods=['POST'])
def theme_add():
    doc_ref = bmfs.write('theme', request.form.to_dict())

    poster_file = request.files.get('poster')

    filename = doc_ref.id + '.' + poster_file.filename.split('.')[-1]
    blob = bucket.blob('theme/' + filename)
    blob.upload_from_string(
        poster_file.read(),
        content_type=poster_file.content_type
    )

    return jsonify({'result': 'true'})


@app.route('/theme/status', methods=['POST'])
def reservation_status():
    input_data = request.get_json()
    timetable = bmfs.db.collection(u'theme').document(input_data['theme_id']).get().to_dict()['timetable']
    output_data = {}
    for slot in timetable:
        output_data[slot] = True

    booked = bmfs.db.collection(u'reservation').where(
        u'theme_id', u'==', input_data['theme_id']).where(
        u'date', u'==', input_data['date']).stream()
    for r in booked:
        output_data[r.to_dict()['time']] = False

    return jsonify(output_data)


@app.route('/review/add', methods=['POST'])
def review_add():
    bmfs.write('review', request.get_json())
    return jsonify({'result': 'true'})


@app.route('/reservation/add', methods=['POST'])
def reservation_add():
    bmfs.write('reservation', request.get_json())
    return jsonify({'result': 'true'})



if __name__ == '__main__':
    app.run(host='0.0.0.0')