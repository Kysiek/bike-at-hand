from config.constants import HISTORY_HTML_CONTENT, HISTORY_URL
from web.http_requests import get
from parsers.html_data import NextbikeHistoryParser


def get_history(auth_token):
    response = get(HISTORY_URL)
    html_body = response.text
    if HISTORY_HTML_CONTENT in html_body:
        history_parser = NextbikeHistoryParser()
        return history_parser.get_account_history(response.text)
    return False
