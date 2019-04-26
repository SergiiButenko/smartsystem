from common.errors.common_errors import handle_common_errors
from common.errors import *

from common.config.config import *
from flask.json import JSONEncoder
from flask import Flask, jsonify, request
from flask_jwt_extended import (
    JWTManager,
    get_jwt_claims,
    get_jwt_identity,
    verify_jwt_in_request,
)
from functools import wraps
import logging

from common.resources import Db, redis
from werkzeug.exceptions import BadRequest
from werkzeug.routing import ValidationError

from common.errors import GeneralError, NoJson, JsonMalformed

from common.models import Device, User, Line, Group, Task, PeriodicRule


logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def create_app(name):
    app = Flask(name)

    app = handle_common_errors(app)
    app.json_encoder = CustomJSONEncoder

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


def validate_json(f):
    @wraps(f)
    def wrapper(*args, **kw):
        try:
            if request.is_json is False:
                raise NoJson()

            request.json
        except BadRequest as e:
            raise JsonMalformed(message="Payload must be a valid json")
        return f(*args, **kw)

    return wrapper


def validate_schema(schema_name):
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kw):
            try:
                # validate(request.json, current_app.config[schema_name])
                pass
            except ValidationError as e:
                return jsonify({"error": e.message}), 400
            return f(*args, **kw)

        return wrapper

    return decorator


class CustomJSONEncoder(JSONEncoder):
    def default(self, obj):
        try:
            if isinstance(obj, (PeriodicRule, Device, Group, Line, User, Task)):
                return obj.serialize()
            iterable = iter(obj)
        except TypeError as e:
            logger.error(e)
        else:
            return list(iterable)
        return JSONEncoder.default(self, obj)
