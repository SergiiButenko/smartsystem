import connexion
import six

from swagger_server.models.line import Line  # noqa: E501
from swagger_server import util


def lines_line_id_command_post(lineId, command):  # noqa: E501
    """Enable line of line by ID.

     # noqa: E501

    :param lineId: Line id to process
    :type lineId: str
    :param command: Command to execute againg line
    :type command: str

    :rtype: Line
    """
    return 'do some magic!'


def lines_line_id_get(lineId):  # noqa: E501
    """Returns summary of line by ID.

     # noqa: E501

    :param lineId: Line id to process
    :type lineId: str

    :rtype: Line
    """
    return 'do some magic!'


def lines_line_id_put(lineId):  # noqa: E501
    """Change settings for line by id.

     # noqa: E501

    :param lineId: Line id to process
    :type lineId: str

    :rtype: Line
    """
    return 'do some magic!'
