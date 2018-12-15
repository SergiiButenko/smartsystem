# coding: utf-8

from __future__ import absolute_import
from datetime import date, datetime  # noqa: F401

from typing import List, Dict  # noqa: F401

from swagger_server.models.base_model_ import Model
from swagger_server import util


class Line(Model):
    """NOTE: This class is auto generated by the swagger code generator program.

    Do not edit the class manually.
    """

    def __init__(self, id: int=None, status: str=None, linked_sensor: str=None):  # noqa: E501
        """Line - a model defined in Swagger

        :param id: The id of this Line.  # noqa: E501
        :type id: int
        :param status: The status of this Line.  # noqa: E501
        :type status: str
        :param linked_sensor: The linked_sensor of this Line.  # noqa: E501
        :type linked_sensor: str
        """
        self.swagger_types = {
            'id': int,
            'status': str,
            'linked_sensor': str
        }

        self.attribute_map = {
            'id': 'id',
            'status': 'status',
            'linked_sensor': 'linkedSensor'
        }

        self._id = id
        self._status = status
        self._linked_sensor = linked_sensor

    @classmethod
    def from_dict(cls, dikt) -> 'Line':
        """Returns the dict as a model

        :param dikt: A dict.
        :type: dict
        :return: The Line of this Line.  # noqa: E501
        :rtype: Line
        """
        return util.deserialize_model(dikt, cls)

    @property
    def id(self) -> int:
        """Gets the id of this Line.


        :return: The id of this Line.
        :rtype: int
        """
        return self._id

    @id.setter
    def id(self, id: int):
        """Sets the id of this Line.


        :param id: The id of this Line.
        :type id: int
        """

        self._id = id

    @property
    def status(self) -> str:
        """Gets the status of this Line.

        Line Status  # noqa: E501

        :return: The status of this Line.
        :rtype: str
        """
        return self._status

    @status.setter
    def status(self, status: str):
        """Sets the status of this Line.

        Line Status  # noqa: E501

        :param status: The status of this Line.
        :type status: str
        """
        allowed_values = ["inProgress", "active", "notActive"]  # noqa: E501
        if status not in allowed_values:
            raise ValueError(
                "Invalid value for `status` ({0}), must be one of {1}"
                .format(status, allowed_values)
            )

        self._status = status

    @property
    def linked_sensor(self) -> str:
        """Gets the linked_sensor of this Line.

        Linked sensor id, if present  # noqa: E501

        :return: The linked_sensor of this Line.
        :rtype: str
        """
        return self._linked_sensor

    @linked_sensor.setter
    def linked_sensor(self, linked_sensor: str):
        """Sets the linked_sensor of this Line.

        Linked sensor id, if present  # noqa: E501

        :param linked_sensor: The linked_sensor of this Line.
        :type linked_sensor: str
        """

        self._linked_sensor = linked_sensor
