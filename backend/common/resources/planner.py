import logging

import psycopg2
import psycopg2.extras

from common.models import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Planner():
	"""docstring for Planner"""
	def __init__(self):
		pass
		