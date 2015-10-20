import requests
from config.constants import API_URL, API_COOKIE_NAME


def get(cookie=None):
    if cookie:
        return requests.get(API_URL, cookies={API_COOKIE_NAME: cookie})
    return requests.get(API_URL)
        
def post(content, cookie=None):
    if cookie:
        return requests.post(API_URL, content, cookies={API_COOKIE_NAME: cookie})
    return requests.post(API_URL, content)
