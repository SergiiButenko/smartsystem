from flask import jsonify


class GlobalErrorHandler(object):
	"""docstring for GlobalErrorHandler"""
	def __init__(self, msg, errCode):
		super(GlobalErrorHandler, self).__init__()
		self.msg = msg
		self.errCode = errCode
	
	def form(self):
		return jsonify(message=self.msg), self.errCode
