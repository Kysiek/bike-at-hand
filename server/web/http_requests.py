import requests
from config.constants import API_URL, API_COOKIE_NAME


def get(cookie=None, url=None):
    url = url if url else API_URL
    if cookie:
        return requests.get(url, cookies={API_COOKIE_NAME: cookie})
    return requests.get(url)
        
def post(content, cookie=None, url=None):
    url = url if url else API_URL
    if cookie:
        return requests.post(url, content, cookies={API_COOKIE_NAME: cookie})
    return requests.post(url, content)
