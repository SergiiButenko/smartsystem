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
        conn_string = "host='localhost' port='5432' dbname='irrigation' user='postgres' password='changeme'"
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

    def get_devices(self, user_identity, device_id=None):
        device = ""

        if device_id is not None:
            device = " and device_id = '{device_id}'".format(device_id=device_id)

        q = """
            select 
            d.id, d.name, d.description, 
            jsonb_object_agg(setting, value) as settings
            from device_settings as s
            join devices as d on s.device_id = d.id             
            where s.device_id in (
            select id from devices where id in (
                select device_id from device_user where user_id in (
                    select id from users where name = 'admin'
                    )
                ) {device}
            )
            group by d.id
            """.format(device=device)

        self.cursor.execute(
            q, (user_identity),
        )

        records = self.cursor.fetchall()
        devices = dict()
        for rec in records:
            devices[rec['id']] = dict(
                id=rec['id'],
                name=rec['name'],
                description=rec['description'],
                settings=rec['settings'],
            )
        
        return devices


    def get_actuator_lines(self, device_id):
        q = """
            select 
            l.id, l.description, 
            jsonb_object_agg(setting, value) as settings
            from line_settings as s
            join lines as l on s.line_id = l.id
            where l.id in (
                select line_id from line_device where device_id = '{device_id}'
            )
            group by l.id
        """.format(device_id=device_id)
            
        self.cursor.execute(
            q, (device_id),
        )
        
        records = self.cursor.fetchall()
        logger.info(records)
        lines = list()
        for rec in records:
            lines.append(dict(
                id=rec['id'],
                name=rec['description'],
                description=rec['description'],
                settings=rec['settings'],
            ))
        lines.sort(key=lambda e: e['name'], reverse=True)
        return lines

Db = Database()

