from werkzeug.exceptions import default_exceptions
from werkzeug.exceptions import HTTPException
from flask import Flask, jsonify


def get_app(import_name, **kwargs):
    def make_json_error(ex):
        response = jsonify(message=str(ex))
        response.status_code = (ex.code if isinstance(ex, HTTPException) else 500)
        return response

    application = Flask(import_name, **kwargs)

    for code in default_exceptions.iterkeys():
        application.error_handler_spec[None][code] = make_json_error

    application.config.from_object('nbapi.config.flask')
        
    return application
