import sys
import serial
import struct
import base64
import time

if __name__ == '__main__':
    ser = serial.Serial(port='/dev/ttyTHS1',
                    baudrate=38400)
    ser.isOpen()
    try:
        while(True):
            #command = "gmbcontrol ".encode('utf-8')
            #payload = base64.encodebytes(struct.pack('=ffffB', 1.0, 2.0, 3.0, 4.0, 5))
            #print(struct.Struct('=ffffB').size)
            #ending = "\r\n".encode('utf-8')
            #send_data = command + payload + ending
            command = "gmbcontrol " + str(1.0) + " " + str(2.0) + " " + str(3.0) + " " + str(4.0) + " " + str(0) + "\r\n"
            ser.write(command.encode('utf-8'))
            print(command)
            time.sleep(1)
    except KeyboardInterrupt:
        sys.exit()
   
