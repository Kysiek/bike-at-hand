import pymongo
from bson import json_util
import json
from web.http_responses import respond


def get_all():
    client = pymongo.MongoClient()
    db = client['bikeathand']
    cursor = db.stations.find({}, {'_id': False})
    stations = json.loads(json_util.dumps(cursor))
    return respond(200, stations=stations)
