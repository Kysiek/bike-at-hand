import requests
from nbapi.config.constants import API_URL, SESSION_TOKEN, API_COOKIE_NAME
from flask import session


def get_session_cookie():
    return {SESSION_COOKIE_NAME: session[SESSION_TOKEN]}

def get(authorized=True):
    if authorized:
        return requests.get(API_URL, cookies=get_session_cookie())
    return requests.get(API_URL)
        
def post(content, authorized=True):
    if authorized:
        return requests.post(API_URL, content, cookies=get_session_cookie())
    return requests.post(API_URL, content)
