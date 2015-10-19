import time
from threading import Thread
from config.constants import STATIONS_URL, STATIONS_INTERVAL
from parser.xml_data import get_stations
import requests
from pymongo import MongoClient


class StationsUpdater(Thread):

    def __init__(self):
        self.stopped = False
        self.interval = STATIONS_INTERVAL
        Thread.__init__(self)

    def run(self):
        while not self.stopped:
            self.process_stations()
            time.sleep(self.interval)

    def process_stations(self):
        stations_xml = requests.get(STATIONS_URL)
        if stations_xml.status_code == 200:
            parsed_stations = get_stations(stations_xml.text)
            client = MongoClient('localhost', 27017)
            db = pymongo.database.Database(client, 'bikeathand')
            for station_id, station in parsed_stations.iteritems():
                db.stations.update_one({'id': station_id},
                                       {'$set': {'id': station_id, 'name': station.name, 'latitude': station.latitude, 'longitude': station.longitude, 'racks_count': station.racks_count, 'bikes': station.bikes}},
                                       upsert=True)
