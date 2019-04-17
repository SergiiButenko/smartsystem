# An example
from flask import Blueprint
from flask import jsonify

from flask_jwt_extended import (
    get_jwt_identity,
    jwt_required,
)
from common.resources.db import Db
from common.config.helpers import check_device

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
devices = Blueprint("devices", __name__)


@devices.route("/", methods=["GET"])
@jwt_required
def devices_route(device_id=None):
    cr_user = get_jwt_identity()

    return jsonify(devices=Db.get_devices(device_id=device_id, user_identity=cr_user))

@devices.route("/<string:device_id>", methods=["GET"])
@jwt_required
@check_device
def devices_lines_route(device_id):
    cr_user = get_jwt_identity()

    devices = Db.get_devices(device_id=device_id, user_identity=cr_user)
    for device in devices:
        device["lines"] = Db.get_device_lines(device_id=device['id'], line_id=None, user_identity=cr_user)

    return jsonify(devices=devices)

@devices.route("/<string:device_id>", methods=["PATCH"])
@jwt_required
@check_device
def activate_lines(device_id):
	if request.is_json is False:
		raise NoJson()

	income_json = request.get_json()
	err = ''# checkJson(SCHEMA, income_json)
	if err != '':
		raise JsonMalformed(description=err)

	# {'lines': {
	# 	'id': {'line_id': 'id', 'time': 10, 'iterations': 2, 'time_sleep': 15},
	# 	'id': {'line_id': 'id', 'time': 10, 'iterations': 2, 'time_sleep': 15}...
	# 	}
	# }

	# device_exists wrapper exclude device is none
	device = Db.get_devices(device_id=device_id, user_identity=cr_user)[0]
	for line in income_json['lines'].items():
		rule = Rule(device=device, **line)
	
	
		