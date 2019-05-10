# An example
from flask import Blueprint
from flask import jsonify

from flask_jwt_extended import get_jwt_identity, jwt_required
import logging

from web.factories import Groups

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
groups = Blueprint("groups", __name__)


@groups.route("/", methods=["GET"])
@jwt_required
def groups_route():
    cr_user = get_jwt_identity()

    return jsonify(groups=Groups.get_all(user_identity=cr_user))


@groups.route("/<string:group_id>", methods=["GET"])
@jwt_required
def groups_lines_route(group_id):
    cr_user = get_jwt_identity()

    # list is applied here for so frontend can work with arrays only
    return jsonify(groups=[Groups.get_by_id(group_id=group_id, user_identity=cr_user)])
