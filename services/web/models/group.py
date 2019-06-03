# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
from web.models import Device
from web.resources import Db


class Group:
    @classmethod
    def _get_group_devices(cls, user_identity, group_id):
        group = ""
        if group_id is not None:
            group = " and group_id = '{group_id}'".format(group_id=group_id)

        q = """
            select
            d.*,
            jsonb_object_agg(setting, value) as settings
            from device_settings as s
            join devices as d on s.device_id = d.id
            where s.device_id in (
            select id from devices where id in (
                select device_id from device_groups where device_id in (
                        select device_id from device_user where user_id in (
                            select id from users where name = %(user_identity)s
                        )
                    ) {group}
                )
            )
            group by d.id
            """.format(
            group=group
        )

        records = Db.execute(q, {'user_identity': "admin"}, method='fetchall')
        if len(records) == 0:
            raise Exception("No devices in group_id={}".format(group_id))

        return records

    def __init__(self, user_identity, id, name, description, devices=[]):
        self.user_identity = user_identity
        self.id = id
        self.name = name
        self.description = description
        self.devices = []

    def init_devices(self):
        records = Group._get_group_devices(
            group_id=self.id, user_identity=self.user_identity
        )

        for rec in records:
            device = Device(user_identity=self.user_identity, **rec)
            self.devices.append(device)

        self.devices.sort(key=lambda e: e.name)

        return self

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "devices": self.devices,
        }

    serialize = to_json
