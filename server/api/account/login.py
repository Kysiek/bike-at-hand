from config.constants import NB_API_LOGIN_ACTION, NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME, NB_API_LOGIN_PASSWORD, API_COOKIE_NAME
from web.http_requests import post
from parsers.html_data import is_logged


def login_to_api(username, password):
    response = post({NB_API_LOGIN_ACTION: NB_API_LOGIN_LOGIN, NB_API_LOGIN_USERNAME: username, NB_API_LOGIN_PASSWORD: password})
    if is_logged(response.text):
        return response.cookies[API_COOKIE_NAME]
    return None
