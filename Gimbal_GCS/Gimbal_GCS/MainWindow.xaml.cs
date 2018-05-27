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

namespace Gimbal_GCS
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        MqttClient gimbal;
        DirectInput directInput;
        Joystick joystick;
        private readonly System.Timers.Timer _timer;

        bool recording = false;

        public MainWindow()
        {
            InitializeComponent();
            directInput = new DirectInput();

            var joystickGuid = Guid.Empty;
            foreach (var deviceInstance in directInput.GetDevices(DeviceType.Gamepad, DeviceEnumerationFlags.AllDevices))
                joystickGuid = deviceInstance.InstanceGuid;

            if (joystickGuid == Guid.Empty)
                foreach (var deviceInstance in directInput.GetDevices(DeviceType.Joystick, DeviceEnumerationFlags.AllDevices))
                    joystickGuid = deviceInstance.InstanceGuid;
            if(joystickGuid == Guid.Empty)
            {
                //No joystick found
                return;
            }

            joystick = new Joystick(directInput, joystickGuid);
            JoystickState stato = new JoystickState();

            joystick.Properties.AxisMode = DeviceAxisMode.Absolute;
            joystick.Acquire();

            _timer = new System.Timers.Timer(100);
            _timer.Elapsed += new ElapsedEventHandler(UpdateJoystic);
            _timer.Enabled = true;

        }

        private void UpdateJoystic(object source, ElapsedEventArgs e)
        {
            var state = new JoystickState();
            joystick.GetCurrentState(ref state);
            if(state.Buttons[6])
            {
                btnZoomIn_Click(null, null);
            } else if(state.Buttons[4])
            {
                btnZoomOut_Click(null, null);
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
    }
}
