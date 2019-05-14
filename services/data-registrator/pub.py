import paho.mqtt.client as mqtt

broker_address = "localhost"
broker_portno = 1883
client = mqtt.Client()

# the callback function
def on_connect(client, userdata, flags, rc):
    print.info("Connected With Result Code {}".format(rc))


client.connect(broker_address, broker_portno)
client.on_connect = on_connect
client.publish(topic="TestingTopic", payload="This is a test Message")
