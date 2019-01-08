from functools import wraps
import redis
from datetime import timedelta

from flask import Flask, jsonify, request
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token,
    create_refresh_token, get_jti,
    verify_jwt_in_request, jwt_refresh_token_required,
    get_jwt_identity, get_jwt_claims,
    jwt_required, get_raw_jwt
)

from flask_cors import CORS
import bcrypt
from common.db import Db
from common.globalErrorHandler import globalErrorHandler

import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

ACCESS_EXPIRES = timedelta(minutes=15)
REFRESH_EXPIRES = timedelta(days=30)
app.config['JWT_ACCESS_TOKEN_EXPIRES'] = ACCESS_EXPIRES
app.config['JWT_REFRESH_TOKEN_EXPIRES'] = REFRESH_EXPIRES
app.config['JWT_BLACKLIST_ENABLED'] = True
app.config['JWT_BLACKLIST_TOKEN_CHECKS'] = ['access', 'refresh']
app.config['JWT_SECRET_KEY'] = 'super-secret'  # Change this!

CORS(app)

jwt = JWTManager(app)


# Setup our redis connection for storing the blacklisted tokens
revoked_store = redis.StrictRedis(host='redis', port=6379, db=0,
                                  decode_responses=True)


@jwt.token_in_blacklist_loader
def check_if_token_is_revoked(decrypted_token):
    jti = decrypted_token['jti']
    entry = revoked_store.get(jti)
    if entry is None:
        return True
    return entry == 'true'


@jwt.user_claims_loader
def add_claims_to_access_token(user):
    return {'roles': user.roles, 'permissions': user.permissions}


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
    ret = {
        "msg": "User {} not found".format(identity)
    }
    return jsonify(ret), 404


def admin_required(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        verify_jwt_in_request()
        claims = get_jwt_claims()
        if 'admin' not in claims['roles']:
            return jsonify(msg='Admins only!'), 403
        else:
            return fn(*args, **kwargs)
    return wrapper


@app.route('/v1/auth/login', methods=['POST'])
def login():
    logger.info(request.is_json)
    if not request.is_json:
        return globalErrorHandler(msg="Missing JSON in request", err_code=400)

    username = request.json.get('username', None)
    password = request.json.get('password', None)
    if not username:
        return globalErrorHandler(msg="Missing username parameter", err_code=400)
    if not password:
        return globalErrorHandler(msg="Missing password parameter", err_code=400)

    cr_user = Db.get_user(user_identity=username)

    #hashed = bcrypt.hashpw(password, bcrypt.gensalt())
    if cr_user is None or bcrypt.hashpw(password.encode('utf-8'), b'$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy') != b'$2b$12$WdbdI4b/oZifO4LbbfwtQ.C3iHNOyJP1lvuxVH6fnbUgxQrFJqlfy':
        logger.error("User's {} pass or email not correct".format(username))
        return globalErrorHandler(msg="User's {} pass not correct".format(username), err_code=401)

    logger.info("User {} logged in".format(cr_user.username))

    access_token = create_access_token(identity=cr_user)
    refresh_token = create_refresh_token(identity=cr_user)

    access_jti = get_jti(encoded_token=access_token)
    refresh_jti = get_jti(encoded_token=refresh_token)
    revoked_store.set(access_jti, 'false', ACCESS_EXPIRES * 1.2)
    revoked_store.set(refresh_jti, 'false', REFRESH_EXPIRES * 1.2)

    ret = {
        'access_token': access_token,
        'refresh_token': refresh_token
    }
    return jsonify(ret), 201


# Protect a view with jwt_required, which requires a valid access token
# in the request to access.
@app.route('/v1/protected', methods=['GET'])
@jwt_required
def protected():
    # Access the identity of the current user with get_jwt_identity
    ret = {
        'current_identity': get_jwt_identity(),  # test
        'current_roles': get_jwt_claims()['roles'],  # ['foo', 'bar']
        'current_permissions': get_jwt_claims()['permissions']  # ['foo', 'bar']
    }
    return jsonify(ret), 200


# Endpoint for revoking the current users access token
@app.route('/v1/auth/logout', methods=['DELETE'])
@jwt_required
def logout():
    jti = get_raw_jwt()['jti']
    revoked_store.set(jti, 'true', ACCESS_EXPIRES * 1.2)
    return jsonify({"msg": "Access token revoked"}), 200


@app.route('/v1/test', methods=['GET'])
@admin_required
def test():
    return jsonify(users=Db.get_user(user_identity=get_jwt_identity()).to_json())

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)