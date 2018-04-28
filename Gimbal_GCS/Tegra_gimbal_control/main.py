import paho.mqtt.client as mqtt
import time
import serial

last_message = 0.0

ser = serial.Serial(port='/dev/ttyTHS1',
                    baudrate=38400)

ser.isOpen()

def on_connect(client, userdata, flags, rc):
    print("Conencted with result code"+str(rc))
    client.subscribe("gimbal/#")

def on_message(client, userdata, msg):
    if(msg.topic == 'gimbal/cameras/rgb/zoom'):
        value = int(msg.payload.decode("utf-8"));
        global last_message
        last_message = time.time()
        if(value == 7):
            ser.write("sony 8101040727FF\r\n".encode('utf-8'))
        elif(value == -7):
            ser.write("sony 8101040737FF\r\n".encode('utf-8'))

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("192.168.8.108")


while(True):
    client.loop(0.1)
#    ser.
    if(last_message != 0.0 and last_message+0.3 < time.time()):
        ser.write("sony 8101040700FF\r\n".encode('utf-8'))
        last_message = 0.0