# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
import requests
from common.resources.db import Db


class Device:

    def __init__(self, user, id, name, description, settings, lines=None):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.user = user
        self.lines = []
        self.state = None

        if settings['type'] == 'actuator':
            self.lines = self._init_lines()

    def _init_lines(self, line_id=None):
        Db.get_device_lines(device_id=self.id, line_id=line_id, user_identity=self.user)

    def init_state(self):
        if self.lines is None:
            self.lines = self._init_lines()

        if self.settings['radio_type'] == 'ip':
            lines_state = requests.get(url=self.settings['base_url'])

        # merge matrics
        self.state = lines_state

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
