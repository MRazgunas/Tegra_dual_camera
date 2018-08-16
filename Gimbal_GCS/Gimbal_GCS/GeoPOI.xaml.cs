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
using GMap.NET;
using Gimbal_GCS.Utilities;
using ICSharpCode.SharpZipLib;

namespace Gimbal_GCS
{
    /// <summary>
    /// Interaction logic for GeoPOI.xaml
    /// </summary>
    public partial class GeoPOI : Window
    {
        MainWindow main;

        GMap.NET.WindowsPresentation.GMapMarker targetMarker;

        public GeoPOI(MainWindow mainwind)
        {
            InitializeComponent();
            VFS.SetCurrent(new Utilities.ITestFileSystem());
            main = mainwind;
        }

        private void mapView_Loaded(object sender, RoutedEventArgs e)
        {
            GMap.NET.GMaps.Instance.Mode = GMap.NET.AccessMode.ServerAndCache;
            // choose your provider here
            mapView.MapProvider = GMap.NET.MapProviders.GoogleHybridMapProvider.Instance;//GMap.NET.MapProviders.OpenStreetMapProvider.Instance;
            mapView.MinZoom = 2;
            mapView.MaxZoom = 20;
            // whole world zoom
            mapView.Zoom = 2;
            // lets the map use the mousewheel to zoom
            mapView.MouseWheelZoomType = GMap.NET.MouseWheelZoomType.MousePositionAndCenter;
            // lets the user drag the map
            mapView.CanDragMap = true;
            // lets the user drag the map with the left mouse button
            mapView.DragButton = MouseButton.Left;
        }

        internal PointLatLng mouseDownLocation;

        private void mapView_MouseDown(object sender, MouseButtonEventArgs e)
        {
            mouseDownLocation = mapView.FromLocalToLatLng((int)e.GetPosition(this).X, (int)e.GetPosition(this).Y);
        }

        private void updateTargetMarker(PointLatLngAlt target)
        {
            if(targetMarker == null)
            {
                targetMarker = new GMap.NET.WindowsPresentation.GMapMarker(target);
                targetMarker.Shape = new Ellipse
                {
                    Width = 10,
                    Height = 10,
                    Stroke = Brushes.Red,
                    StrokeThickness = 5
                };
                mapView.Markers.Add(targetMarker);

            } else
            {
                targetMarker.Position = target;
            }
            
        }

        private void PointHere_Click(object sender, RoutedEventArgs e)
        {
            PointLatLng targetPoint = mouseDownLocation;
            //Provided by ArduPilot server
            //TODO: maybe use data stored in gimbal or host own server
            var alt = srtm.getAltitude(targetPoint.Lat, targetPoint.Lng);

            PointLatLngAlt target = new PointLatLngAlt(targetPoint.Lat, targetPoint.Lng, alt.alt);
            main.SetGEOPOITarget(target);
            updateTargetMarker(targetPoint);
        }
    }
}
