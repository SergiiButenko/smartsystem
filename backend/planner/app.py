from common.config.helpers import create_app, create_jwt
from planner.models import *

app = create_app(__name__)
jwt = create_jwt(app)

app.register_blueprint(tasks, url_prefix="/v1/tasks")

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
