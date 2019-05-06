class Line:
    def __init__(self, id, name, description, relay_num, settings, state=-1):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings
        self.relay_num = relay_num
        self.state = state

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
            "relay_num": self.relay_num,
            "state": self.state,
        }

    serialize = to_json
