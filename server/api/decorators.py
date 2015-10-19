from api.account.session import is_authenticated
from flask import jsonify


def authenticated(func):
    def func_wrapper(*args):
        if is_authenticated(request):
            return func
        return jsonify(), 401
    return func_wrapper
