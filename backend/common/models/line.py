# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.


class Line:
    def __init__(self, line_id, name, description, settings):
        self.line_id = line_id
        self.name = name
        self.description = description
        self.settings = settings

    def to_json(self):
        return {
            "line_id": self.line_id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
        }

    serialize = to_json
