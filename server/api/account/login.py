from config.constants import LOGGED_HTML_CONTENT, NB_API_LOGIN_ACTION, NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME, NB_API_LOGIN_PASSWORD, API_COOKIE_NAME
from web.http_requests import post
from api.account.session import MongoSession
from parsers.html_data import is_logged


def login_to_api(username, password):
    response = post({NB_API_LOGIN_ACTION: NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME: username, NB_API_LOGIN_PASSWORD: password}, authorized=False)
    if is_logged(response.text):
        token = MongoSession(username=username, password=password).get_token()
        return token
    return None
