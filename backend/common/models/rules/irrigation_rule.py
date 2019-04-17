from .base_rule import BaseRule

class IrrigationRule(BaseRule):
	"""docstring for IrrigationRule"""
	def __init__(self, line_id, time, iterations, time_sleep):
		self.rule_type = 'irrigation'
		super().__init__(self.rule_type, line_id, time, iterations, time_sleep)
	
	@property
	def tank_fill_time(self):
		return self.duration * 2
