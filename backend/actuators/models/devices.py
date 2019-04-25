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
        device.lines = Db.get_device_lines(device_id=device.id, line_id=None, user_identity=cr_user)

    return jsonify(devices=devices)


@devices.route("/<string:device_id>/rules", methods=["GET"])
@jwt_required
def get_rules_for_device(device_id):
    cr_user = get_jwt_identity()

    device = Db.get_devices(device_id=device_id, user_identity=cr_user)[0]

    rules = RulesPlanner.get_next_rules(device=device)

    return jsonify(rules=rules)


@devices.route("/<string:device_id>/rules", methods=["POST"])
@jwt_required
@validate_json
def set_rules_for_device(device_id):
    cr_user = get_jwt_identity()
    income_json = request.json
    # income_json = {
    #     'lines':
    #         [
    #             {'line_id': '80122552-18bc-4846-9799-0b728324251c', 'time': 10, 'iterations': 2, 'time_sleep': 15},
    #         ],
    # }
    device = Db.get_devices(device_id=device_id, user_identity=cr_user)[0]
    lines = income_json['lines']
    rules = RulesPlanner.add_rules(device=device, lines=lines)

    return jsonify(rules=rules)


@devices.route("/<string:device_id>/rules", methods=["DELETE"])
@jwt_required
@validate_json
def delete_rules_for_device(device_id):
    cr_user = get_jwt_identity()
    #income_json = request.json

    ids = RulesPlanner.remove_rules(rules=rules)

    return jsonify(rules=ids)


@devices.route("/<string:device_id>/state", methods=["GET"])
@jwt_required
def delete_rules_for_device(device_id):

    return jsonify(state='ok')


@devices.route("/<string:device_id>/state", methods=["PUT"])
@jwt_required
def delete_rules_for_device(device_id):

    return jsonify(state="ok")
