# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.


class Device:

    def __init__(self, device_id, name, description, settings, lines=[]):
        self.device_id = device_id
        self.name = name
        self.description = description
        self.settings = settings
        self.lines = lines

    def to_json(self):
        return {
            "id": self.device_id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "lines": self.lines,
        }

    serialize = to_json
