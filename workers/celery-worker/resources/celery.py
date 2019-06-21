from celery import Celery
import os

CeleryApp = Celery(
    os.environ["CONSOLE_ID"],
    backend=os.environ["REDIS_BROKER"],
    broker=os.environ["REDIS_BROKER"],
    # include=[
    #     "app.models.celery_tasks.get_device_status",
    # ],
)
