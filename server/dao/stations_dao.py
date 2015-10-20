import pymongo


def get_station_id_dict():
    client = pymongo.MongoClient()
    db = pymongo.database.Database(client, 'bikeathand')
    cursor = db.stations.find({}, {'_id': False, 'latitude': False, 'longitude': False, 'racks_count': False, 'bikes': False})
    station_id_dict = {}
    for doc in cursor:
        station_id_dict[doc['id']] = doc['name'].strip()
        print doc['name'].strip()
    return station_id_dict
