from requests import session

from config.constants import BIKE_NUMBER, STATION_NUMBER, COMMENT, SESSION_CITY
from web.http_requests import get, post
from web.http_responses import respond


def rent_bike(request):
    data = request.get_json()
    bike_no = data[BIKE_NUMBER]
    response = post({'action': 'look_up', 'bike_no': bike_no, 'quick': 1})
    return respond(401)


def return_bike(request):
    data = request.get_json()
    bike_no = data[BIKE_NUMBER]
    station = data[STATION_NUMBER]
    comment = data[COMMENT]
    response = post({'action': 'return', 'bike_no': bike_no, 'new_return_street': '', 'return_place_id': station, 'city_id': session[SESSION_CITY], 'finallat': '', 'finallng': '', 'end_street2': comment})
    return respond(401)


def unlock(request):
    data = request.get_json()
    bike_no = data[BIKE_NUMBER]
    response = post({'action': 'look_up', 'bike_no': bike_no, 'open_rack': 1})
    return respond(401)


def list_bikes():
    response = get()
    return respond(401)

