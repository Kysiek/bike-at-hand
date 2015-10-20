from api.account.session import MongoSession
from config.constants import ACCOUNT_LOGIN_USERNAME, ACCOUNT_LOGIN_PASSWORD, SESSION_AUTH_TOKEN
from web.http_responses import respond


def login(request):
    data = request.get_json()
    username = data[ACCOUNT_LOGIN_USERNAME]
    password = data[ACCOUNT_LOGIN_PASSWORD]
    token = MongoSession(username=username, password=password).get_token()

    if token:
        return respond(200, auth_token=token)
    return respond(401)

def logout(request):
    MongoSession(token=request.get_json()[SESSION_AUTH_TOKEN]).destroy()
    return respond(200)

def logged(request):
    data = request.get_json()
    if MongoSession(token=request.get_json()[SESSION_AUTH_TOKEN]).is_authenticated():
        return respond(200)
    return respond(401)
