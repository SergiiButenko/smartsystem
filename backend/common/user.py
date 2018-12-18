# This is an example of a complex object that we could build
# a JWT from. In practice, this will likely be something
# like a SQLAlchemy instance.
class User:
    def __init__(self, username, roles, permissions):
        self.username = username
        self.roles = roles
        self.permissions = permissions
