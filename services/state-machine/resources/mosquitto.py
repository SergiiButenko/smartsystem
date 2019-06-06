import paho.mqtt.client as mqtt
import os

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class Mosquitto:
    def __init__(self):
        broker_address = os.environ["MOSQUITTO_HOST"]
        broker_portno = os.environ["MOSQUITTO_PORT"]

        self.client = mqtt.Client()

        self.client.on_connect = self._on_connect
        self.client.on_disconnect = self._on_disconnect
        self.client.on_message = self._on_message

        self.client.connect(broker_address, broker_portno)

        self.client.loop_forever()

    def _on_connect(self, userdata, flags, rc):
        logger.info("Connected With Result Code {}".format(rc))
        self.client.subscribe("TestingTopic")

    def _on_disconnect(self, userdata, rc):
        logger.info("Disconnected From Broker")

    def _on_message(self, userdata, message):
        logger.info(message.payload.decode())
        logger.info(message.topic)
