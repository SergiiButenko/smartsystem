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


    def get_actuator_lines(self, user_identity, device_id=None):
        device = ''
        if device_id is not None:
            device = " and d.device_id = '{device_id}'".format(device_id=device_id)
        
        q = """
            select d.id, d.name, d.description,
            jsonb_agg(l.*) as lines from lines as l
            inner join line_device as ld on l.id = ld.line_id
            inner join devices as d on ld.device_id = d.id
            where l.id in (
                select ld.line_id from line_device as ld
                where ld.device_id in (
                    select device_id from device_user as d
                        where d.user_id in (
                            select id from users where name = 'admin'
                        ) and d.device_id in (
                            select device_id from device_settings where setting='type' and value = 'actuator'
                        ) {device}
                )
            )
            group by d.id
        """.format(device=device)
            
        self.cursor.execute(
            q, (user_identity),
        )
       
        records = self.cursor.fetchall()
        lines = dict()
        for rec in records:
            lines[rec['id']] = dict(
                id=rec['id'],
                name=rec['name'],
                description=rec['description'],
                lines=rec['lines'],
            )
        
        return lines

Db = Database()

