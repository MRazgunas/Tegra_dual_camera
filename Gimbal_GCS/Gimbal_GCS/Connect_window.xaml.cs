using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Net;

namespace Gimbal_GCS
{
    /// <summary>
    /// Interaction logic for Connect_window.xaml
    /// </summary>
    public partial class Connect_window : Window
    {
        public Connect_window()
        {
            InitializeComponent();
        }

        private void btnConnect_Click(object sender, RoutedEventArgs e)
        {
            String ipString = ipAdressTextBox.Text.ToString();
            IPAddress adress;
            if(!IPAddress.TryParse(ipString, out adress))
            {
                MessageBox.Show("Invalid IP adress");
                return;
            }
            if(((MainWindow)Application.Current.MainWindow).EstablishMQTTConnection(ipString))
            {
                this.Close();
            } else
            {
                MessageBox.Show("Connection failed");
            }
        }
    }
}
