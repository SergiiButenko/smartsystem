class GeneralError(Exception):
    def_code = 400
    def_message = 'Invalid request'

    def __init__(self, message=def_message, code=def_code, payload=None):
        Exception.__init__(self)
        self.message = message
        self.code = code
        self.payload = payload

    def to_dict(self):
        rv = dict(self.payload or ())
        rv['message'] = self.message
        return rv
    