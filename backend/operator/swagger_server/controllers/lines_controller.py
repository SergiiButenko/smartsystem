import connexion
import six

from swagger_server.models.line import Line  # noqa: E501
from swagger_server import util


def get_all_lines():  # noqa: E501
    """Get summary for all lines

    Returns an array of line objects # noqa: E501


    :rtype: List[Line]
    """
    return 'do some magic!'
