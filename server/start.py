from flask import Flask
import router
from api.account.session import MongoSessionInterface
from stations import updater


app = Flask(__name__)
app.session_interface = MongoSessionInterface()
router.route(app)
stations_updater = updater.StationsUpdater()
stations_updater.start()
