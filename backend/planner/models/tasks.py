# An example
from flask import Blueprint
from flask import jsonify

from flask_jwt_extended import (
    get_jwt_identity,
    jwt_required,
)
from common.resources.db import Db

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
tasks = Blueprint("tasks", __name__)

@tasks.route("/periodic", methods=["POST"])
@jwt_required
def periodic():
    cr_user = get_jwt_identity()

    return jsonify(cr_user=cr_user)

@tasks.route("/single", methods=["POST"])
@jwt_required
def single():
    cr_user = get_jwt_identity()

    return jsonify(cr_user=cr_user)
