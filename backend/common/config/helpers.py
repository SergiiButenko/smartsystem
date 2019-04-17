from common.errors.common_errors import handle_common_errors
from common.errors import * 

from common.config.config import *
from flask import Flask
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    create_refresh_token,
    get_jti,
    get_jwt_claims,
    get_jwt_identity,
    get_raw_jwt,
    jwt_refresh_token_required,
    jwt_required,
    verify_jwt_in_request,
)
from functools import wraps
import logging
from common.resources import Db, redis

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


def create_jwt(app):
    jwt = JWTManager(app)

    @jwt.token_in_blacklist_loader
    def check_if_token_is_revoked(decrypted_token):
        jti = decrypted_token["jti"]
        entry = redis.get(jti)
        if entry is None:
            return True
        return entry == "true"

    @jwt.user_claims_loader
    def add_claims_to_access_token(user):
        return {"roles": user.roles}

    @jwt.user_identity_loader
    def user_identity_lookup(user):
        return user.username

    @jwt.user_loader_callback_loader
    def user_loader_callback(identity):
        cr_user = Db.get_user(user_identity=identity)
        if identity != cr_user.username:
            return None
        return cr_user

    @jwt.user_loader_error_loader
    def custom_user_loader_error(identity):
        raise WrongCreds()

    return jwt


def admin_required(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        verify_jwt_in_request()
        claims = get_jwt_claims()
        if "admin" not in claims["roles"]:
            raise UnexpectedRole()
        else:
            return fn(*args, **kwargs)

    return wrapper


def check_device(f):
    @wraps(f)
    def wrapper(*args, **kwargs):
        device_id=kwargs['device_id']
        device = Db.get_devices(device_id=device_id, user_identity=get_jwt_identity())
        if len(device) == 0:
            raise GeneralError(message='Device {} does not exists'.format(device_id))
        if len(device) > 1:
            raise GeneralError(message='Device {} has multiple database records'.format(device_id))
        return f(*args, **kwargs)
    return wrapper