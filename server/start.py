from server import instance
import router
from stations import updater


DEBUG=True
DEBUG_HOST='localhost'
DEBUG_PORT=5000


app = instance.get_app(__name__)
router.route(app)
stations_updater = updater.StationsUpdater()
stations_updater.start()

if DEBUG:
    app.run(host=DEBUG_HOST, port=DEBUG_PORT)