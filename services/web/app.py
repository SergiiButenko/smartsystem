from web.factories.create_app import create_jwt_app, create_flask_app
from web.views import auth, devices, groups
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


app, socketio = create_flask_app(__name__)
jwt = create_jwt_app(app)

app.register_blueprint(devices, url_prefix="/v1/devices")
app.register_blueprint(auth, url_prefix="/v1/auth")
app.register_blueprint(groups, url_prefix="/v1/groups")

if __name__ == "__main__":
    socketio.run(host="0.0.0.0", debug=True)
