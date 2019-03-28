import logging

import psycopg2
import psycopg2.extras

from common.models.user import User

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Database:
    conn = None
    cursor = None

    def __init__(self):
        conn_string = "host='postgres' port='5432' dbname='irrigation' user='postgres' password='changeme'"
        self.conn = psycopg2.connect(conn_string)
        self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def get_user(self, user_identity):
        self.cursor.execute(
            "select name, password from users where email = %s or name = %s",
            (user_identity, user_identity),
        )
        records = self.cursor.fetchone()
        if records is not None:
            return User(username=records['name'], password=records['password'], roles=["admin"], permissions=["rw"])

        return None


Db = Database()
