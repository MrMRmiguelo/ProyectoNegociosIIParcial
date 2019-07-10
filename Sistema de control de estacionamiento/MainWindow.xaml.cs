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
            Mostrar();
            MostrarColor();
            MostrarTipo();


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

        private void MostrarVehiculo()
        {

        }
        /*   private void MostrarReporte()
           {
               try
               {
                   string query = "SELECT * FROM Parking.Registro";
                   //   SELECT * FROM Parking.Vehiculo";
                   SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, sqlConnection);
                   using (sqlDataAdapter)
                   {
                       DataTable tablaTipo = new DataTable();
                       sqlDataAdapter.Fill(tablaTipo);
                       //   lbReportes.DisplayMemberPath = "TipoVehiculo";
                       lbReporteFechaEntrada.DisplayMemberPath = "HoraEntrada";
                       lbReporteFechaSalida.DisplayMemberPath = "HoraSalida";
                       lbReportes.DisplayMemberPath = "Placa";
                       lbReportes.SelectedValue = "Id";
                       lbReporteFechaEntrada.SelectedValue = "IdEntrada";
                       lbReportes.ItemsSource = tablaTipo.DefaultView;
                       lbReporteFechaEntrada.ItemsSource = tablaTipo.DefaultView;
                       lbReporteFechaSalida.ItemsSource = tablaTipo.DefaultView;


                   }
               }
               catch (Exception ex)
               {
                   MessageBox.Show(ex.ToString());
               }
           }
           */
        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            if (txtPlaca.Text == string.Empty || txtTipo.Text == string.Empty || txtColor.Text == string.Empty)
            {
                MessageBox.Show("No debe de dejar ningun campo vacio");
                txtPlaca.Focus();
                txtColor.Focus();
                txtTipo.Focus();
            }
            else
            {
                try
                {
                    string query = ("INSERT INTO Parking.Vehiculo(Placa,TipoVehiculo,ColorVehiculo) VALUES(@Placa,@TipoVehiculo,@ColorVehiculo)");
                    SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);
                    sqlConnection.Open();
                    sqlCommand.Parameters.AddWithValue("@Placa", txtPlaca.Text);
                    sqlCommand.Parameters.AddWithValue("@TipoVehiculo", txtTipo.Text);
                    sqlCommand.Parameters.AddWithValue("@ColorVehiculo", txtColor.Text);
                    sqlCommand.ExecuteNonQuery();
                    txtPlaca.Text = String.Empty;
                    txtColor.Text = String.Empty;
                    txtTipo.Text = String.Empty;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());

                }
                finally
                {
                    sqlConnection.Close();
                    MostrarVehiculo();
                }
            }
        }

        private void BtnSalir_Click(object sender, RoutedEventArgs e)
        {


        }

        private void Mostrar()
        {
            try
            {
                string query = "SELECT * FROM Parking.Vehiculo ";

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, sqlConnection);

                using (sqlDataAdapter)
                {
                    DataTable tablaVehiculo = new DataTable();
                    sqlDataAdapter.Fill(tablaVehiculo);
                    lblPlaca.DisplayMemberPath = "Placa";
                    lblPlaca.SelectedValue = "Id";
                    lblPlaca.ItemsSource = tablaVehiculo.DefaultView;
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());

            }
        }
        private void MostrarTipo()
        {
            try
            {
                string query = "SELECT * FROM Parking.Vehiculo ";

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, sqlConnection);

                using (sqlDataAdapter)
                {
                    DataTable tablaVehiculo = new DataTable();
                    sqlDataAdapter.Fill(tablaVehiculo);
                    lblTipo.DisplayMemberPath = "TipoVehiculo";
                    lblTipo.SelectedValue = "Id";
                    lblTipo.ItemsSource = tablaVehiculo.DefaultView;
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());

            }
        }

        private void MostrarColor()
        {
            try
            {
                string query = "SELECT * FROM Parking.Vehiculo ";
                SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);

                using (sqlDataAdapter)
                {
                    DataTable tablaVehiculo = new DataTable();
                    sqlDataAdapter.Fill(tablaVehiculo);
                    lblColor.DisplayMemberPath = "ColorVehiculo";
                    lblColor.SelectedValue = "Id";
                    lblColor.ItemsSource = tablaVehiculo.DefaultView;
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());

            }
        }







        private void MostrarDetalle()
        {
            try
            {
                string query = @"SELECT * FROM Parking.Registro a INNER JOIN Parking.Vehiculo b
                                  ON a.IdEntrada=b.Id WHERE a.Id=@ParkingId";
                SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);
                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
                using (sqlDataAdapter)
                {
                    sqlCommand.Parameters.AddWithValue("@ParkingId", lblPlaca.SelectedValue);
                    DataTable registro = new DataTable();
                    sqlDataAdapter.Fill(registro);
                    lbReporteFechaEntrada.DisplayMemberPath = "HoraEntrada";
                    lbReporteFechaEntrada.SelectedValuePath = "IdEntrada";
                    lbReporteFechaEntrada.ItemsSource = registro.DefaultView;
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.ToString());

            }

    }

        private void LblPlaca_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            MostrarDetalle();
        }
    }
}