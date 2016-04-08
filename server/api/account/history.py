from config.constants import HISTORY_HTML_CONTENT, HISTORY_URL
from web.http_requests import get
from parsers.html_data import NextbikeHistoryParser


def get_history():
    response = get(HISTORY_URL)
    html_body = response.content
    if HISTORY_HTML_CONTENT in html_body:
        history_parser = NextbikeHistoryParser()
        return history_parser.get_account_history(html_body)
    return False
