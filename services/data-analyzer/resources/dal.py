import logging
import os

import psycopg2
import psycopg2.extras

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Database:
    def __init__(self):
        self.conn = psycopg2.connect(host=os.environ['DB_HOST'],
                                     port=os.environ['DB_PORT'],
                                     dbname=os.environ['DB_DATABASE'],
                                     user=os.environ['DB_USERNAME'],
                                     password=os.environ['DB_PASSWORD'])

        self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def __del__(self):
        self.conn.close()

    def data_register(self, device_id, data):
        pass


DAL = Database()
