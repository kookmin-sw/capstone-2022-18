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
    manager = bmfs.db.collection(u'manager').where(u'id', u'==', input_data['id']).stream()

    for doc in manager:
        doc_dict = doc.to_dict()
        if input_data['pw'] == doc_dict['pw']:
            return jsonify({'result': 'true'})

    return jsonify({'result': 'false'})


@app.route('/signup/manager', methods=['POST'])
def signup_manager():
    input_data = request.get_json()
    query = bmfs.db.collection(u'manager').where(u'_id', u'==', input_data['id']).stream()
    for doc in query:
        return jsonify({'result': 'false'})
    bmfs.write('manager', input_data)
    return jsonify({'result': 'true'})


@app.route('/manager/theme', methods=['POST'])
def manager_theme():
    input_data = request.get_json()
    result = {}
    query = bmfs.db.collection(u'theme').where(u'manager_id', u'==', input_data['id']).stream()
    for doc in query:
        result[doc.id] = doc.to_dict()
    return jsonify(result)


@app.route('/theme/add', methods=['POST'])
def theme_add():
    input_data = request.form.to_dict()
    poster_file = request.files.get('poster')
    doc_ref = bmfs.db.collection(u'theme').document()

    filename = doc_ref.id + '.' + poster_file.filename.split('.')[-1]
    blob = bucket.blob('theme/' + filename)
    blob.upload_from_string(
        poster_file.read(),
        content_type=poster_file.content_type
    )
    blob.make_public()
    input_data['poster'] = blob.public_url
    bmfs.write('theme', input_data, doc_ref.id)

    return jsonify({'result': 'true'})


@app.route('/theme/remove', methods=['POST'])
def theme_remove():
    input_data = request.get_json()
    doc = bmfs.db.collection(u'theme').document(input_data['id'])
    poster_filename = doc.id + '.' + doc.to_dict()['poster'].split('.')[-1]
    blob = bucket.blob('theme/' + poster_filename)
    blob.delete()
    doc.delete()
    return jsonify({'result': 'true', 'theme_id': input_data['id']})


@app.route('/theme/edit', methods=['POST'])
def theme_edit():
    input_data = request.form.to_dict()
    theme_id = input_data['id']
    input_data.pop('id', None)

    # remove
    doc = bmfs.db.collection(u'theme').document(theme_id)
    poster_filename = doc.id + '.' + doc.to_dict()['poster'].split('.')[-1]
    blob = bucket.blob('theme/' + poster_filename)
    blob.delete()
    doc.delete()

    # add
    poster_file = request.files.get('poster')
    doc_ref = bmfs.db.collection(u'theme').document(theme_id)

    filename = doc_ref.id + '.' + poster_file.filename.split('.')[-1]
    blob = bucket.blob('theme/' + filename)
    blob.upload_from_string(
        poster_file.read(),
        content_type=poster_file.content_type
    )
    blob.make_public()
    input_data['poster'] = blob.public_url
    bmfs.write('theme', input_data, doc_ref.id)

    return jsonify({'result': 'true'})


@app.route('/theme/status', methods=['POST'])
def reservation_status():
    input_data = request.get_json()
    timetable = bmfs.db.collection(u'theme').document(input_data['id']).get().to_dict()['timetable']
    output_data = {}
    for slot in timetable:
        output_data[slot] = True

    booked = bmfs.db.collection(u'reservation').where(
        u'theme_id', u'==', input_data['id']).where(
        u'date', u'==', input_data['date']).stream()
    for r in booked:
        output_data[r.to_dict()['time']] = False

    return jsonify(output_data)


@app.route('/review/add', methods=['POST'])
def review_add():
    input_data = request.get_json()
    docs = bmfs.db.collection(u'review').where(
        u'themaID', u'==', input_data['themaID']).where(
        u'writerID', u'==', input_data['writerID']).stream()
    for doc in docs:
        db.collection(u'reivew').document(doc.id).update(input_data)
        return jsonify({'result', 'edit'})
    bmfs.write('review', input_data)
    return jsonify({'result': 'add'})


@app.route('/reservation/add', methods=['POST'])
def reservation_add():
    input_data = request.get_json()
    docs = bmfs.db.collection(u'reservation').where(
        u'theme_id', u'==', input_data['theme_id']).where(
        u'date', u'==', input_data['date']).where(
        u'time', u'==', input_data['time']).stream()
    for doc in docs:
        return jsonify({'result', 'false'})
    bmfs.write('reservation', request.get_json())
    return jsonify({'result': 'true'})


@app.route('/reservation/cancel', methods=['POST'])
def reservation_cancel():
    input_data = request.get_json()
    db.collection().document(input_data['id']).delete


@app.route('/reservation/manager/status', methods=['POST'])
def reservation_manager_status():
    input_data = request.get_json()
    output_data = {'result': []}
    themes = bmfs.db.collection(u'theme').where(u'manager_id', u'==', input_data['id']).stream()

    for theme_doc in themes:
        theme = theme_doc.to_dict()
        reservations = bmfs.db.collection(u'reservation').where(
            u'theme_id', u'==', theme_doc.id).where(
            u'date', u'==', input_data['date']).stream()
        for reservation_doc in reservations:
            reservation = reservation_doc.to_dict()
            user_name = bmfs.db.collection(u'user').document(reservation['user_id']).get().to_dict()['nickname']
            output_data['result'].append({
                'date': reservation['date'], 
                'time': reservation['time'], 
                'user_count': reservation['user_count'], 
                'theme_name': theme['name'], 
                'user_name': user_name
            })
    
    output_data['result'].sort(key=lambda x : (x['date'], x['time']))
    return jsonify(output_data)


if __name__ == '__main__':
    app.run(host='0.0.0.0')