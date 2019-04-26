# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
from common.models import Device
from common.resources import Db


class Group:
    def __init__(self, user_identity, id, name, description, devices=[]):
        self.user_identity = user_identity
        self.id = id
        self.name = name
        self.description = description
        self.devices = []

    def init_devices(self):
        records = Db.get_group_devices(
            group_id=self.id, user_identity=self.user_identity
        )

        devices = list()
        for rec in records:
            devices.append(Device(user_identity=self.user_identity, **rec))

        devices.sort(key=lambda e: e.name)

        self.devices = devices

        return self

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "devices": self.devices,
        }

    serialize = to_json
