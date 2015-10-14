from pymongo import MongoClient
from bson import json_util
import json
from nbapi.web.http_responses import respond



def all():
    client = MongoClient()
    db = client.nbapi
    cursor = db.stations.find()
    stations = json.loads([json_util.dumps(station) for station in cursor])
    return respond(200, stations=stations)
