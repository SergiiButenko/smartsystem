import paho.mqtt.client as mqtt
import os

import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


# the callback function
def on_connect(client, userdata, flags, rc):
    logger.info("Connected With Result Code {}".format(rc))
    client.subscribe("TestingTopic")


def on_disconnect(client, userdata, rc):
    logger.info("Disconnected From Broker")


def on_message(client, userdata, message):
    logger.info(message.payload.decode())
    logger.info(message.topic)


def main():
    broker_address = os.environ["MOSQUITTO_HOST"]
    broker_portno = int(os.environ["MOSQUITTO_PORT"])

    client = mqtt.Client()
    client.on_connect = on_connect
    client.on_disconnect = on_disconnect
    client.on_message = on_message

    client.connect(broker_address, broker_portno)
    client.loop_forever()


if __name__ == "__main__":
    main()
