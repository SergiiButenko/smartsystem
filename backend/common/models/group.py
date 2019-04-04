# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.


class Group:
    def __init__(self, group_id, name, description):
        self.group_id = group_id
        self.name = name
        self.description = description

    def to_json(self):
        return {
            "id": self.group_id,
            "name": self.name,
            "description": self.description,
        }

    serialize = to_json
