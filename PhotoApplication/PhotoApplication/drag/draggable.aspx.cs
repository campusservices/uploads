using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace PhotoApplication.drag
{
    
    public partial class draggable : System.Web.UI.Page
    {
        public string blah;    
        private MySqlConnection conn;

        protected void Page_Load(object sender, EventArgs e)
        {
         
            String s = Request.Form.Get("aidm");

            Session["aidm"] = s;

           
        }

        private void mySQLconnectSQL()
        {


            conn = new MySqlConnection();


            conn.ConnectionString = "SERVER=" + "OWL2" + ";" + "DATABASE=" +
                "photos" + ";" + "port=3305;" + "UID=" + "admin" + ";" + "PASSWORD=" + "kentish" + ";";


            conn.Open();


        }
        private void insertAIDM(String s)
        {

            String ConnectString = "INSERT INTO applicantid (aidm) values(@0) ";
            
            
            mySQLconnectSQL();

            using (MySqlCommand command = new MySqlCommand(ConnectString, conn))
            {

                    try
                    {

                        command.Parameters.Add(new MySqlParameter("0", s));
                        
                        command.ExecuteNonQuery();

                        command.Dispose();

                    }
                    catch (Exception e)
                    {

                        Console.WriteLine("{0} Exception caught.", e);

                    }
             }
            

        }


    }


    
}