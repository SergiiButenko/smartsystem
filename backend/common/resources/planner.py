import logging
from common.resources.db import Db
from common.factories.rules import Rules

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Planner:
    """docstring for Planner"""

    def __init__(self):
        pass

    @staticmethod
    def add_rules(device, lines):
        device_type = device.settings["type"]
        device_id = device.id

        rules = Rules.create_rules(
            device_id=device_id, device_type=device_type, lines=lines
        )
        Db.register_rule_tasks(rules)

        return rules

    @staticmethod
    def get_next_rules(device):
        device_id = device.id

        return Db.get_device_lines_next_tasks(device_id=device_id)

    @staticmethod
    def remove_rules(rules):
        return Db.get_device_lines_next_tasks(rules)


RulesPlanner = Planner()
