from builtins import property, range
from datetime import datetime, timedelta
from uuid import uuid4

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class PeriodicRule():
	"""Compose set of tasks according to iterations and time_sleep"""

	def __init__(self, uuid=str(uuid4())):
		self.line_id = None
		self.exec_time = -1
		self.time = -1
		self.iterations = -1
		self.time_sleep = -1
		self.tasks = []
		self.rule_id = uuid

	def init_from_json(self, exec_time, line_id, time, iterations, time_sleep):
		self.line_id = line_id
		self.exec_time = exec_time
		self.time = time
		self.iterations = iterations
		self.time_sleep = time_sleep

		self._generate_tasks()

		return self.tasks

	def init_from_db(self, rule_id):
		self.rule_id = rule_id
		# get from db by rule

	def _generate_tasks(self):
		exec_time = self.exec_time
		for i in range(self.iterations):
			self.tasks.append(dict(type='on', id=self.rule_id, exec_time=exec_time))
			self.tasks.append(dict(type='off', id=self.rule_id, exec_time=exec_time + timedelta(minutes=self.time)))
			exec_time = exec_time + timedelta(minutes=self.time_sleep)

	@property
	def duration(self):
		return self.iterations * self.time + (self.iterations - 1) * self.time_sleep

	@property
	def time_ends(self):
		return self.exec_time + timedelta(minutes=self.duration)

	@property
	def next_rule_start_time(self):
		return self.time_ends + timedelta(minutes=self.duration * 2)

	def __repr__(self):
		return str(self.tasks)

	def to_json(self):
		return {
			"id": self.rule_id,
		}

	serialize = to_json
