from common.models import Device
from common.resources import Db


class Devices:
    @staticmethod
    def get_by_id(device_id, user_identity):
        device = Db.get_device_by_id(
            device_id=device_id, line_id=None, user_identity=user_identity
        )
        device = Device(user_identity=user_identity, **device)
        device.init_lines()

        return device

    @staticmethod
    def get_all(user_identity):
        records = Db.get_all_devices(
            device_id=None, line_id=None, user_identity=user_identity
        )

        devices = list()
        for rec in records:
            devices.append(Device(user_identity=user_identity, **rec))

        devices.sort(key=lambda e: e.name)

        return devices
