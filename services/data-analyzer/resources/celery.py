from celery import Celery
import os

CeleryApp = Celery('data-analyzer',
                    backend=os.environ['CELERY_BACKEND'],
                    broker=os.environ['CELERY_BROKER'],
                    include=['models.celery_tasks.get_device_status',
                             'models.celery_tasks.set_device_status',
                            ])
