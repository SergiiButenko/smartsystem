# An example
from flask import Blueprint
from flask import jsonify, request
from flask_jwt_extended import (
    jwt_required,
    get_jwt_claims,
    verify_jwt_in_request
)
from common.config.helpers import admin_required

test = Blueprint("test", __name__)


# Protect a view with jwt_required, which requires a valid access token
# in the request to access.
@test.route("/protected", methods=["GET"])
@jwt_required
def protected():
    ret = {
        "current_identity": get_jwt_identity(),
        "current_roles": get_jwt_claims()["roles"],
    }
    return jsonify(ret), 200

@test.route("/", methods=["GET"])
@admin_required
def test_route():
    return jsonify(users=Db.get_user(user_identity=get_jwt_identity()).to_json())

