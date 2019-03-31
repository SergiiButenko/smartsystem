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
@devices.route("/<string:device_id>/<string:line_id>", methods = ['GET'])
#@jwt_required
def devices_route(device_id=None, line_id=None):
    cr_user = get_jwt_identity()
    
    if device_id is not None:
        logger.info("Returning lines device %s for user %s", device_id, cr_user)
        return jsonify(
            devices=Db.get_actuator_lines(device_id=device_id, user_identity=cr_user)
        )

    if line_id is None:
        logger.info("Returning all devices for user %s", cr_user)
        devices = Db.get_devices(device_id=device_id, user_identity=cr_user)

        for device_id, device in devices.items():
            devices[device_id]['lines'] = Db.get_actuator_lines(device_id=device_id, user_identity=cr_user)
        
        return jsonify(
            devices=devices
        )
    else:
        logger.info("Returning lines")
        return jsonify(
            lines=Db.get_actuators_line(device_id=device_id, line_id=line_id, user_identity=get_jwt_identity())
        )
    return "Looking at the devices for {device_id}; line_id {line_id}".format(device_id=device_id, line_id=line_id)