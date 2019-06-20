import psycopg2
import psycopg2.extensions
import psycopg2.extras
import logging
import os

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    conn = psycopg2.connect(
        host=os.environ["DB_HOST"],
        port=os.environ["DB_PORT"],
        dbname=os.environ["DB_DATABASE"],
        user=os.environ["DB_USERNAME"],
        password=os.environ["DB_PASSWORD"],
    )
    conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)

    curs = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    curs.execute('LISTEN "{}";'.format(os.environ["CONSOLE_ID"]))

    logger.info(
        'Waiting for notifications on channel "{}";'.format(os.environ["CONSOLE_ID"])
    )
    while True:
        conn.poll()
        while conn.notifies:
            notify = conn.notifies.pop(0)
            logger.info(
                "Got NOTIFY:{} {} {}".format(notify.pid, notify.channel, notify.payload)
            )
            curs.execute("SELECT line_task_id,"
                         "line_id,"
                         "device_id,"
                         "desired_device_state,"
                         "exec_time"
                         "FROM jobs_queue"
                         "WHERE state = 'pending'"
                         "AND exec_time >= now() - INTERVAL '1 HOUR'"
                         "ORDER BY exec_time desc limit 1")
            records = curs.fetchone()
            logger.info(records)


if __name__ == "__main__":
    main()
