from web.models import Task
from web.resources import Db

from datetime import datetime
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Tasks:
    @staticmethod
    def register_tasks(device, lines):
        tasks = dict()
        exec_time = datetime.now()
        for line in lines:
            task = Task(exec_time=exec_time, device_id=device.id, **line)
            task.register
            tasks[line.id] = task
            exec_time = task.next_rule_start_time

        return tasks

    @staticmethod
    def get_next_tasks(device):
        return Db.get_device_lines_next_tasks(device_id=device.id)

    @staticmethod
    def remove_tasks(rules):
        return Db.get_device_lines_next_tasks(rules)
