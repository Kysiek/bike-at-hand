from flask import jsonify


def respond(status_code, **kwargs):
    return jsonify(**kwargs), status_code
