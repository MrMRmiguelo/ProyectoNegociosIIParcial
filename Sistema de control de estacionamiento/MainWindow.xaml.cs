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
            string connectionString = ConfigurationManager.ConnectionStrings["Sistema_de_control_de_estacionamiento.Properties.Settings.Estacionamiento"].ConnectionString;
            sqlConnection = new SqlConnection(connectionString);
           Mostrar();
           Registro();


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
        private void Button_Click_4(object sender, RoutedEventArgs e)
        {
            if (txtPlaca.Text == string.Empty || txtTipo.Text == string.Empty)
            {
                MessageBox.Show("No debe de dejar ningun campo vacio");
                txtPlaca.Focus();
                txtTipo.Focus();
            }
            else
            {
                try
                {
                    SqlCommand sqlCommand = new SqlCommand("Vehiculos.SP_AGREGAR_VEHICULO", sqlConnection);
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    sqlConnection.Open();
                    sqlCommand.Parameters.AddWithValue("@numPlaca", txtPlaca.Text);
                    sqlCommand.Parameters.AddWithValue("@tipoVehiculo", txtTipo.Text);
                    sqlCommand.ExecuteNonQuery();
                    txtPlaca.Text = String.Empty;
                    txtTipo.Text = String.Empty;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());

                }
                finally
                {
                    sqlConnection.Close();
                    Mostrar();
                    Registro();
                }
            }
        }

        private void BtnSalir_Click(object sender, RoutedEventArgs e)
        {
           if (txtPlaca.Text == string.Empty)
            {
                MessageBox.Show("No debe de dejar ningun campo vacio");
                txtPlaca.Focus();
            }
            else
            {
                try
                {
                    SqlCommand sqlCommand = new SqlCommand("Vehiculos.SP_AGREGAR_SALIDA ", sqlConnection);
                    sqlCommand.CommandType = CommandType.StoredProcedure;
                    sqlConnection.Open();
                    sqlCommand.Parameters.AddWithValue("@numPlacaES",txtPlaca.Text);
 
                    sqlCommand.ExecuteNonQuery();
                    txtPlaca.Text = String.Empty;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.ToString());

                }
                finally
                {
                    sqlConnection.Close();
                    Mostrar();
                    Registro();
                }
           }


    }

        private void Mostrar()
        {
            try
            {
                string query = "SELECT * FROM Vehiculos.vehiculo ";

                SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(query, sqlConnection);

                using (sqlDataAdapter)
                {
                    DataTable tablaVehiculo = new DataTable();
                    sqlDataAdapter.Fill(tablaVehiculo);
                    lblPlaca.DisplayMemberPath = "numPlacaE";
                    lblPlaca.SelectedValue = "idVehiculoE";
                    lblPlaca.ItemsSource = tablaVehiculo.DefaultView;
                }

            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());

            }
        }
        

       





      private void BtnReporte_Click(object sender, RoutedEventArgs e)
        {
        }

        


        private void LblPlaca_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
     
       }
        private void Registro()
        {
            
            sqlConnection.Open();
            SqlCommand sqlCommand = new SqlCommand("Vehiculos.SP_REPORTE", sqlConnection);
            sqlCommand.CommandType = CommandType.StoredProcedure;
            SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand);
             DataTable tabla = new DataTable();
            sqlDataAdapter.Fill(tabla);
            dt.ItemsSource = tabla.DefaultView;
            sqlConnection.Close();



        }
        private void BtnSalida_Vehiculo_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                string query = "UPDATE Vehiculo SET HoraSalida = GETDATE() WHERE numPlacaE = @placa";

                SqlCommand sqlCommand = new SqlCommand(query, sqlConnection);



                sqlConnection.Open();

                sqlCommand.Parameters.AddWithValue("@placa", txtPlaca.Text);
                sqlCommand.ExecuteNonQuery();


                txtPlaca.Text = String.Empty;
                string a;
                a = dt.SelectedValue.ToString();
                if(txtTipo.Text == "Pesado")
                MessageBox.Show("El vehiculo con numero de placa: " + a + "\nSe ah retirado exitosamente\nTotal a pagar: L.200.00\n");
                if (txtTipo.Text == "Liviano")
                    MessageBox.Show("El vehiculo con numero de placa: " + a + "\nSe ah retirado exitosamente\nTotal a pagar: L.100.00\n");
                if (txtTipo.Text == "Liviano")
                    MessageBox.Show("El vehiculo con numero de placa: " + a + "\nSe ah retirado exitosamente\nTotal a pagar: L.50.00\n");

            }
                catch (Exception ex)
            {
                MessageBox.Show(ex.ToString());
            }
            finally
            {
                sqlConnection.Close();
                Mostrar();
            }
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Maximized;
        }

        private void Button_Click_2(object sender, RoutedEventArgs e)
        {
            WindowState = WindowState.Minimized;
        }

        private void TxtPlaca_KeyDown(object sender, KeyEventArgs e)
        {
            this.txtPlaca.MaxLength = 7;

        }
   
    }
}