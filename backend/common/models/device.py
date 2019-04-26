# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
import requests
import logging

from common.models.line import Line
from common.resources import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Device:
    def __init__(self, user_identity, id, name, description, settings, lines=None):
        self.user_identity = user_identity
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.state = None
        self.lines = []

    def init_lines(self):
        records = Db.get_device_lines(
            device_id=self.id, line_id=None
        )

        for rec in records:
            self.lines.append(Line(**rec))

        self.lines.sort(key=lambda e: e.name)

        return self

    def init_state(self):
        if self.lines is None:
            self.lines = self._init_lines()

        if self.settings["radio_type"] == "ip":
            lines_state = requests.get(url=self.settings["base_url"])
            self.state = "online"

        # merge matrics
        return self.state

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "lines": self.lines,
            "state": self.state,
        }

    serialize = to_json
