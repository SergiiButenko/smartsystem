# An example
from flask import jsonify, request, Blueprint

from flask_jwt_extended import (
    get_jwt_identity,
    jwt_required,
)
from common.resources.db import Db
from common.config.helpers import validate_json, check_device

import logging

from common.resources.planner import RulesPlanner

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
        device.lines = Db.get_device_lines(device_id=device.device_id, line_id=None, user_identity=cr_user)

    return jsonify(devices=devices)


@devices.route("/<string:device_id>/lines/rules", methods=["GET"])
#@jwt_required
#@check_device
def get_rules_for_device(device_id):
    cr_user = get_jwt_identity()

    income_json = {
        'lines':
            [
                {'line_id': '1', 'time': 10, 'iterations': 2, 'time_sleep': 15},
            {'line_id': '2', 'time': 10, 'iterations': 2, 'time_sleep': 15}
                ],

    }
    ids = RulesPlanner.add_rules(device_id=device_id, lines=income_json['lines'], user_identity=cr_user)

    return jsonify(rules=ids)

    # # 'device_exists' wrapper exclude device is none
    # rules = RulesPlanner.get_next_rules(device_id=device_id, user_identity=cr_user)
    #
    # return jsonify(rules=ids)


@devices.route("/<string:device_id>/lines/rules", methods=["POST"])
@jwt_required
@validate_json
def set_rules_for_device(device_id):
    cr_user = get_jwt_identity()
    income_json = request.json
    # {'lines': {
    # 	'id': {'line_id': 'id', 'time': 10, 'iterations': 2, 'time_sleep': 15},
    # 	'id': {'line_id': 'id', 'time': 10, 'iterations': 2, 'time_sleep': 15}...
    # 	}
    # }
    ids = RulesPlanner.add_rules(device_id=device_id, lines=income_json['lines'], user_identity=cr_user)

    return jsonify(rules=ids)


@devices.route("/<string:device_id>/lines/rules", methods=["DELETE"])
@jwt_required
@validate_json
def delete_rules_for_device(device_id):
    cr_user = get_jwt_identity()
    income_json = request.json

    ids = RulesPlanner.add_rules(device_id=device_id, lines=income_json['lines'], user_identity=cr_user)

    return jsonify(rules=ids)
