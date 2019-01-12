# coding: utf-8

from __future__ import absolute_import

from flask import json
from six import BytesIO

from swagger_server.models.line import Line  # noqa: E501
from swagger_server.test import BaseTestCase


class TestDefaultController(BaseTestCase):
    """DefaultController integration test stubs"""

    def test_lines_line_id_command_post(self):
        """Test case for lines_line_id_command_post

        Enable line of line by ID.
        """
        response = self.client.open(
            "/v1/lines/{lineId}/{command}".format(
                lineId="lineId_example", command="command_example"
            ),
            method="POST",
            content_type="application/json",
        )
        self.assert200(response, "Response body is : " + response.data.decode("utf-8"))

    def test_lines_line_id_get(self):
        """Test case for lines_line_id_get

        Returns summary of line by ID.
        """
        response = self.client.open(
            "/v1/lines/{lineId}".format(lineId="lineId_example"),
            method="GET",
            content_type="application/json",
        )
        self.assert200(response, "Response body is : " + response.data.decode("utf-8"))

    def test_lines_line_id_put(self):
        """Test case for lines_line_id_put

        Change settings for line by id.
        """
        response = self.client.open(
            "/v1/lines/{lineId}".format(lineId="lineId_example"),
            method="PUT",
            content_type="application/json",
        )
        self.assert200(response, "Response body is : " + response.data.decode("utf-8"))


if __name__ == "__main__":
    import unittest

    unittest.main()
