from builtins import property, range
from datetime import datetime, timedelta
from uuid import uuid4

from web.models.job import Job
from web.resources import Db

import logging
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Task:
    """Compose set of tasks according to iterations and time_sleep"""
    def __init__(
        self,
        exec_time,
        device_id,
        line_id,
        time,
        iterations,
        time_sleep,
        relay_num=-1,
        id=-1,
    ):
        self.id = id  # will be set after register into database
        self.line_id = line_id
        self.device_id = device_id
        self.exec_time = exec_time
        self.time = time
        self.iterations = iterations
        self.time_sleep = time_sleep
        self.relay_num = relay_num

        self.jobs = self._generate_jobs()

    @property
    def duration(self):
        return self.iterations * self.time + (self.iterations - 1) * self.time_sleep

    @property
    def time_ends(self):
        return self.exec_time + timedelta(minutes=self.duration)

    @property
    def next_rule_start_time(self):
        return self.time_ends + timedelta(minutes=self.duration * 2)

    def _generate_jobs(self):
        exec_time = self.exec_time
        jobs = []
        for i in range(self.iterations):
            jobs.append(
                Job(
                    task_id=self.id,
                    line_id=self.line_id,
                    device_id=self.device_id,
                    desired_device_state=json.dumps(
                        {'state': {
                                  'relay': {'num': self.relay_num, 'state': 1}
                                  }
                        }),
                    exec_time=exec_time,
                )
            )
            jobs.append(
                Job(
                    task_id=self.id,
                    line_id=self.line_id,
                    device_id=self.device_id,
                    desired_device_state=json.dumps(
                        {'state': {
                                  'relay': {'num': self.relay_num, 'state': 0}
                                  }
                        }),
                    exec_time=exec_time + timedelta(minutes=self.time),
                )
            )
            exec_time = exec_time + timedelta(minutes=self.time_sleep)

        return jobs

    def _register_task(self):
        q = """
        INSERT INTO tasks(line_id, device_id, exec_time, time, iterations, time_sleep)
        VALUES (%(line_id)s, %(device_id)s, %(exec_time)s, %(time)s, %(iterations)s, %(time_sleep)s)
        RETURNING id
        """
        self.id = Db.execute(query=q, params={'line_id': self.line_id,
                                               'device_id': self.device_id,
                                               'exec_time': self.exec_time,
                                               'time': self.time,
                                               'iterations': self.iterations,
                                               'time_sleep': self.time_sleep,
                                               }, method='fetchone')[0]

        return self

    def register(self):
        self._register_task()

        for job in self.jobs:
            job.task_id = self.id
            job.register()

        return self

    def to_json(self):
        return dict(
            line_id=self.line_id,
            device_id=self.device_id,
            exec_time=self.exec_time,
            time=self.time,
            iterations=self.iterations,
            time_sleep=self.time_sleep,
            jobs=self.jobs,
            id=self.id,
        )

    serialize = to_json
