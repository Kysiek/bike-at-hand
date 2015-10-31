from server import instance
import router
from stations import updater


app = instance.get_app(__name__)
router.route(app)
stations_updater = updater.StationsUpdater()
stations_updater.start()

app.run(host='127.0.0.1', port=5001)