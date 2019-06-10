# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
import logging

from web.models.line import Line
from web.models.task import Task
from web.resources import Db

from datetime import datetime

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Device:
    @classmethod
    def _get_device_lines(cls, device_id, line_id, user_identity):
        line = ""
        if line_id is not None:
            line = " and line_id = '{line_id}'".format(line_id=line_id)

        q = """
            select
            l.*,
            jsonb_object_agg(setting, value) as settings
            from line_settings as s
            join lines as l on s.line_id = l.id
            where l.id in (
                select line_id from line_device where device_id = %(device_id)s
            ) {line}
            group by l.id
        """.format(line=line)

        return Db.execute(query=q, params={'device_id': device_id}, method='fetchall')

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

        self.lines = self._init_lines()
        self.state = self._init_state()

    def _init_lines(self):
        records = Device._get_device_lines(device_id=self.id, line_id=None, user_identity=self.user_identity)

        lines = list()
        for rec in records:
            lines.append(Line(**rec))

        lines.sort(key=lambda e: e.name)

        return lines

    def _init_state(self):
        if self.lines is None:
            self.lines = self._init_lines()

        # get from redis
        # request change
        state = "offline"
        if self.settings["comm_protocol"] == "network":
            try:
                # lines_state = requests.get(url=self.settings["ip"] + "99")
                # lines_state.raise_for_status()

                # lines_state = re.findall("\d+", lines_state.text)
                # logger.info(lines_state)

                # lines_state = list(map(int, lines_state))
                # logger.info(lines_state)
                lines_state = [1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1]
                state = "online"

                for line in self.lines:
                    line.state = lines_state[line.relay_num]
            except Exception as e:
                logger.error("device is offline")
                logger.error(e)
                state = "offline"

        return state

    def register_lines_tasks(self, lines):
        exec_time = datetime.now()
        for line_to_plan in lines:
            line = self.lines[line_to_plan['line_id']]

            task = Task(exec_time=exec_time,
                        device_id=self.id,
                        time=line_to_plan['time'],
                        iterations=line_to_plan['iterations'],
                        time_sleep=line_to_plan['time_sleep'],
                        relay_num=line.relay_num,
                        )
            line.register_task(task)

            exec_time = task.next_rule_start_time

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
