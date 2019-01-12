import logging

import psycopg2

from common.user import User

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Database:
    conn = None
    cursor = None

    def __init__(self):
        conn_string = "host='smartsystem.ccuhc4d7z4xu.us-east-2.rds.amazonaws.com' dbname='dev' user='sergii' password='bNVy4eRJuVqH7GFv'"
        self.conn = psycopg2.connect(conn_string)
        self.cursor = self.conn.cursor()

    def get_user(self, user_identity):
        self.cursor.execute(
            "Select name, password from users where email = %s or name = %s",
            (user_identity, user_identity),
        )
        records = self.cursor.fetchone()
        if records is not None:
            return User(username=records[0], roles=["admin"], permissions=["rw"])

        return None


Db = Database()
