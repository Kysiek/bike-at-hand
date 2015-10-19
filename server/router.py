from flask import request

from api.account.endpoints import login, logout, logged
from api.stations.endpoints import all
from api.decorators import authenticated


def route(app):
    @app.route('/')
    def index():
        return 'Welcome to Nextbike API!'
        
    @authenticated
    @app.route('/bikes/rent')
    def bikes_rent():
        return 'Hello World @ /rent!'

    @authenticated
    @app.route('/bikes/return')
    def bikes_return():
        return 'Hello World @ /return!'

    @app.route('/account/login', methods=['POST'])
    def account_login():
        return login(request)

    @authenticated
    @app.route('/account/logout', methods=['POST'])
    def account_logout():
        return logout(request)

    @app.route('/account/logged', methods=['POST'])
    def account_logged():
        return logged(request)

    @app.route('/stations/all')
    def stations_all():
        return all()