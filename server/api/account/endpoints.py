from nbapi.api.account.session import clear_session, is_authenticated
from nbapi.config.constants import ACCOUNT_LOGIN_USERNAME, ACCOUNT_LOGIN_PASSWORD, SESSION_AUTH_TOKEN
from nbapi.api.account.login import login_to_api
from nbapi.web.http_responses import respond
from flask import jsonify, session


def login(request):
    data = request.get_json()
    username = data[ACCOUNT_LOGIN_USERNAME]
    password = data[ACCOUNT_LOGIN_PASSWORD]

    if login_to_api(username, password):
        return respond(200, auth_token=session[SESSION_AUTH_TOKEN])

    clear_session()
    return respond(401)

def logout(request):
    clear_session()
    return respond(200)

def logged(request):
    data = request.get_json()
    auth_token = data[SESSION_AUTH_TOKEN]
    if is_authenticated(auth_token):
        return respond(200)
    return respond(401)
