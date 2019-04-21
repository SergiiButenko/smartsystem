# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.


class Group:
    def __init__(self, id, name, description, devices=[]):
        self.id = id
        self.name = name
        self.description = description
        self.devices = devices

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "devices": self.devices,
        }

    serialize = to_json
