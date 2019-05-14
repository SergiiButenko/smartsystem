import logging
import os

import psycopg2
import psycopg2.extras

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Database:
    conn_creds = dict(host=os.environ['DB_HOST'],
                      port=os.environ['DB_PORT'],
                      dbname=os.environ['DB_DATABASE'],
                      user=os.environ['DB_USERNAME'],
                      password=os.environ['DB_PASSWORD'])

    def __init__(self):
        self.conn = psycopg2.connect(**Database.conn_creds)
        self.conn.autocommit = False

        self.cursor = self.conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

    def __del__(self):
        self.conn.close()

    def _execute(self, query, params={}, method='fetchall'):
        try:
            self.cursor.execute(
                query,
                params,
            )
            records = getattr(self.cursor, method)()

            self.conn.commit()

            return records
        except (Exception, psycopg2.DatabaseError) as error:
            logger.error("Error in transction Reverting all other operations of a transction ", error)
            self.conn.rollback()
            raise error

    def get_user(self, user_identity):
        self.cursor.execute(
            "select name, password from users where email = %s or name = %s",
            (user_identity, user_identity),
        )
        records = self.cursor.fetchone()
        if len(records) == 0:
            raise Exception("No user_id={}".format(user_identity))

        return records

    def _get_devices(self, user_identity, device_id):
        device = ""
        if device_id is not None:
            device = " and device_id = '{device_id}'".format(device_id=device_id)

        q = """
            select
            d.*,
            jsonb_object_agg(setting, value) as settings
            from device_settings as s
            join devices as d on s.device_id = d.id
            where s.device_id in (
            select id from devices where id in (
                select device_id from device_user where user_id in (
                    select id from users where name = '{user_identity}'
                    )
                ) {device}
            )
            group by d.id
            """.format(
            device=device, user_identity="admin"
        )

        self.cursor.execute(q, (user_identity))

        records = self.cursor.fetchall()
        if len(records) == 0:
            raise Exception("No device found")

        return records

    def get_device_lines(self, device_id, line_id):
        line = ""
        if line_id is not None:
            line = " and line_id = '{line_id}'".format(line_id=line_id)

        q = """
            select
            l.*,
            jsonb_object_agg(setting, value) as settings
            from line_settings as s
            join lines as l on s.line_id = l.id
            where l.id in (
                select line_id from line_device where device_id = '{device_id}'
            ) {line}
            group by l.id
        """.format(
            device_id=device_id, line=line
        )

        self.cursor.execute(q, (device_id))

        return self.cursor.fetchall()

    def get_device_by_id(self, device_id, user_identity):
        return self._get_devices(device_id=device_id, user_identity=user_identity)[0]

    def get_all_devices(self, user_identity):
        return self._get_devices(device_id=None, user_identity=user_identity)

    def _get_groups(self, user_identity, group_id):
        group = ""
        if group_id is not None:
            group = " and group_id = '{group_id}'".format(group_id=group_id)

        q = """
           select g.* from groups as g where id in (
                select group_id from device_groups where device_id in (
                    select device_id from device_user where user_id in (
                                    select id from users where name = '{user_identity}'
                                )
                ) {group}
            )
            """.format(
            group=group, user_identity="admin"
        )

        self._execute(q, (user_identity))

        records = self.cursor.fetchall()
        if len(records) == 0:
            raise Exception("No group_id {} found".format(group_id))

        return records

    def get_group_devices(self, user_identity, group_id):
        group = ""
        if group_id is not None:
            group = " and group_id = '{group_id}'".format(group_id=group_id)

        q = """
            select
            d.*,
            jsonb_object_agg(setting, value) as settings
            from device_settings as s
            join devices as d on s.device_id = d.id
            where s.device_id in (
            select id from devices where id in (
                select device_id from device_groups where device_id in (
                        select device_id from device_user where user_id in (
                            select id from users where name = %(user_identity)s
                        )
                    ) {group}
                )
            )
            group by d.id
            """.format(
            group=group
        )

        records = self._execute(q, {user_identity: "admin"}, method='fetchall')
        if len(records) == 0:
            raise Exception("No devices in group_id={}".format(group_id))

        return records

    def get_group_by_id(self, group_id, user_identity):
        return self._get_groups(group_id=group_id, user_identity=user_identity)[0]

    def get_all_groups(self, user_identity):
        return self._get_groups(group_id=None, user_identity=user_identity)

    def register_job(self, job):
        """
        Add tasks into database.

        :param job: job class
        :return: void
        """
        query = """
            INSERT INTO jobs_queue
            (task_id, line_id, device_id, action, exec_time)
            VALUES (%(task_id)s, %(line_id)s, %(device_id)s, %(action)s, %(exec_time)s)
            RETURNING id
            """
        self.cursor.execute(query, job.to_json())
        self.conn.commit()
        return self.cursor.fetchone()

    def remove_rule_tasks(self, rules):
        """
        Add tasks into database.

        :param rules: array of rules
        :return: void
        """
        for rule in rules:
            for task in rule.tasks:
                query = """
                REMOVE FROM rules_line
                WHERE rule_id = %(rule_id)s
                """
                self.cursor.execute(query, task.to_json())
            self.conn.commit()

    def get_device_lines_next_tasks(self, device_id):
        """
        Return first rule to execute
        :param device_id:
        :return: array of further tasks
        """

        query = """
        SELECT * from rules_line
        WHERE exec_time > now()
        AND device_id = %(device_id)s
        ORDER BY exec_time ASC
        LIMIT 1
        """
        self.cursor.execute(query, {"device_id": device_id})
        records = self.cursor.fetchall()

        tasks = list()
        for rec in records:
            tasks.append(rec)

        tasks.sort(key=lambda e: e["exec_time"])
        return tasks


Db = Database()
