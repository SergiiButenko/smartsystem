from common.errors.common_errors import handle_common_errors
from common.config.config import *
from flask import Flask
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app(name):
    app = Flask(name)

    app = handle_common_errors(app)

    app.config["JWT_ACCESS_TOKEN_EXPIRES"] = ACCESS_EXPIRES
    app.config["JWT_REFRESH_TOKEN_EXPIRES"] = REFRESH_EXPIRES
    app.config["JWT_BLACKLIST_ENABLED"] = True
    app.config["JWT_BLACKLIST_TOKEN_CHECKS"] = ["access", "refresh"]
    app.config["JWT_SECRET_KEY"] = "super-secret"  # Change this!

    return app
