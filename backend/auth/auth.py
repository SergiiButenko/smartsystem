from flask import Flask, jsonify, request
from flask_jwt_extended import (
    JWTManager, jwt_required, create_access_token,
    get_jwt_identity, get_jwt_claims
)
from flask_cors import CORS
from backend.common.user import User
from backend.common.globalErrorHandler import GlobalErrorHandler

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


# Provide a method to create access tokens. The create_access_token()
# function is used to actually generate the token, and you can return
# it to the caller however you choose.
@app.route('/login', methods=['POST'])
def login():
    logger.info(request.is_json)
    if not request.is_json:
        return GlobalErrorHandler(msg="Missing JSON in request", errCode=400)

    username = request.json.get('username', None)
    password = request.json.get('password', None)
    if not username:
        return GlobalErrorHandler(msg="Missing username parameter", errCode=400)
    if not password:
        return GlobalErrorHandler(msg="Missing password parameter", errCode=400)

    if username != 'test' or password != 'test':
        return GlobalErrorHandler(msg="Bad username or password", errCode=401)

    # Create an example UserObject
    user = User(username='test', roles=['admin'], permissions=['rw'])

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
@app.route('/protected', methods=['GET'])
@jwt_required
def protected():
    # Access the identity of the current user with get_jwt_identity
    ret = {
        'current_identity': get_jwt_identity(),  # test
        'current_roles': get_jwt_claims()['roles'],  # ['foo', 'bar']
        'current_permissions': get_jwt_claims()['permissions']  # ['foo', 'bar']
    }
    return jsonify(ret), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)