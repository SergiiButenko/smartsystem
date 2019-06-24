from celery import Celery
import os
import time
import json

CeleryApp = Celery(
    os.environ["CONSOLE_ID"],
    backend=os.environ["REDIS_BROKER"],
    broker=os.environ["REDIS_BROKER"],
    include=[
        "set_device_status",
        "get_device_status",
    ],
)


@CeleryApp.task
def get_device_status(device_id):
    print("get_device_status task begins")
    # sleep 5 seconds
    time.sleep(5)
    print("long time task finished")
    return json.dumps({"test": device_id})


@CeleryApp.task
def set_device_status(device_id):
    print("set_device_status task begins")
    # sleep 5 seconds
    time.sleep(5)
    print("long time task finished")
    return json.dumps({"test": device_id})
