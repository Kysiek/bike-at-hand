import requests
from flask import session
from api.account.login import login_to_api
from config.constants import API_URL, API_COOKIE_NAME, SESSION_AUTH_TOKEN, SESSION_USERNAME, SESSION_PASSWORD


def check_session():
    if SESSION_AUTH_TOKEN not in session:
        return login_to_api(session[SESSION_USERNAME], session[SESSION_PASSWORD])
    return True


def get(url=API_URL):
    if check_session():
        response = requests.get(url, cookies={API_COOKIE_NAME: session[SESSION_AUTH_TOKEN]})
        if response.status_code == 200:
            return response
        else:
            session.pop(SESSION_AUTH_TOKEN, None)
            check_session()
            return requests.get(url, cookies={API_COOKIE_NAME: session[SESSION_AUTH_TOKEN]})
    return requests.get(url)


def post(content, url=API_URL):
    if check_session():
        response = requests.post(url, content, cookies={API_COOKIE_NAME: session[SESSION_AUTH_TOKEN]})
        if response.status_code == 200:
            return response
        else:
            session.pop(SESSION_AUTH_TOKEN, None)
            check_session()
            return requests.get(url, cookies={API_COOKIE_NAME: session[SESSION_AUTH_TOKEN]})
    return requests.post(url, content)
