from web.models import Group
from web.resources import Db

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Groups:
    @classmethod
    def _get_groups(cls, user_identity, group_id):
        group = ""
        if group_id is not None:
            group = " and group_id = '{group_id}'".format(group_id=group_id)

        q = """
           select g.* from groups as g where id in (
                select group_id from device_groups where device_id in (
                    select device_id from device_user where user_id in (
                                    select id from users where name = %(user_identity)s
                                )
                ) {group}
            )
            """.format(group=group)

        records = Db.execute(q, params={'user_identity': "admin"}, method="fetchall")
        if len(records) == 0:
            raise Exception("No group_id {} found".format(group_id))

        return records

    @staticmethod
    def get_by_id(group_id, user_identity):
        group = Groups._get_groups(group_id=group_id, user_identity=user_identity)[0]
        group = Group(user_identity=user_identity, **group)
        group.init_devices()

        return group

    @staticmethod
    def get_all(user_identity):
        records = Groups._get_groups(group_id=None, user_identity=user_identity)

        groups = list()
        for rec in records:
            logger.info(rec)
            groups.append(Group(user_identity=user_identity, **rec))

        groups.sort(key=lambda e: e.name)

        return groups
