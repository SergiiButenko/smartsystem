import json
import logging
import os
from datetime import datetime
from resources.dal import DAL

from resources.celery import CeleryApp
from models.celery_tasks import set_device_status

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def loop():
    get_jobs = """ SELECT line_task_id,
                     line_id,
                     device_id,
                     desired_device_state,
                     exec_time
                     FROM jobs_queue
                     WHERE state = 'pending'
                     AND exec_time >= now() - INTERVAL '1 HOUR'
                     AND exec_time <= now()
                     ORDER BY exec_time DESC"""

    queue = DAL.execute(query=get_jobs, method='fetchall')
    for message in queue:
        logger.info("set_device_status.delay(message['device_id'], message['line_id'], message['desired_device_state'])")

    DAL.execute(query='LISTEN "{}";'.format(os.environ["CONSOLE_ID"]))
    logger.info(
        'Waiting for notifications on channel "{}";'.format(os.environ["CONSOLE_ID"])
    )

    while True:
        DAL.conn.poll()
        while DAL.conn.notifies:
            notify = DAL.conn.notifies.pop(0)
            logger.info(
                "Got NOTIFY:{} {} {}".format(notify.pid, notify.channel, notify.payload)
            )

            payload = json.loads(notify.payload)
            operation = payload['operation']
            record = payload['record']
            record['exec_time'] = record['exec_time']

            logger.info("record {}".format(record))

            if operation == 'INSERT': #and record['exec_time'] <= datetime.now(timezone.utc):
                logger.info("""set_device_status.delay(message['device_id'],
                                        message['line_id'],
                                        message['desired_device_state']
                                        )"""
                            )

            queue = DAL.execute(query=get_jobs, method='fetchall')
            # for message in queue:
            #     logger.info(
            #         "set_device_status.delay(message['device_id'], message['line_id'], message['desired_device_state'])"
            #     )


if __name__ == "__main__":
    loop()
