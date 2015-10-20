from config.constants import SESSION_AUTH_TOKEN, DB_HOST, DB_PORT, DB_SESSIONS, DB_NAME
from parsers.html_data import is_logged
from api.account.login import login_to_api
from web.http_requests import get
import uuid
from datetime import datetime
from pymongo import MongoClient


class MongoSession:

    def __init__(self, token=None, username=None, password=None, cookie=None):
        self.store = MongoClient(host=DB_HOST, port=DB_PORT)[DB_NAME][DB_SESSIONS]
        self.authenticated = False
        self.token = None

        if token:
            session = self.store.find_one({'token': token})
            self.store.update_one({'token': token}, {'$set': {'created': datetime.now()}})
            if session:
                self.username = session['username']
                self.password = session['password']
                self.cookie = session['cookie']
                self.token = token

                if self.is_authenticated_api():
                    self.authenticated = True
                else:
                    self.cookie = login_to_api(self.username, self.password)
                    if self.cookie:
                        self.store.update_one({'token': self.token}, {'$set': {'cookie': self.cookie}})
                        self.authenticated = True
        elif username and password:
            self.token = uuid.uuid4().hex
            self.username = username
            self.password = password
            self.cookie = login_to_api(self.username, self.password)
            if self.cookie:
                self.store.insert_one({'token': self.token, 'username': self.username, 'password': self.password, 'cookie': self.cookie, 'created': datetime.now()})
                self.authenticated = True

    def is_authenticated_api(self):
        response = get(self.cookie)
        return is_logged(response.text)

    def get_token(self):
        return self.token

    def get_cookie(self):
        return self.cookie

    def destroy(self):
        self.store.delete_one({'token': self.token})
        self.username = ''
        self.password = ''
        self.cookie = ''
        self.token = ''

    def is_authenticated(self):
        return self.authenticated
