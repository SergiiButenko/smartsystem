import psycopg2
import psycopg2.extensions
import psycopg2.extras
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def main():
    conn_string = "host='postgres' port='5432' dbname='irrigation' user='postgres' password='changeme'"
    conn = psycopg2.connect(conn_string)
    conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)

    curs = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    curs.execute("LISTEN rules;")

    logger.info("Waiting for notifications on channel 'rules'")
    while True:
        conn.poll()
        while conn.notifies:
            notify = conn.notifies.pop(0)
            logger.info("Got NOTIFY:{} {} {}".format(notify.pid, notify.channel, notify.payload))
            curs.execute("SELECT * FROM rules_line order by exec_time desc limit 1")
            records = curs.fetchone()
            logger.info(records)


if __name__ == "__main__":
    main()
