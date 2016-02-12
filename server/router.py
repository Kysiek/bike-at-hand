from flask import request

from api.account.endpoints import *
from api.bikes.endpoints import *
from api.stations.endpoints import * 
from api.decorators import authenticated


def route(app):
    @app.route('/')
    def index():
        return 'Welcome to Nextbike API!'
        
    @authenticated
    @app.route('/bikes/rent', methods=['POST'])
    def bikes_rent():
        return rent_bike(request)

    @authenticated
    @app.route('/bikes/return', methods=['POST'])
    def bikes_return():
        return return_bike(request)

    @authenticated
    @app.route('/bikes/unlock', methods=['POST'])
    def bikes_unlock():
        return unlock(request)

    @authenticated
    @app.route('/bikes/list', methods=['GET'])
    def bikes_list():
        return list_bikes()

    @app.route('/account/login', methods=['POST'])
    def account_login():
        return login(request)

    @authenticated
    @app.route('/account/logout', methods=['POST'])
    def account_logout():
        return logout()

    @app.route('/account/logged', methods=['GET'])
    def account_logged():
        return logged()

    @authenticated
    @app.route('/account/history', methods=['GET'])
    def account_history():
        return history()

    @app.route('/stations/all', methods=['GET'])
    def stations_all():
        return get_all()
