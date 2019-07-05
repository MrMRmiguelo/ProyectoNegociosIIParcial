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
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace Sistema_de_control_de_estacionamiento
{
    /// <summary>
    /// Lógica de interacción para MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        SqlConnection sqlConnection;
 
        public MainWindow()
        {
            InitializeComponent();
            string connectionString = ConfigurationManager.ConnectionStrings["Sistema_de_control_de_estacionamiento.Properties.Settings.Parqueo"].ConnectionString;
            sqlConnection = new SqlConnection(connectionString);
            MostrarTipoVehiculo();

        }

        private void Border_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            DragMove();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();

        }

        private void Border_MouseLeftButtonDown_1(object sender, MouseButtonEventArgs e)
        {

        }

        private void LblAuto_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void LblTipoAuto_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {

        }

        private void BtnReporte_Click(object sender, RoutedEventArgs e)
        {

        }
        private void MostrarTipoVehiculo()
        {
            try { 
            string query = "SELECT * FROM ESTACIONAMIENTO.TipoVehiculo";
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query,sqlConnection);
                using (sqlDataAdapter)
                {
                    DataTable tablaTipo = new DataTable();
                    sqlDataAdapter.Fill(tablaTipo);
                    lblTipoAuto.DisplayMemberPath = "tipoCarro";
                    lblTipoAuto.SelectedValue = "id";
                    lblTipoAuto.ItemsSource = tablaTipo.DefaultView;

                }
            }
            catch(Exception ex)
            {

            }
        }
    }
}
