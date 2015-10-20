from api.account.session import MongoSession
from flask import jsonify
from config.constants import SESSION_AUTH_TOKEN


def authenticated(func):
    def func_wrapper(*args):
        token = None
        if SESSION_AUTH_TOKEN in args:
            token = args[SESSION_AUTH_TOKEN]
        elif SESSION_AUTH_TOKEN in request.get_json():
            token = request.get_json()[SESSION_AUTH_TOKEN]
        if MongoSession(token=token).is_authenticated():
            return func
        return jsonify(), 401
    return func_wrapper

