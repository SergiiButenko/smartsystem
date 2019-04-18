import logging
from common.resources.db import Db
from common.resources.rules_factory.rules_factory import RulesFactory

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Planner():
	"""docstring for Planner"""
	def __init__(self):
		pass

	def add_rules(self, device_id, lines, user_identity):
		# check input
		# form transaction with marker removal
		# return ids
		rules = RulesFactory.create_rules(device_id=device_id, lines=lines, user_identity=user_identity)
		return rules

	def get_next_rules(self, device_id, user_identity):
		# check input
		# get all lines and first pair of enable and disable rules
		pass

RulesPlanner = Planner()