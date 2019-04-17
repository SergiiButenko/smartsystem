from .base_rule import BaseRule
from datedim import datetime as dt

class IrrigationRule(BaseRule):
	"""docstring for IrrigationRule"""
	def __init__(self, line_id, start_time=dt.now(), iterations, time_sleep):
		self.rule_type = 'irrigation'
		super().__init__(self.rule_type, line_id, time, iterations, time_sleep)
	
	@property
	def tank_fill_time(self):
		return self.duration * 2

	@property
	def next_rule_start_time(self):
		return self.start_time + dt.delta(minutes=self.tank_fill_time)


