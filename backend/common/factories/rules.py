from common.resources import Db

from datetime import datetime
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Rules:
    @staticmethod
    def get_by_device_id(device_id):
        pass

    @staticmethod
    def get_by_sensor_id(sensor_id):
        pass