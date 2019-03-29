# An example
from flask import Blueprint
from flask import current_app as app

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

actuator = Blueprint("actuators", __name__)

@actuator.route("/", methods = ['PUT', 'GET'])
@actuator.route("/<string:id>", methods = ['PUT', 'GET'])
@actuator.route("/<string:id>/<string:line_id>", methods = ['PUT', 'GET'])
def actuators(id=None, line_id=None):
    logger.info(app.config)
    return "Looking at the actuators for {id}; line_id {line_id}".format(id=id, line_id=line_id)