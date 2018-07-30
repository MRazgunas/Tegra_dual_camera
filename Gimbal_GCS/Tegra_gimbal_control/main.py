import paho.mqtt.client as mqtt
import time
import serial

from video_manager import VideoManager
import sys

import struct

videomanager = VideoManager("/dev/video0", 1920, 1080, 30, "192.168.10.236", 5000, "RGB", 2000000, True, 1280, 720)
videomanager.run()

videomanager_lwir = VideoManager("/dev/video1", 640, 480, 25, "192.168.10.236", 5001, "LWIR", 1000000, False, 640, 480)
videomanager_lwir.run()


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
    elif(msg.topic == 'gimbal/cameras/record'):
        value = int(msg.payload.decode("utf-8"));
        if(value == 1):
            videomanager.start_recoding()
            videomanager_lwir.start_recoding()
        elif(value == 0):
            videomanager.stop_recording()
            videomanager_lwir.stop_recording()
    elif(msg.topic == 'gimbal/control'):
        data = struct.unpack('@ffffB', msg.payload)
        #command = "gmbcontrol " + str(data[0]) + " " + str(data[1]) + " " + str(data[2]) + " " + str(data[3]) + " " + str(0) + "\r\n"
        command = "gmbcontrol {:.3f} {:.3f} {:.3f} {:.3f} 0\r\n".format(data[0], data[1], data[2], data[3])
        #print(command)
        ser.write(command.encode('utf-8'))

        

client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

client.connect("localhost")

try:
    while(True):
        client.loop(0.1)
    #    ser.
        if(last_message != 0.0 and last_message+0.3 < time.time()):
            ser.write("sony 8101040700FF\r\n".encode('utf-8'))
            last_message = 0.0
except KeyboardInterrupt:
    print("Stopping program")
    videomanager.stop_recording()
    videomanager.stop_pipeline()
    videomanager_lwir.stop_recording()
    videomanager_lwir.stop_pipeline()
    sys.exit()
