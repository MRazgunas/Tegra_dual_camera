using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Timers;
using uPLibrary.Networking.M2Mqtt;
using uPLibrary.Networking.M2Mqtt.Messages;
using SharpDX.DirectInput;
using System.Windows.Interop;
using Gimbal_GCS.Utilities;

namespace Gimbal_GCS
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    /// 
    public class Quaterion
    {
        public double x;
        public double y;
        public double z;
        public double w;


        public Quaterion()
        {
            x = 0.0;
            y = 0.0;
            z = 0.0;
            w = 1.0;
        }

        public Quaterion(double x, double y, double z, double w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }

        static public Quaterion FromEulerAngles(double x, double y, double z)
        {
            double phi = x * 0.5;
            double theta = y * 0.5;
            double psi = z * 0.5;

            double cphi = Math.Cos(phi);
            double sphi = Math.Sin(phi);
            double ctheta = Math.Cos(theta);
            double stheta = Math.Sin(theta);
            double cpsi = Math.Cos(psi);
            double spsi = Math.Sin(psi);

            double ww = cphi * ctheta * cpsi + sphi * stheta * spsi;
            double xx = sphi * ctheta * cpsi - cphi * stheta * spsi;
            double yy = cphi * stheta * cpsi + sphi * ctheta * spsi;
            double zz = cphi * ctheta * spsi - sphi * stheta * cpsi;
            //double cy = Math.Cos(z * 0.5);
            //double sy = Math.Sin(z * 0.5);
            //double cr = Math.Cos(y * 0.5);
            //double sr = Math.Sin(y * 0.5);
            //double cp = Math.Cos(x * 0.5);
            //double sp = Math.Sin(x * 0.5);

            //double ww = cy * cr * cp + sy * sr * sp;
            //double xx = cy * sr * cp - sy * cr * sp;
            //double yy = cy * cr * sp + sy * sr * cp;
            //double zz = sy * cr * cp - cy * sr * sp;
            return new Quaterion(xx, -yy, zz, ww);
        }
    }

    public partial class MainWindow : Window
    {
        private const int WM_DEVICECHANGE = 0x0219;

        MqttClient gimbal;
        private readonly System.Timers.Timer _timer;

        bool recording = false;

        SharpDX.DirectInput.Joystick joystick;
        DirectInput directInput = new DirectInput();
        Guid joystickGuid = Guid.Empty;

        bool joystic_enabled = false;

        private VideoDisplay videoWindow;

        private const int rgbPort = 5000;
        private const int irPort = 5001;

        private bool prevCamSwitchState = false;

        private GeoPOI geoPOIwindow;

        enum CameraSource {
            RGB_CAMERA_SOURCE,
            IR_CAMERA_SOURCE
        };

        public enum GimbalMode
        {
            MODE_RATE,
            MODE_GEOPOI,
            MODE_STOW,
        };

        private CameraSource currentCamera = CameraSource.RGB_CAMERA_SOURCE;
        private GimbalMode currentMode = GimbalMode.MODE_RATE;

        private PointLatLngAlt geoPOITarget = PointLatLngAlt.Zero;

        public MainWindow()
        {
            InitializeComponent();

            this.Closing += MainWindow_Closing;

            Find_Joystick();

            setCameraVideoSource(CameraSource.RGB_CAMERA_SOURCE);
            SetGimbalMode(GimbalMode.MODE_RATE);
            
            _timer = new System.Timers.Timer(100);
            _timer.Elapsed += new ElapsedEventHandler(Joystick_Poll);
            _timer.Enabled = true;
        }

        private void MainWindow_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            if(videoWindow != null)
                videoWindow.Close();
            if (geoPOIwindow != null)
                geoPOIwindow.Close();
        }

        protected override void OnSourceInitialized(EventArgs e)
        {
            base.OnSourceInitialized(e);
            HwndSource source = PresentationSource.FromVisual(this) as HwndSource;
            source.AddHook(WndProc);
        }

        private IntPtr WndProc(IntPtr hwnd, int msg, IntPtr wParam, IntPtr lParam, ref bool handled)
        {
            // Handle messages...
            switch(msg)
            {
                case WM_DEVICECHANGE:
                    Find_Joystick();
                    break;
            }

            return IntPtr.Zero;
        }

        void Find_Joystick()
        {

            if (joystickGuid != Guid.Empty) return;

            foreach (var deviceInstance in directInput.GetDevices(DeviceType.Gamepad, DeviceEnumerationFlags.AllDevices))
                joystickGuid = deviceInstance.InstanceGuid;

            // If Gamepad not found, look for a Joystick
            if (joystickGuid == Guid.Empty)
                foreach (var deviceInstance in directInput.GetDevices(DeviceType.Joystick, DeviceEnumerationFlags.AllDevices))
                    joystickGuid = deviceInstance.InstanceGuid;

            // If Joystick not found, throws an error
            if (joystickGuid == Guid.Empty)
            {
                Console.WriteLine("No joystick/Gamepad found.");
                joystickEnable.Dispatcher.Invoke(() => {
                    joystickEnable.IsChecked = false;
                    joystickEnable.IsEnabled = false;
                });
                
            }
            else
            {
                // Instantiate the joystick
                joystick = new SharpDX.DirectInput.Joystick(directInput, joystickGuid);

                Console.WriteLine("Found Joystick/Gamepad with GUID: {0}", joystickGuid);

                joystick.Properties.BufferSize = 128;
                // Acquire the joystick
                joystick.Acquire();
                joystickEnable.Dispatcher.Invoke(() => {
                    joystickEnable.IsEnabled = true;
                });

            }
        }

        void Joystick_Poll(object Sender, EventArgs e)
        {
            if (joystickGuid != Guid.Empty)
            {
                if (!directInput.IsDeviceAttached(joystickGuid))
                {
                    joystick.Dispose();
                    joystick = null;
                    joystickGuid = Guid.Empty;
                    joystickEnable.Dispatcher.Invoke(() =>
                    {
                        joystickEnable.IsChecked = false;
                        joystickEnable.IsEnabled = false;
                    });
                }
            }

            JoystickState state = null;

            if (joystick != null)
            {
                joystick.Poll();
                state = joystick.GetCurrentState();
            }
            if (state != null)
            {
                if (joystic_enabled)
                {
                    if (state.Buttons[6])
                    {
                        btnZoomIn_Click(null, null);
                    }
                    else if (state.Buttons[4])
                    {
                        btnZoomOut_Click(null, null);
                    }

                    if(state.Buttons[2] && !prevCamSwitchState)
                    {
                        prevCamSwitchState = true;
                        if (currentCamera == CameraSource.RGB_CAMERA_SOURCE)
                            setCameraVideoSource(CameraSource.IR_CAMERA_SOURCE);
                        else if (currentCamera == CameraSource.IR_CAMERA_SOURCE)
                            setCameraVideoSource(CameraSource.RGB_CAMERA_SOURCE);
                        
                    } else if(!state.Buttons[2])
                    {
                        prevCamSwitchState = false;
                    }

                    if (currentMode == GimbalMode.MODE_RATE)
                    {
                        double pitch_cmd = 0.0;
                        double yaw_cmd = 0.0;
                        if (Math.Abs(state.Y - 32768) > 30)
                        {
                            pitch_cmd = ((state.Y - 32768.0) / 65536.0 * -2.0) * 3.14 / 2;
                        }
                        else
                        {
                            pitch_cmd = 0.0;
                        }
                        if (Math.Abs(state.X - 32768) > 30)
                        {
                            yaw_cmd = ((state.X - 32768.0) / 65536.0 * -2.0) * 3.14 / 2;
                        }
                        else
                        {
                            yaw_cmd = 0.0;
                        }
                        sendGimbalCommand(pitch_cmd, 0.0, yaw_cmd);
                    }
                }
            }
        }

        private void ConnectMenu_Click(object sender, RoutedEventArgs e)
        {
            if (ConnectMenu.Header.ToString() == "Connect")
            {
                Connect_window conenctWindow = new Connect_window();
                conenctWindow.Show();
            } else
            {
                gimbal.Disconnect();
                ConnectMenu.Header = "Connect";
            }
        }

        public bool EstablishMQTTConnection(string ipAdd)
        {
            try
            {
                if (gimbal != null)
                {
                    gimbal.Disconnect();
                }
            } catch { }
            try
            {
                gimbal = new MqttClient(IPAddress.Parse(ipAdd));
                gimbal.ConnectionClosed += Gimbal_ConnectionClosed;
                byte status = gimbal.Connect(Guid.NewGuid().ToString());
                if (status > 0)
                    return false;
            } catch
            {
                return false;
            }
            ConnectMenu.Header = "Disconnect";
            return true;
        }

        private void Gimbal_ConnectionClosed(object sender, EventArgs e)
        {
            this.Dispatcher.Invoke(() =>
            {
                ConnectMenu.Header = "Connect";
            });
        }

        private void displayNotConnected()
        {
            MessageBox.Show("Not Connected");
        }

        private void btnZoomOut_Click(object sender, RoutedEventArgs e)
        {
            if (gimbal.IsConnected)
            {
                ushort msgId = gimbal.Publish("gimbal/cameras/rgb/zoom", // topic
                              Encoding.UTF8.GetBytes("-7"), //Zoom speed. Negative values means zoom out 
                              MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, // QoS level
                              false); // retained
            }
            else displayNotConnected();

        }

        private void btnZoomIn_Click(object sender, RoutedEventArgs e)
        {
            if (gimbal.IsConnected)
            {
                ushort msgId = gimbal.Publish("gimbal/cameras/rgb/zoom", // topic
                              Encoding.UTF8.GetBytes("7"), //Zoom speed. Negative values means zoom out 
                              MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, // QoS level
                              false); // retained
            }
            else displayNotConnected();
        }

        private void startVideoRecording(bool start)
        {
            if(gimbal.IsConnected)
            {
                byte[] message;
                if (start)
                    message = Encoding.UTF8.GetBytes("1");
                else
                    message = Encoding.UTF8.GetBytes("0");                
                ushort msgId = gimbal.Publish("gimbal/cameras/record", message,
                    MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, false);
            }
        }

        private void btnRecording_Click(object sender, RoutedEventArgs e)
        {
            startVideoRecording(!recording);
            recording = !recording;
        }

        private void sendGimbalCommand(double x, double y, double z)
        {
            if (gimbal != null)
            {
                if (gimbal.IsConnected)
                {
                    var q = Quaterion.FromEulerAngles(x, y, z);
                    float[] quat = { (float)q.x, (float)q.y, (float)q.z, (float)q.w };
                    var byteArray = new byte[quat.Length * 4 + 1];
                    Buffer.BlockCopy(quat, 0, byteArray, 0, quat.Length * 4);
                    byteArray[quat.Length * 4] = 0; //Cmd
                    gimbal.Publish("gimbal/control", byteArray, MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, false);
                }
            }
        }

        private void btnGimbalControl_Click(object sender, RoutedEventArgs e)
        {
            //byte[] x = BitConverter.GetBytes(1.0f);
            //byte[] y = BitConverter.GetBytes(2.0f);
            //byte[] z = BitConverter.GetBytes(3.0f);
            //byte[] w = BitConverter.GetBytes(4.0f);
            //byte[] mode = BitConverter.GetBytes((char)0);
            //byte[] message = new byte[x.Length + y.Length + z.Length + w.Length + mode.Length];
            //System.Buffer.BlockCopy(x, 0, message, 0, x.Length);
            //System.Buffer.BlockCopy(y, 0, message, x.Length, y.Length);
            //System.Buffer.BlockCopy(z, 0, message, x.Length + y.Length, z.Length);
            //System.Buffer.BlockCopy(w, 0, message, x.Length + y.Length + z.Length, w.Length);
            //System.Buffer.BlockCopy(mode, 0, message, x.Length + y.Length + z.Length + w.Length, mode.Length);
            if (gimbal.IsConnected)
            {

                var quter = Quaterion.FromEulerAngles(3.14, 0.0, 0.0);
                float[] quat = { (float)quter.x, (float)quter.y, (float)quter.z, (float)quter.w};
                var byteArray = new byte[quat.Length * 4 + 1];
                Buffer.BlockCopy(quat, 0, byteArray, 0, quat.Length * 4);
                byteArray[quat.Length * 4] = 0; //Cmd
                gimbal.Publish("gimbal/control", byteArray, MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, false);
            }

        }

        private void joystickEnable_Checked(object sender, RoutedEventArgs e)
        {
            joystic_enabled = (bool)joystickEnable.IsChecked;
        }

        private void VideoWindow_Click(object sender, RoutedEventArgs e)
        {
            //Open video window
            if(videoWindow == null)
            {
                if (currentCamera == CameraSource.RGB_CAMERA_SOURCE)
                    videoWindow = new VideoDisplay(rgbPort);
                else if (currentCamera == CameraSource.IR_CAMERA_SOURCE)
                    videoWindow = new VideoDisplay(irPort);
;               videoWindow.FormClosing += VideoWindow_FormClosing;
                videoWindow.Show();
            } 
        }

        private void VideoWindow_FormClosing(object sender, System.Windows.Forms.FormClosingEventArgs e)
        {
            if(videoWindow != null)
            {
                videoWindow = null;
            }
        }

        private void setCameraVideoSource(CameraSource cam)
        {
            switch(cam)
            {
                case CameraSource.RGB_CAMERA_SOURCE:
                    currentCamera = cam;
                    irVideoSelectButton.Dispatcher.Invoke(() => {
                        irVideoSelectButton.Background = Brushes.LightGray;
                        rgbVideoSelectButton.Background = Brushes.Green;
                    });
                    if (videoWindow == null) break;
                    videoWindow.setPortNumber(rgbPort);
                    break;
                case CameraSource.IR_CAMERA_SOURCE:
                    currentCamera = cam;
                    irVideoSelectButton.Dispatcher.Invoke(() => {
                        irVideoSelectButton.Background = Brushes.Green;
                        rgbVideoSelectButton.Background = Brushes.LightGray;
                    });
                    if (videoWindow == null) break;
                    videoWindow.setPortNumber(irPort);
                    break;
            }
        }

        private void irVideoSelectButton_Click(object sender, RoutedEventArgs e)
        {
            setCameraVideoSource(CameraSource.IR_CAMERA_SOURCE);

        }

        private void rgbVideoSelectButton_Click(object sender, RoutedEventArgs e)
        {
            setCameraVideoSource(CameraSource.RGB_CAMERA_SOURCE);
        }

        private void MenuItem_Click(object sender, RoutedEventArgs e)
        {
            if (geoPOIwindow == null)
            {
                geoPOIwindow = new GeoPOI(this);
                geoPOIwindow.Show();
            }
        }

        public void SetGimbalMode(GimbalMode mode)
        {
            currentMode = mode;
            switch (mode)
            {
                case GimbalMode.MODE_RATE:
                    btnRateMode.Dispatcher.Invoke(() =>
                    {
                        btnRateMode.Background = Brushes.Green;
                        btnGEOPOIMode.Background = Brushes.LightGray;
                        btnStowMode.Background = Brushes.LightGray;
                    });
                    break;
                case GimbalMode.MODE_GEOPOI:
                    btnRateMode.Dispatcher.Invoke(() =>
                    {
                        btnRateMode.Background = Brushes.LightGray;
                        btnGEOPOIMode.Background = Brushes.Green;
                        btnStowMode.Background = Brushes.LightGray;
                    });
                    break;
                case GimbalMode.MODE_STOW:
                    btnRateMode.Dispatcher.Invoke(() =>
                    {
                        btnRateMode.Background = Brushes.LightGray;
                        btnGEOPOIMode.Background = Brushes.LightGray;
                        btnStowMode.Background = Brushes.Green;
                    });
                    break;
            }
        }

        private void btnRateMode_Click(object sender, RoutedEventArgs e)
        {
            SetGimbalMode(GimbalMode.MODE_RATE);
        }

        private void btnGEOPOIMode_Click(object sender, RoutedEventArgs e)
        {
            SetGimbalMode(GimbalMode.MODE_GEOPOI);
        }

        private void btnStowMode_Click(object sender, RoutedEventArgs e)
        {
            SetGimbalMode(GimbalMode.MODE_STOW);
        }

        public void SetGEOPOITarget(PointLatLngAlt target)
        {
            if(target != PointLatLngAlt.Zero)
            {
                SetGimbalMode(GimbalMode.MODE_GEOPOI);
                geoPOITarget = target;
                SendCurrentGEOPOICommand();
            }            
        }

        private void SendCurrentGEOPOICommand()
        {
            if (gimbal != null)
            {
                if (gimbal.IsConnected)
                {
                    float[] latlngalt = { (float)geoPOITarget.Lat, (float)geoPOITarget.Lng, (float)geoPOITarget.Alt};
                    var byteArray = new byte[latlngalt.Length * 4];
                    Buffer.BlockCopy(latlngalt, 0, byteArray, 0, latlngalt.Length * 4);
                    gimbal.Publish("gimbal/geotarget", byteArray, MqttMsgBase.QOS_LEVEL_EXACTLY_ONCE, false);
                }
            }
        }
    }
}
