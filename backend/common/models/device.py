# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.


class Device:

    def __init__(self, id, name, description, settings, lines=[]):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.lines = lines

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "lines": self.lines,
        }

    serialize = to_json
