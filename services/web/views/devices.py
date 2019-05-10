# An example
from flask import jsonify, request, Blueprint

from flask_jwt_extended import get_jwt_identity, jwt_required

import logging

from web.factories import Devices, Tasks
from web.factories.create_app import validate_json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

devices = Blueprint("devices", __name__)


@devices.route("/", methods=["GET"])
# @jwt_required
def devices_route():
    cr_user = get_jwt_identity()

    return jsonify(devices=Devices.get_all(user_identity=cr_user))


@devices.route("/<string:device_id>", methods=["GET"])
# @jwt_required
def devices_lines_route(device_id):
    cr_user = get_jwt_identity()

    return jsonify(
        devices=[Devices.get_by_id(device_id=device_id, user_identity=cr_user)]
    )


@devices.route("/<string:device_id>/tasks", methods=["GET"])
@jwt_required
def get_rules_for_device(device_id):
    cr_user = get_jwt_identity()

    device = Devices.get_by_id(device_id=device_id, user_identity=cr_user)
    tasks = Tasks.get_next_tasks(device=device)

    return jsonify(tasks=tasks)


@devices.route("/<string:device_id>/tasks", methods=["POST"])
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

    device = Devices.get_by_id(device_id=device_id, user_identity=cr_user)
    tasks = Tasks.register_tasks(device=device, lines=income_json["lines"])

    return jsonify(tasks=tasks)


@devices.route("/<string:device_id>/tasks", methods=["DELETE"])
@jwt_required
@validate_json
def delete_rules_for_device(device_id):
    income_json = request.json
    Tasks.remove_tasks(rules=income_json["rules"])

    return jsonify(state="ok")


@devices.route("/<string:device_id>/state", methods=["GET"])
# @jwt_required
def get_state(device_id):
    cr_user = get_jwt_identity()

    device = Devices.get_by_id(device_id=device_id, user_identity=cr_user)
    device.init_state()

    return jsonify(state="ok")
