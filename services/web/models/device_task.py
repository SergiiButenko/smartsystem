from datetime import datetime

from web.models.line_task import LineTask
from web.models.device import Device
from web.resources import Db

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class DeviceTask:
    def __init__(
        self,
        device_id,
        lines,
    ):
        self.device_id = device_id
        self.id = -1
        self.line_tasks = list()

        exec_time = datetime.now()
        device = Device.get_by_id(device_id=self.device_id)
        for line_to_plan in lines:
            line = device.lines[line_to_plan['line_id']]
            task = LineTask(exec_time=exec_time,
                            device_id=self.device_id,
                            device_task_id=self.id,
                            time=line_to_plan['time'],
                            iterations=line_to_plan['iterations'],
                            time_sleep=line_to_plan['time_sleep'],
                            relay_num=line.relay_num,
                            line_id=line_to_plan['line_id'],
                            )

            exec_time = task.next_rule_start_time
            self.line_tasks.append(task)

    def register(self):
        q = """
               INSERT INTO device_tasks(device_id)
               VALUES (%(device_id)s)
               RETURNING id
               """
        self.id = Db.execute(query=q, params={'device_id': self.device_id}, method='fetchone')[0]

        for line_task in self.line_tasks:
            line_task.device_task_id = self.id
            line_task.register()

        return self

    def to_json(self):
        return dict(
            id=self.id,
            device_id=self.device_id,
            line_tasks=self.line_tasks,
        )

    serialize = to_json
