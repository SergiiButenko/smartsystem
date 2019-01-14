from .user_not_found import UserNotFound
from .wrong_creds import WrongCreds
from .general_error import GeneralError
from .unexpected_role import UnexpectedRole

from werkzeug.exceptions import HTTPException
from flask_jwt_extended.exceptions import JWTExtendedException

COMMON_ERROR = [
    HTTPException,
    JWTExtendedException,
    UserNotFound,
    WrongCreds,
    GeneralError,
    UnexpectedRole,
]