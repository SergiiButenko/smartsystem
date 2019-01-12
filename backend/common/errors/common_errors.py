from common.errors import * 
from werkzeug.exceptions import HTTPException
from flask import jsonify
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

common_errors = [UserNotFound, WrongCreds, GeneralError, UnexpectedRole]

def error_obj(message, code, payload=None):
    tmp = {}
    tmp['message'] = message
    tmp['code'] = code
    
    if payload is not None: 
        tmp['payload'] = payload

    return jsonify(tmp)

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
        return error_factory(
            message=error.description,
            code=error.code
        )

    return error_factory(
            message=def_message,
            code=def_code
        )


def handle_common_errors(app):
    for clazz in common_errors:
        logger.info(clazz)
        app.register_error_handler(clazz, handle_error)

    return app
