class Line:
    def __init__(self, id, name, description, relay_num, settings):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.relay_num = relay_num

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "relay_num": self.relay_num,
        }

    serialize = to_json
