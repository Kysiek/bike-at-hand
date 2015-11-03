import pymongo
from config.constants import DB_HOST, DB_PORT, DB_NAME, DB_STATIONS


def get_station_id_dict():
    client = pymongo.MongoClient(host=DB_HOST, port=DB_PORT)
    db = pymongo.database.Database(client, DB_NAME)
    cursor = db[DB_STATIONS].find({}, {'_id': False, 'latitude': False, 'longitude': False, 'racks_count': False, 'bikes': False})
    station_id_dict = {}
    for doc in cursor:
        station_id_dict[doc['id']] = doc['name'].strip()
        print doc['name'].strip()
    return station_id_dict
