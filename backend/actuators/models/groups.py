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
groups = Blueprint("groups", __name__)


@groups.route("/", methods=["GET"])
@groups.route("/<string:group_id>", methods=["GET"])
@jwt_required
def groups_route(group_id=None):
    cr_user = get_jwt_identity()

    return jsonify(groups=Db.get_groups(group_id=group_id, user_identity=cr_user))


@groups.route("/<string:group_id>/lines", methods=["GET"])
@jwt_required
def groups_lines_route(group_id):
    cr_user = get_jwt_identity()

    groups = Db.get_groups(group_id=group_id, user_identity=cr_user)
    for group_id, group in groups.items():
        groups[group_id]["lines"] = Db.get_group_lines(group_id=group_id, user_identity=cr_user)

    return jsonify(groups=groups)
