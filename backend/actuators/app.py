from common.config.helpers import create_app, create_jwt
from actuators.models import *

app = create_app(__name__)
jwt = create_jwt(app)

app.register_blueprint(actuator, url_prefix='/v1/actuators')
app.register_blueprint(auth, url_prefix='/v1/auth')
app.register_blueprint(test, url_prefix='/v1/test')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
