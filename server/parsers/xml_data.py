from xml.etree import ElementTree
from config.constants import CITIES_COUNTRY, CITIES_CITY, CITIES_PLACE, XML_STATION_ID, XML_STATION_LAT, XML_STATION_LNG, XML_STATION_NAME, XML_STATION_RACKS, XML_STATION_BIKES_COUNT, XML_STATION_BIKES

from entities.station import Station


def get_stations(stations_xml):
    root = ElementTree.fromstring(stations_xml.encode('utf-8'))
    xml_stations = root.find(CITIES_COUNTRY).find(CITIES_CITY).findall(CITIES_PLACE)
    stations = {station.attrib[XML_STATION_ID]: Station(station.attrib[XML_STATION_ID], station.attrib[XML_STATION_NAME], station.attrib[XML_STATION_LAT], station.attrib[XML_STATION_LNG], station.attrib[XML_STATION_RACKS], station.attrib[XML_STATION_BIKES].split(',') if station.attrib[XML_STATION_BIKES_COUNT] != '0' else []) for station in xml_stations}
    
    return stations


def update_bikes():
    pass
