from config.constants import HISTORY_HTML_CONTENT, HISTORY_URL
from web.http_requests import get
from parsers.html_data import NextbikeHistoryParser
from api.account.session import MongoSession


def get_history(auth_token):
    cookie = MongoSession(token=auth_token).get_cookie()
    response = get(cookie, HISTORY_URL)
    html_body = response.text
    if HISTORY_HTML_CONTENT in html_body:
        history_parser = NextbikeHistoryParser()
        return history_parser.get_account_history(response.text)
    return False
