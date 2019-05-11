# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
import requests
import logging
import re

from web.models.line import Line
from web.resources import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Device:
    def __init__(self, user_identity, id, name, description, type, device_type, model, version, settings, concole=None, lines=None):
        self.user_identity = user_identity
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.device_type = device_type
        self.model = model
        self.version = version
        self.settings = settings
        self.concole = concole
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

        # get from redis
        # request change
        if self.settings["comm_protocol"] == "network":
            try:
                lines_state = requests.get(url=self.settings["ip"] + '99')
                lines_state.raise_for_status()

                lines_state = re.findall('\d+', lines_state.text)
                logger.info(lines_state)

                lines_state = list(map(int, lines_state))
                logger.info(lines_state)

            except Exception as e:
                logger.error("device is offline")
                logger.error(e)
                self.state = "offline"
            else:
                self.state = "online"

                for line in self.lines:
                    logger.info(lines_state)
                    line.state = lines_state[line.relay_num]

        # merge matrics
        return self

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "type": self.type,
            "device_type": self.device_type,
            "model": self.model,
            "version": self.version,
            "settings": self.settings,
            "lines": self.lines,
            "state": self.state,
        }

    serialize = to_json
