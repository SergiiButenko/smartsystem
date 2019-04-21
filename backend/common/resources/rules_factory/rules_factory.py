import logging
from datetime import datetime

from common.resources.db import Db
from common.config.mapper import DeviceToRuleType
from common.resources.rules_factory.periodic_rule import PeriodicRule

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class RuleFactory():
    """docstring for Planner"""

    def __init__(self):
        pass

    def create_rules(self, device_type, device_id, lines):
        Rule = self._rule_cls(device_type=device_type)

        rules = []
        exec_time = datetime.now()
        for line in lines:
            rule = Rule()
            rule.init_from_json(exec_time=exec_time, device_id=device_id, **line)
            exec_time = rule.next_rule_start_time
            rules.append(rule)

        return rules

    @staticmethod
    def _rule_cls(device_type):
        if device_type == DeviceToRuleType.PERIODIC:
            return PeriodicRule

        raise ValueError("Rule type for device doesn't exists")


RulesFactory = RuleFactory()
