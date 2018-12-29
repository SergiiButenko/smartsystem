from functools import wraps

from flask import Flask, jsonify, request
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token,
    verify_jwt_in_request,
    get_jwt_identity, get_jwt_claims
)
from flask_cors import CORS
from common.user import User
from common.db import Db
from common.globalErrorHandler import globalErrorHandler

import logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Setup the Flask-JWT-Extended extension
app.config['JWT_SECRET_KEY'] = 'super-secret'  # Change this!
jwt = JWTManager(app)


# Create a function that will be called whenever create_access_token
# is used. It will take whatever object is passed into the
# create_access_token method, and lets us define what custom claims
# should be added to the access token.
@jwt.user_claims_loader
def add_claims_to_access_token(user):
    return {'roles': user.roles, 'permissions': user.permissions}


# Create a function that will be called whenever create_access_token
# is used. It will take whatever object is passed into the
# create_access_token method, and lets us define what the identity
# of the access token should be.
@jwt.user_identity_loader
def user_identity_lookup(user):
    return user.username


# This function is called whenever a protected endpoint is accessed,
# and must return an object based on the tokens identity.
# This is called after the token is verified, so you can use
# get_jwt_claims() in here if desired. Note that this needs to
# return None if the user could not be loaded for any reason,
# such as not being found in the underlying data store
@jwt.user_loader_callback_loader
def user_loader_callback(identity):
    cr_user = Db.get_user(user_identity=identity)

    if identity != cr_user.username:
        return None

    return cr_user


# You can override the error returned to the user if the
# user_loader_callback returns None. If you don't override
# this, # it will return a 401 status code with the JSON:
# {"msg": "Error loading the user <identity>"}.
# You can use # get_jwt_claims() here too if desired
@jwt.user_loader_error_loader
def custom_user_loader_error(identity):
    ret = {
        "msg": "User {} not found".format(identity)
    }
    return jsonify(ret), 404


# Here is a custom decorator that verifies the JWT is present in
# the request, as well as insuring that this user has a role of
# `admin` in the access token
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

# Provide a method to create access tokens. The create_access_token()
# function is used to actually generate the token, and you can return
# it to the caller however you choose.
@app.route('/v1/login', methods=['POST'])
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

    if username != 'test' or password != 'test':
        return globalErrorHandler(msg="Bad username or password", err_code=401)

    # Create an example UserObject
    user = User(username='admin', roles=['admin'], permissions=['rw'])

    # We can now pass this complex object directly to the
    # create_access_token method. This will allow us to access
    # the properties of this object in the user_claims_loader
    # function, and get the identity of this object from the
    # user_identity_loader function.
    access_token = create_access_token(identity=user)
    ret = {'access_token': access_token}
    return jsonify(ret), 200


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

@app.route('/v1/test', methods=['GET'])
@admin_required
def test():
    return jsonify(users=Db.get_user(user_identity=get_jwt_identity()).to_json())

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)