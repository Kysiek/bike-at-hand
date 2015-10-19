import pymongo
from bson import json_util
import json
from web.http_responses import respond


def all():
    client = pymongo.MongoClient()
    db = pymongo.database.Database(client, 'bikeathand')
    cursor = db.stations.find()
    stations = json.loads(json_util.dumps(cursor))
    return respond(200, stations=stations)
