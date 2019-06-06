from web.models.device import Device
from web.resources import Db


class Devices:
    @classmethod
    def _get_devices(cls, user_identity, device_id):
        device = ""
        if device_id is not None:
            device = " and device_id = '{device_id}'".format(device_id=device_id)

        q = """
            select
            d.*,
            jsonb_object_agg(setting, value) as settings
            from device_settings as s
            join devices as d on s.device_id = d.id
            where s.device_id in (
            select id from devices where id in (
                select device_id from device_user where user_id in (
                    select id from users where name = %(user_identity)s
                    )
                ) {device}
            )
            group by d.id
            """.format(device=device)

        records = Db.execute(q, {'user_identity': 'admin'}, method='fetchall')
        if len(records) == 0:
            raise Exception("No device '{}' found".format(device_id))

        return records

    @staticmethod
    def get_by_id(device_id, user_identity):
        device = Devices._get_devices(device_id=device_id, user_identity=user_identity)[0]
        device = Device(user_identity=user_identity, **device)

        return device

    @staticmethod
    def get_all(user_identity):
        records = Devices._get_devices(device_id=None, user_identity=user_identity)

        devices = list()
        for rec in records:
            devices.append(Device(user_identity=user_identity, **rec))

        devices.sort(key=lambda e: e.name)

        return devices
