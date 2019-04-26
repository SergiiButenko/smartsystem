class Line:
    def __init__(self, id, name, description, settings):
        self.id = id
        self.name = name
        self.description = description
        self.settings = settings

    def to_json(self):
        return {
            "id": self.id,
            "name": self.name,
            "description": self.description,
            "settings": self.settings,
        }

    serialize = to_json
