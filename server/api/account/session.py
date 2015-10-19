from flask import session
from server.config.constants import SESSION_USERNAME, SESSION_PASSWORD, SESSION_TOKEN, SESSION_AUTH_TOKEN
from server.parser.html_data import is_logged
from server.web.http_requests import get
import uuid

def start_session(username, password, session_token):
    session.permanent = True
    session[SESSION_USERNAME] = username
    session[SESSION_PASSWORD] = password
    session[SESSION_TOKEN] = session_token
    session[SESSION_AUTH_TOKEN] = uuid.uuid4().hex

def clear_session():
    session.clear()

def check_session():
    response = get()
    return is_logged(response.text)

def is_authenticated(request):
    if SESSION_AUTH_TOKEN in session and SESSION_AUTH_TOKEN in request.cookies and len(session[SESSION_AUTH_TOKEN]) > 1 and len(request.cookies[SESSION_AUTH_TOKEN]) > 1:
        return session[SESSION_AUTH_TOKEN] == request.cookies[SESSION_AUTH_TOKEN]
    return False
