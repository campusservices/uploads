using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data.OracleClient;

namespace PhotoApplication
{
    /// <summary>
    /// Summary description for Service
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class Service : System.Web.Services.WebService
    {
        OracleConnection con;

       

        [WebMethod]
        public string HelloWorld()
        {
            return "Hello World";
        }
        [WebMethod]
        public string getLevel(String aidm)
        {
            String sqlstmt = "select DISTINCT SAVEAPS.SAVEAPS_LEVL_CODE " +
                             "from BANINST1.SAVEAPS SAVEAPS " +
                             "where SAVEAPS.SAVEAPS_AIDM = :0";
            String level = "";

            try
            {

                using (OracleCommand command = new OracleCommand(sqlstmt, con))
                {
                    command.Parameters.Add(new OracleParameter("0", aidm));

                    using (OracleDataReader reader = command.ExecuteReader())
                    {
                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                level = reader.GetString(0);
                            }
                        }
                    }
                }
            }
            catch (Exception e)
            {

                Console.WriteLine("{0} Exception caught.", e);

            }
            con.Close();
            return level;
        }
        private void oracleConnectSQL()
        {

            con = new OracleConnection();
            con.ConnectionString = "User Id=baninst1;Password=ban_8_admin;Data Source=PRODCH";
            con.Open();
            Console.WriteLine("Connected to Oracle" + con.ServerVersion);
        }
    }
}
