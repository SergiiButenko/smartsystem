from web.models import DeviceTask
from flask import jsonify, request, Blueprint

from flask_jwt_extended import get_jwt_identity, jwt_required

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

tasks = Blueprint("tasks", __name__)


@tasks.route("/<string:device_id>", methods=["POST"])
# @jwt_required
def set_rules_for_device(device_id):
    cr_user = get_jwt_identity()
    income_json = request.json
    # income_json = {
    #     'lines':
    #         [
    #             {'line_id': '80122552-18bc-4846-9799-0b728324251c', 'time': 10, 'iterations': 2, 'time_sleep': 15},
    #         ],
    # }
    tasks_arr = DeviceTask(device_id=device_id, lines=income_json["lines"]).register()

    return jsonify(tasks=tasks_arr)


@tasks.route("/<string:date_start>/<string:date_end>", methods=["GET"])
# @jwt_required
def get_all_tasks(date_start, date_end):
    cr_user = get_jwt_identity()
    return "OK"


@tasks.route("/<string:device_id>/<string:date_start>/<string:date_end>", methods=["GET"])
@jwt_required
def get_rules_for_device(device_id):
    cr_user = get_jwt_identity()

    # to check device exists
    Device.get_by_id(device_id=device_id, user_identity=cr_user)

    tasks = Task.get_next_task_by_device_id(device_id=device_id)

    return jsonify(tasks=tasks)
