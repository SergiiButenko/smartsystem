from common.config.helpers import create_app, create_jwt
from web.models import *

app = create_app(__name__)
jwt = create_jwt(app)

app.register_blueprint(devices, url_prefix="/v1/devices")
app.register_blueprint(auth, url_prefix="/v1/auth")
app.register_blueprint(groups, url_prefix="/v1/groups")


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
