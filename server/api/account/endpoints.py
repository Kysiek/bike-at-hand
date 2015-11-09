from flask import session
from api.account.history import get_history
from api.account.login import login_to_api
from config.constants import ACCOUNT_LOGIN_USERNAME, ACCOUNT_LOGIN_PASSWORD, SESSION_AUTH_TOKEN
from web.http_responses import respond


def login(request):
    data = request.get_json()
    username = data[ACCOUNT_LOGIN_USERNAME]
    password = data[ACCOUNT_LOGIN_PASSWORD]
    if login_to_api(username, password):
        return respond(200)
    return respond(401)


def logout():
    session.clear()
    return respond(200)


def logged():
    if SESSION_AUTH_TOKEN in session:
        return respond(200)
    return respond(401)


def history():
    account_history = get_history()
    if account_history:
        return respond(200, account_history=account_history)
    return respond(401)
