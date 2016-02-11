from flask import Flask
from api.account.session import MongoSessionInterface
import router
from stations import updater


app = Flask(__name__)
app.debug = True
app.session_interface = MongoSessionInterface()
router.route(app)
stations_updater = updater.StationsUpdater()
stations_updater.start()

app.run(host='127.0.0.1', port=5001)
