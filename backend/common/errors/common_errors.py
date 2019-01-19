from common.errors import GeneralError
from common.errors import COMMON_ERROR

from werkzeug.exceptions import HTTPException
from flask_jwt_extended.exceptions import JWTExtendedException

from flask import jsonify
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def error_obj(message, code, payload=None):
    tmp = {}
    tmp['message'] = message
    tmp['code'] = code
    
    if payload is not None: 
        tmp['payload'] = payload

    return jsonify(tmp), tmp['code']


def handle_error(error):
    def_code = 500
    def_message = 'Unexpected error'
    if isinstance(error, GeneralError):
        return error_obj(
            message=error.message,
            code=error.code,
            payload=error.payload
        )

    if isinstance(error, HTTPException):
        return error_obj(
            message=error.description,
            code=error.code
        )

    if isinstance(error, JWTExtendedException):
        return error_obj(
            message=error.msg,
            code=error.code
        )

    return error_obj(
            message=def_message,
            code=def_code
        )


def handle_common_errors(app):
    for clazz in COMMON_ERROR:
        app.register_error_handler(clazz, handle_error)

    return app
