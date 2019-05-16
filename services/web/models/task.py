from builtins import property, range
from datetime import datetime, timedelta
from uuid import uuid4

from web.models.job import Job
from web.resources import Db

import logging

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
        id=str(uuid4()),
    ):
        self.id = id
        self.line_id = line_id
        self.device_id = device_id
        self.exec_time = exec_time
        self.time = time
        self.iterations = iterations
        self.time_sleep = time_sleep

        self.jobs = self._generate_jobs()

    def _generate_jobs(self):
        exec_time = self.exec_time
        jobs = []
        for i in range(self.iterations):
            jobs.append(
                Job(
                    task_id=self.id,
                    line_id=self.line_id,
                    device_id=self.device_id,
                    action="activate",
                    exec_time=exec_time,
                )
            )
            jobs.append(
                Job(
                    task_id=self.id,
                    line_id=self.line_id,
                    device_id=self.device_id,
                    action="deactivate",
                    exec_time=exec_time + timedelta(minutes=self.time),
                )
            )
            exec_time = exec_time + timedelta(minutes=self.time_sleep)

        return jobs

    @property
    def duration(self):
        return self.iterations * self.time + (self.iterations - 1) * self.time_sleep

    @property
    def time_ends(self):
        return self.exec_time + timedelta(minutes=self.duration)

    @property
    def next_rule_start_time(self):
        return self.time_ends + timedelta(minutes=self.duration * 2)

    def register(self):
        for job in self.jobs:
            job.id = Db.register_job(job)

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
