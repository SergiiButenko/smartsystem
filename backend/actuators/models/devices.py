# An example
from flask import Blueprint
from flask import current_app as app
from flask import jsonify, request

from flask_jwt_extended import (
    get_jti,
    get_jwt_claims,
    get_jwt_identity,
    get_raw_jwt,
    jwt_refresh_token_required,
    jwt_required,
    verify_jwt_in_request,
)
from common.models.db import Db

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
devices = Blueprint("devices", __name__)

@devices.route("/", methods = ['GET'])
@devices.route("/<string:device_id>", methods = ['GET'])
#@jwt_required
def devices_route(device_id=None):
    cr_user = get_jwt_identity()
    
    devices=Db.get_devices(device_id=device_id, user_identity=cr_user)
    for device_id, device in devices.items():
        devices[device_id]['lines']=Db.get_actuator_lines(device_id=device_id)
    
    return jsonify(
            devices=devices
        )
    