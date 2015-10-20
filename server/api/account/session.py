from config.constants import SESSION_USERNAME, SESSION_PASSWORD, SESSION_TOKEN, SESSION_AUTH_TOKEN, DB_HOST, DB_PORT, DB_SESSIONS, DB_NAME
from parsers.html_data import is_logged
from web.http_requests import get
import uuid
from datetime import datetime
from pymongo import MongoClient


class MongoSession:

    def __init__(self, token=None, username=None, password=None):
        self.store = MongoClient(host=DB_HOST, port=DB_PORT)[DB_NAME][DB_SESSIONS]
        self.authenticated = False
        self.token = None

        if token:
            session = self.store.find_one({'token': token})
            if session:
                self.authenticated = True
                self.username = session['username']
                self.password = session['password']
                self.token = token
        elif username and password:
            self.token = uuid.uuid4().hex
            self.username = username
            self.password = password
            self.store.insert_one({'token': self.token, 'username': username, 'password': password, 'created': datetime.now()})
            self.authenticated = True

    def get_token(self):
        return self.token

    def destroy(self):
        self.store.delete_one({'token': self.token})

    def is_authenticated(self):
        return self.authenticated
