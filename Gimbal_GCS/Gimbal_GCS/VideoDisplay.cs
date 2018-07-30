using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Gst;

namespace Gimbal_GCS
{
    public partial class VideoDisplay: Form
    {

        //Gst. m_GLibMainLoop;
        System.Threading.Thread mMainGLibThread;
        GLib.MainLoop mMainLoop;
        int port;
        private bool portChangeFinished = true;

        Pipeline mPipeline;
        Element mSink, mSource;
        private System.IntPtr mHandle;


        public VideoDisplay(int portNumber)
        {
            InitializeComponent();

            this.FormClosing += VideoDisplay_FormClosing;

            port = portNumber;
            InitializeGst();
        }

        private void InitializeGst()
        {
            mHandle = videoPanel.Handle;

            //Environment.SetEnvironmentVariable("GST_DEBUG", "5");

            // Initialize Gstreamer
            Gst.Application.Init();
            GtkSharp.GstreamerSharp.ObjectManager.Initialize();

            mMainLoop = new GLib.MainLoop();
            mMainGLibThread = new System.Threading.Thread(mMainLoop.Run);
            mMainGLibThread.Start();

            // Build the pipeline
            // mSource = ElementFactory.Make("videotestsrc", "source");
            // mSink = ElementFactory.Make("autovideosink", "sink");

            mPipeline = (Pipeline)Parse.Launch("udpsrc port=" + port.ToString() + " name=vidsrc ! capsfilter name=capsfilt ! rtph264depay ! h264parse ! queue ! openh264dec ! autovideosink sync = false async = false");
            //mPipeline = (Pipeline)Parse.Launch("videotestsrc name=test ! autovideosink");
            // Create the empty pipeline
            //mPipeline = new Pipeline("test-pipeline");
            //Element src = mPipeline.GetByName("test");
            //if(src != null)
            //{
            //    src["pattern"] = 4;
            //}
            if (mPipeline == null) //|| mSource == null || mSink == null)
            {
                Console.WriteLine("Not all elements could be created");
                return;
            }
            Element capsfilt = mPipeline.GetByName("capsfilt");
            if(capsfilt != null)
            {
                var caps = Gst.Caps.FromString("application/x-rtp, encoding-name=H264, payload=96");
                capsfilt["caps"] = caps; 
            }

            // Build the pipeline
            //mPipeline.Add(mSource, mSink);
            //if (!mSource.Link(mSink))
           // {
             //   Console.WriteLine("Elements could not be linked");
              //  return;
            //}

            // Modify the source's properties
            //mSource["pattern"] = 0;

            // Wait until error or EOS
            var bus = mPipeline.Bus;
            bus.AddSignalWatch();
            bus.Message += HandleMessage;

            bus.EnableSyncMessageEmission();
            bus.SyncMessage += new SyncMessageHandler(bus_SyncMessage);

            mPipeline.SetState(State.Null);
            mPipeline.SetState(State.Ready);
            mPipeline.SetState(State.Playing);

        }

        public void setPortNumber(int portNumber)
        {
            if (port != portNumber && portChangeFinished)
            {
                port = portNumber;
                if (mPipeline != null)
                {
                    portChangeFinished = false;
                    mPipeline.SendEvent(Event.NewEos());
                }
            }
        }

        private void HandleMessage(object o, MessageArgs args)
        {
            var msg = args.Message;
            switch(msg.Type)
            {
                case MessageType.StateChanged:
                    {
                        State newState, oldState, pending;
                        msg.ParseStateChanged(out newState, out oldState, out pending);
                        if (newState == State.Playing)
                        {
                            portChangeFinished = true;
                        }
                        break;
                    }
                case MessageType.Error:
                    mPipeline.SetState(State.Ready);
                    mMainLoop.Quit();
                    break;
                case MessageType.Eos:
                    mPipeline.SetState(State.Ready);
                    Element udpsrc = mPipeline.GetByName("vidsrc");
                    Element sink = mPipeline.GetByName("capsfilt");
                    udpsrc.SetState(State.Null);
                    mPipeline.Remove(udpsrc);
                    Element newUdpsrc = ElementFactory.Make("udpsrc", "vidsrc");
                    newUdpsrc["port"] = port;
                    mPipeline.Add(newUdpsrc);
                    newUdpsrc.Link(sink);
                    mPipeline.SetState(State.Playing);
                    break;
            }
        }

        private void VideoDisplay_FormClosing(object sender, FormClosingEventArgs e)
        {
            if (mPipeline != null)
            {
                mPipeline.SetState(State.Null);
                mMainLoop.Quit();
                mMainGLibThread.Abort();
            }
        }

        private void bus_SyncMessage(object o, SyncMessageArgs args)
        {
            if(Gst.Video.Global.IsVideoOverlayPrepareWindowHandleMessage(args.Message))
            {
                Element src = (Gst.Element)args.Message.Src;

                if(src != null && (src is Gst.Video.VideoSink | src is Gst.Bin))
                {
                    // Try to set Aspect Ratio
                    try
                    {
                        src["force-aspect-ratio"] = true;
                    }
                    catch (PropertyNotFoundException) { }

                    // Try to set Overlay
                    try
                    {
                        Gst.Video.VideoOverlayAdapter overlay = new Gst.Video.VideoOverlayAdapter(src.Handle);
                        overlay.WindowHandle = mHandle;
                        overlay.HandleEvents(true);
                    }
                    catch(Exception ex) { }
                }
            }
        }
    }
}
