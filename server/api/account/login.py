from config.constants import API_URL, NB_API_LOGIN_ACTION, NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME, NB_API_LOGIN_PASSWORD, API_COOKIE_NAME, SESSION_AUTH_TOKEN, SESSION_USERNAME, SESSION_PASSWORD
from parsers.html_data import is_logged
from flask import session
import requests


def login_to_api(username, password):
    response = requests.post(API_URL, data={NB_API_LOGIN_ACTION: NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME: username, NB_API_LOGIN_PASSWORD: password})
    if is_logged(response.text) and API_COOKIE_NAME in response.cookies:
        session[SESSION_AUTH_TOKEN] = response.cookies[API_COOKIE_NAME]
        session[SESSION_USERNAME] = username
        session[SESSION_PASSWORD] = password
        return True
    return False
