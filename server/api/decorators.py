from flask import jsonify, session
from config.constants import SESSION_AUTH_TOKEN


def authenticated(func):
    def func_wrapper(*args):
        if SESSION_AUTH_TOKEN in session:
            return func
        return jsonify(), 401
    return func_wrapper

