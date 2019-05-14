# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
import requests
import logging
import re

from web.models.line import Line
from web.models import Task
from web.resources import Db

from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Device:
    def __init__(
        self,
        user_identity,
        id,
        name,
        description,
        type,
        device_type,
        model,
        version,
        settings,
        concole=None,
        lines=None,
    ):
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
        self.state = self._init_state()
        self.lines = self._init_lines()
        self.tasks = dict()

    def register_line_tasks(self, lines):
        tasks = dict()
        exec_time = datetime.now()
        for line in lines:
            task = Task(exec_time=exec_time, device_id=self.id, **line)
            task.register
            tasks[line.id] = task
            exec_time = task.next_rule_start_time

        self.tasks = tasks

        return self

    def get_next_tasks(self):
        return Db.get_device_lines_next_tasks(device_id=self.id)

    def remove_tasks(self, rules):
        return Db.get_device_lines_next_tasks(device_id=self.id, rules=rules)

    def _init_lines(self):
        records = Db.get_device_lines(device_id=self.id, line_id=None)

        for rec in records:
            self.lines.append(Line(**rec))

        self.lines.sort(key=lambda e: e.name)

        return self

    def _init_state(self):
        if self.lines is None:
            self.lines = self._init_lines()

        # get from redis
        # request change
        if self.settings["comm_protocol"] == "network":
            try:
                # lines_state = requests.get(url=self.settings["ip"] + "99")
                # lines_state.raise_for_status()

                # lines_state = re.findall("\d+", lines_state.text)
                # logger.info(lines_state)

                # lines_state = list(map(int, lines_state))
                # logger.info(lines_state)
                lines_state = [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1]
                self.state = "online"

                for line in self.lines:
                    logger.info(lines_state)
                    line.state = lines_state[line.relay_num]
            except Exception as e:
                logger.error("device is offline")
                logger.error(e)
                self.state = "offline"

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
