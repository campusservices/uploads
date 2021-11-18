using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.OracleClient;
using MySql.Data.MySqlClient;

namespace PhotoApplication
{
    public class Library
    {
        public static String getConnectString(){

            String connstr = "";

            connstr = "User Id=baninst1;Password=ban_8_admin;Data Source=ELUPROD";
            //connstr = "User Id=baninst1;Password=u_pick_it;Data Source=fintest";
            return connstr;

        }
        public static String getMySqlConnectionString()
        {
            String connstr = "";
            connstr = "SERVER=" + "OWL3" + ";" + "DATABASE=" +
               "photos" + ";" + "port=3305;" + "UID=" + "admin" + ";" + "PASSWORD=" + "kentish" + ";";

            return connstr;
        }
        public static void insertStudentPathDetails(String aidm, String path)
        {
            String cmdString = String.Format(@"INSERT INTO applicantid (aidm,pdfpath) values('{0}','{1}') "
                , aidm, path);

            DataSet ds = new DataSet();

            MySqlConnection conn;
            conn = new MySqlConnection();
            MySqlCommand cmd;

            conn.ConnectionString = getMySqlConnectionString();

            conn.Open();

            cmd = new MySqlCommand(cmdString, conn);
            MySqlDataAdapter data = new MySqlDataAdapter();

            cmd.ExecuteNonQuery();

            conn.Close();
            conn.Dispose();
        }
        public static DataSet getApplicantName(Int32 aidm)
        {
            DataSet ds = new DataSet();
            String cmdString = "";
            using (OracleConnection conn = new OracleConnection())
            {

                conn.ConnectionString = getConnectString();

                cmdString = String.Format(@"select DISTINCT SAVEAPS.SAVEAPS_FIRST_NAME AS FIRSTNAME, SAVEAPS.SAVEAPS_LAST_NAME AS LASTNAME, " + 
                                            "SAVEAPS.SAVEAPS_TERM_CODE_ENTRY AS SEMESTER, SAVEAPS.SAVEAPS_LEVL_CODE AS LEVL  " +
                                            "from BANINST1.SAVEAPS SAVEAPS  where SAVEAPS.SAVEAPS_AIDM = {0} " , aidm);

                using (OracleCommand cmd = new OracleCommand(cmdString, conn))
                {
                    OracleDataAdapter data = new OracleDataAdapter();
                    data.SelectCommand = cmd;
                    try
                    {

                        conn.Open();
                        data.Fill(ds);


                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            return ds;
                        }
                    }
                    catch (Exception Ex)
                    {
                        String msg = Ex.Message;
                    }
                }
            }
            return ds;
        }

    }
}