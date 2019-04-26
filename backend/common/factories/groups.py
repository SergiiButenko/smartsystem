from common.resources import Db
from common.models import Group


class Groups:
    @staticmethod
    def get_by_id(group_id, user_identity):
        group = Db.get_group_by_id(group_id=group_id, user_identity=user_identity)
        group = Group(user_identity=user_identity, **group)
        group.init_devices()

        return group

    @staticmethod
    def get_all(user_identity):
        records = Db.get_all_groups(group_id=None, user_identity=user_identity)

        groups = list()
        for rec in records:
            groups.append(Group(user_identity=user_identity, **rec))

        groups.sort(key=lambda e: e.name)

        return groups
