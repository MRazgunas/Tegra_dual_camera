#/usr/bin/env python3

import sys

import gi
gi.require_version('Gst', '1.0')
from gi.repository import GObject, Gst
from datetime import datetime

import time
import threading

class VideoManager:
    def bus_call(self, bus, message, loop):
        t = message.type
        if t == Gst.MessageType.EOS:
            sys.stout.write("End-of-stream\n")
            loop.quit()
        elif t == Gst.MessageType.ERROR:
            err, debug = message.parse_error()
            sys.stderr.write("Error: %s: %s\n" % (err, debug))
            loop.quit()
        return True
        
    def run(self):
        #loop = GObject.MainLoop()
        
        #bus = self.pipeline.get_bus()
        #bus.add_signal_watch()
        #bus.connect ("message", self.bus_call, loop)
        
        # start play back and listed to events
        self.pipeline.set_state(Gst.State.PLAYING)
        
        # try:
            # loop.run()
        # except:
            # pass          
        # cleanup
        # self.pipeline.set_state(Gst.State.NULL)

    def start_recoding(self):
        if(not self.recording):
            filename = datetime.now().strftime("%Y-%m-%d_%H_%M_%S") + self.camname + ".mp4"
            self.recodpipeline = Gst.parse_bin_from_description("queue name=filesave"+self.camname+" ! nvvidconv ! omxh264enc bitrate=3000000 name=flsavenc"+self.camname+" ! qtmux ! filesink location="+filename, True)
            self.pipeline.add(self.recodpipeline)
            self.pipeline.get_by_name("tee"+self.camname).link(self.recodpipeline)
            self.recodpipeline.set_state(Gst.State.PLAYING)
            print("Recodring started "+filename)
            self.recording = True
        
    def stop_recording(self):
        if(self.recording):
            filesave = self.recodpipeline.get_by_name("filesave"+self.camname)
            filesave.get_static_pad("src").add_probe(Gst.PadProbeType.BLOCK_DOWNSTREAM, self.probe_block)
            #self.recodpipeline = None
            #self.recodpipeline.send_event(Gst.Event.new_eos())
            time.sleep(2)
            self.recodpipeline.set_state(Gst.State.NULL)
            print("Recording stopped")
        
    def stop_pipeline(self):
        self.pipeline.set_state(Gst.State.NULL)
        
    def probe_block(self, pad, buf):
        self.pipeline.get_by_name("tee"+self.camname).unlink(self.recodpipeline)
        flsavenc = self.recodpipeline.get_by_name("flsavenc"+self.camname)
        flsavenc.get_static_pad("sink").send_event(Gst.Event.new_eos())
        self.recording = False
        print("Blocking")
        return True

    def __init__(self, devicename, width, height, framerate, ip, port, camname, bitrate, down_scale, d_width, d_height):
        #Gst.debug_set_active(True)
        #Gst.debug_set_default_threshold(3)
        GObject.threads_init()
        Gst.init(None)
        self.recording = False
        self.ip = ip
        self.port = port
        self.camname = camname

        if(down_scale == False):
            self.pipeline = Gst.parse_launch("v4l2src device="+devicename + " ! video/x-raw, format=(string)UYVY, width=(int)"+str(width)+", height=(int)"+str(height)+", framerate=(fraction)"+str(framerate)+"/1 ! tee name = tee"+self.camname+" ! queue name=vidstream ! nvvidconv ! omxh264enc bitrate="+str(bitrate)+" ! video/x-h264, stream-format=(string)byte-stream ! h264parse ! rtph264pay mtu=1400 ! udpsink host="+self.ip+" port="+str(self.port)+" sync=false async=false")
        else:
            self.pipeline = Gst.parse_launch("v4l2src device="+devicename + " ! video/x-raw, format=(string)UYVY, width=(int)"+str(width)+", height=(int)"+str(height)+", framerate=(fraction)"+str(framerate)+"/1 ! tee name = tee"+self.camname+" ! queue name=vidstream ! nvvidconv ! video/x-raw(memory:NVMM), width=(int)"+str(d_width)+", height=(int)"+str(d_height)+", format=(string)I420 ! omxh264enc bitrate="+str(bitrate)+" ! video/x-h264, stream-format=(string)byte-stream ! h264parse ! rtph264pay mtu=1400 ! udpsink host="+self.ip+" port="+str(self.port)+" sync=false async=false")
        
        
if __name__ == '__main__':
    videomanager = VideoManager("/dev/video0")
    videomanager.run()
    time.sleep(5)
    videomanager.start_recoding()
    time.sleep(5)
    videomanager.start_recoding()
    time.sleep(5)
    videomanager.stop_recording()
    time.sleep(5)
