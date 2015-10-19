from api.account.session import MongoSession
from flask import jsonify
from config.constants import SESSION_AUTH_TOKEN


def authenticated(func):
    def func_wrapper(*args):
        if MongoSession(token=request.get_json()[SESSION_AUTH_TOKEN]).is_authenticated():
            return func
        return jsonify(), 401
    return func_wrapper
