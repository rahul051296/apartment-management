from aptdbservice import AptDataService
from flask import Flask
from flask import json
from flask_cors import CORS
from flask import request

app = Flask(__name__)
CORS(app)

apt_data_service = AptDataService()


@app.route('/')
def hello_world():
    return json.dumps({'status': 'OK'})


@app.route('/apartments')
def get_apartment_list():
    response = apt_data_service.get_apartment_list()
    return json.dumps(response)


@app.route('/flats/<aptId>')
def get_flat_by_aptId(aptId):
    response = apt_data_service.get_flat_by_apartment(aptId)
    return json.dumps(response)


@app.route('/flat-details/<flatId>')
def get_flat_by_flatID(flatId):
    response = apt_data_service.get_flat_by_id(flatId)
    return json.dumps(response)


@app.route('/booking', methods=['POST'])
def add_booking_data():
    print(request.get_json())
    response = apt_data_service.add_resident_and_booking(request.get_json())
    return json.dumps(response)


if __name__ == "__main__":
    app.run(host="localhost", port=5000)
