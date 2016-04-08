import time
from threading import Thread
from config.constants import STATIONS_URL, STATIONS_INTERVAL, DB_HOST, DB_PORT, DB_NAME, DB_STATIONS
from parsers.xml_data import get_stations
import requests
import pymongo


class StationsUpdater(Thread):
    def __init__(self):
        self.stopped = False
        self.interval = STATIONS_INTERVAL
        Thread.__init__(self)

    def run(self):
        while not self.stopped:
            self.process_stations()
            time.sleep(self.interval)

    @staticmethod
    def process_stations():
        stations_xml = requests.get(STATIONS_URL)
        if stations_xml.status_code == 200:
            parsed_stations = get_stations(stations_xml.text)
            client = pymongo.MongoClient(DB_HOST, DB_PORT)
            db = client[DB_NAME]
            for station_id, station in parsed_stations.iteritems():
                db[DB_STATIONS].update_one({'id': station_id},
                                           {'$set': {'id': station_id, 'name': station.name,
                                                     'latitude': station.latitude, 'longitude': station.longitude,
                                                     'racks_count': station.racks_count, 'bikes': station.bikes}},
                                           upsert=True)
