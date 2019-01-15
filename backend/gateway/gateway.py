import logging
from functools import wraps

import bcrypt
import redis
from flask import jsonify, request

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

from common.db import Db
from common.config.config import create_app
from common.errors import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = create_app(__name__)
jwt = JWTManager(app)

revoked_store = redis.StrictRedis(host="redis", port=6379, db=0, decode_responses=True)

@jwt.token_in_blacklist_loader
def check_if_token_is_revoked(decrypted_token):
    jti = decrypted_token["jti"]
    entry = revoked_store.get(jti)
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


@app.route("/v1/auth/login", methods=["POST"])
def login():
    logger.info(request.is_json)
    if not request.is_json:
        raise GeneralError(message="Empty JSON")

    username = request.json.get("username", None)
    password = request.json.get("password", None)
    if not username or not password:
        raise GeneralError(message="Empty password or username")

    current_user = Db.get_user(user_identity=username)

    # hashed = bcrypt.hashpw(password, bcrypt.gensalt())
    if (
        current_user is None
        or bcrypt.hashpw(
            password.encode("utf-8"),
            b"$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy",
        )
        != b"$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy"
    ):
        logger.error("User's {} pass or email not correct".format(username))
        raise WrongCreds()

    logger.info("User {} logged in".format(current_user.username))

    access_token = create_access_token(identity=current_user)
    refresh_token = create_refresh_token(identity=current_user)

    access_jti = get_jti(encoded_token=access_token)
    refresh_jti = get_jti(encoded_token=refresh_token)

    revoked_store.set(access_jti, "false", app.config['JWT_ACCESS_TOKEN_EXPIRES'] * 1.2)
    revoked_store.set(refresh_jti, "false", app.config['JWT_REFRESH_TOKEN_EXPIRES'] * 1.2)

    ret = {"access_token": access_token, "refresh_token": refresh_token}

    return jsonify(ret), 201


@app.route('/v1/auth/refreshToken', methods=['POST'])
@jwt_refresh_token_required
def refresh():
    jti = get_raw_jwt()["jti"]
    status = revoked_store.set(refresh_jti, "false", app.config['JWT_REFRESH_TOKEN_EXPIRES'] * 1.2)

    if status is False:
        raise UnableToRefresh()

    current_user = get_jwt_identity()
    access_token = create_access_token(identity=current_user)
    access_jti = get_jti(encoded_token=access_token)
    revoked_store.set(access_jti, "false", app.config['JWT_ACCESS_TOKEN_EXPIRES'] * 1.2)        

    ret = {
        'access_token': create_access_token(identity=current_user)
    }

    return jsonify(ret), 200


# Protect a view with jwt_required, which requires a valid access token
# in the request to access.
@app.route("/v1/protected", methods=["GET"])
@jwt_required
def protected():
    ret = {
        "current_identity": get_jwt_identity(),
        "current_roles": get_jwt_claims()["roles"],
    }
    return jsonify(ret), 200


# Endpoint for revoking the current users access token
@app.route("/v1/auth/logout", methods=["DELETE"])
@jwt_required
def logout():
    jti = get_raw_jwt()["jti"]
    revoked_store.set(jti, "true",  app.config['JWT_ACCESS_TOKEN_EXPIRES'] * 1.2)
    return jsonify({"msg": "Access token revoked"}), 200


@app.route("/v1/test", methods=["GET"])
@admin_required
def test():
    return jsonify(users=Db.get_user(user_identity=get_jwt_identity()).to_json())


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
