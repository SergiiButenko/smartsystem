# coding: utf-8

from __future__ import absolute_import

from datetime import date, datetime  # noqa: F401
from typing import Dict, List  # noqa: F401

from swagger_server import util
from swagger_server.models.base_model_ import Model


class Sensor(Model):
    """NOTE: This class is auto generated by the swagger code generator program.

    Do not edit the class manually.
    """

    def __init__(
        self,
        id: int = None,
        status: str = None,
        linked_line: str = None,
        value: object = None,
    ):  # noqa: E501
        """Sensor - a model defined in Swagger

        :param id: The id of this Sensor.  # noqa: E501
        :type id: int
        :param status: The status of this Sensor.  # noqa: E501
        :type status: str
        :param linked_line: The linked_line of this Sensor.  # noqa: E501
        :type linked_line: str
        :param value: The value of this Sensor.  # noqa: E501
        :type value: object
        """
        self.swagger_types = {
            "id": int,
            "status": str,
            "linked_line": str,
            "value": object,
        }

        self.attribute_map = {
            "id": "id",
            "status": "status",
            "linked_line": "linkedLine",
            "value": "value",
        }

        self._id = id
        self._status = status
        self._linked_line = linked_line
        self._value = value

    @classmethod
    def from_dict(cls, dikt) -> "Sensor":
        """Returns the dict as a model

        :param dikt: A dict.
        :type: dict
        :return: The Sensor of this Sensor.  # noqa: E501
        :rtype: Sensor
        """
        return util.deserialize_model(dikt, cls)

    @property
    def id(self) -> int:
        """Gets the id of this Sensor.


        :return: The id of this Sensor.
        :rtype: int
        """
        return self._id

    @id.setter
    def id(self, id: int):
        """Sets the id of this Sensor.


        :param id: The id of this Sensor.
        :type id: int
        """

        self._id = id

    @property
    def status(self) -> str:
        """Gets the status of this Sensor.

        Sensot Status  # noqa: E501

        :return: The status of this Sensor.
        :rtype: str
        """
        return self._status

    @status.setter
    def status(self, status: str):
        """Sets the status of this Sensor.

        Sensot Status  # noqa: E501

        :param status: The status of this Sensor.
        :type status: str
        """
        allowed_values = ["active", "notActive"]  # noqa: E501
        if status not in allowed_values:
            raise ValueError(
                "Invalid value for `status` ({0}), must be one of {1}".format(
                    status, allowed_values
                )
            )

        self._status = status

    @property
    def linked_line(self) -> str:
        """Gets the linked_line of this Sensor.

        Linked line id, if present  # noqa: E501

        :return: The linked_line of this Sensor.
        :rtype: str
        """
        return self._linked_line

    @linked_line.setter
    def linked_line(self, linked_line: str):
        """Sets the linked_line of this Sensor.

        Linked line id, if present  # noqa: E501

        :param linked_line: The linked_line of this Sensor.
        :type linked_line: str
        """

        self._linked_line = linked_line

    @property
    def value(self) -> object:
        """Gets the value of this Sensor.

        Sensor value  # noqa: E501

        :return: The value of this Sensor.
        :rtype: object
        """
        return self._value

    @value.setter
    def value(self, value: object):
        """Sets the value of this Sensor.

        Sensor value  # noqa: E501

        :param value: The value of this Sensor.
        :type value: object
        """

        self._value = value
