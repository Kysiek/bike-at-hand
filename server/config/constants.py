import os

TEST_ENVIRONMENT = os.environ.get("TEST_ENVIRONMENT", None)

# Nextbike API URL
API_URL = 'https://nextbike.net/pl/m/home'
STATIONS_URL = 'http://nextbike.net/maps/nextbike-live.xml?city=148'
STATIONS_INTERVAL = 60

DB_HOST = '127.0.0.1'
DB_PORT = 27017
DB_NAME = 'bikeathand'

if TEST_ENVIRONMENT:
    DB_NAME = 'bikeathand_qa'

DB_SESSIONS = 'sessions'

# Nextbike API session key name
API_COOKIE_NAME = 'parameters[dlkey]'

# Session
SESSION_AUTH_TOKEN = 'auth_token'

# HTML parser
LOGGED_HTML_CONTENT = 'pl/m/logout'

# XML parser
CITIES_COUNTRY = 'country'
CITIES_CITY = 'city'
CITIES_PLACE = 'place'

# Stations XML
XML_STATION_ID = 'number'
XML_STATION_LAT = 'lat'
XML_STATION_LNG = 'lng'
XML_STATION_NAME = 'name'
XML_STATION_RACKS = 'bike_racks'
XML_STATION_BIKES_COUNT = 'bikes'
XML_STATION_BIKES = 'bike_numbers'

# Nextbike API
NB_API_LOGIN_ACTION = 'action'
NB_API_LOGIN_LOGIN = 'login'
NB_API_LOGIN_USERNAME = 'mobile'
NB_API_LOGIN_PASSWORD = 'pin'

# RentBike API
ACCOUNT_LOGIN_USERNAME = 'user'
ACCOUNT_LOGIN_PASSWORD = 'pass'

# Account history API
HISTORY_URL = 'https://nextbike.net/pl/m/account'
HISTORY_HTML_CONTENT = 'data-role="list-divider"'

# Account history parser - html elements
UNORDERED_LIST_ELEMENT = 'ul'
ORDERED_LIST_ELEMENT = 'li'
SPAN_ELEMENT_ELEMENT = 'span'
ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_KEY = u'data-role'
ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_VALUE = u'listview'
ACCOUNT_HISTORY_TAG_ATTRIBUTE_KEY = u'data-role'
ACCOUNT_HISTORY_TAG_ATTRIBUTE_VALUE = u'list-divider'
ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_KEY = u'class'
ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_VALUE = u'ui-li-aside'



