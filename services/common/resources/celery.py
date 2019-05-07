from celery import Celery
import os

CeleryApp = Celery('console',
                 backend=os.environ['CELERY_BACKEND'],
                 broker=os.environ['CELERY_BROKER'],
                 include=['common.celery_tasks.tasks'])
