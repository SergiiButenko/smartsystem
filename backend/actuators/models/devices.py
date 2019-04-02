# An example
from flask import Blueprint
from flask import jsonify

from flask_jwt_extended import (
    get_jwt_identity,
    jwt_required,
)
from common.database.db import Db

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
devices = Blueprint("devices", __name__)


@devices.route("/", methods=["GET"])
@devices.route("/<string:device_id>", methods=["GET"])
# @jwt_required
def devices_route(device_id=None):
    cr_user = get_jwt_identity()

    return jsonify(Db.get_devices(device_id=device_id, user_identity=cr_user))


@devices.route("/<string:device_id>/lines", methods=["GET"])
@devices.route("/<string:device_id>/lines/<string:line_id>", methods=["GET"])
# @jwt_required
def devices_lines_route(device_id, line_id=None):
    cr_user = get_jwt_identity()

    devices = Db.get_devices(device_id=device_id, user_identity=cr_user)
    for device_id, device in devices.items():
        devices[device_id]["lines"] = Db.get_actuator_lines(device_id=device_id, line_id=line_id, user_identity=cr_user)

    return jsonify(devices)
