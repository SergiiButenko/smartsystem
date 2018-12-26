from flask import jsonify


def globalErrorHandler(msg, err_code):
	return jsonify(message=msg), err_code
