using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Drawing;
using MySql.Data.MySqlClient;
using System.Data.OracleClient;
using System.Data;

namespace PhotoApplication
{
    /// <summary>
    /// Summary description for Photo1
    /// </summary>
    public class Photo1 : IHttpHandler
    {
        private MySqlConnection conn;
        private const String postGradUpload = "//phoenix3/pg_app_uploads/";
        private const String underGradUpload = "//phoenix3/ug_app_uploads/";
        OracleConnection con;
        
        public class Applicant
        {
            public string firstname { get; set; }
            public string lastname { get; set; }
            public string level { get; set; }
            public string term { get; set; }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
        private void mySQLconnectSQL()
        {


            conn = new MySqlConnection();


            conn.ConnectionString = "SERVER=" + "OWL3" + ";" + "DATABASE=" +
                "photos" + ";" + "port=3305;" + "UID=" + "admin" + ";" + "PASSWORD=" + "kentish" + ";";


            conn.Open();


        }
        private Applicant getApplicantName(String aidm,HttpContext context)
        {

            Int32 val = Int32.Parse(aidm);
            
            Applicant applicant = new Applicant();


            DataSet ds = Library.getApplicantName(val);

            int total = ds.Tables[0].Rows.Count;

            try
            {
                if (total > 0)
                {
                    foreach (DataRow dr in ds.Tables[0].Rows)
                    {

                        applicant.firstname = dr["FIRSTNAME"].ToString();
                        applicant.lastname = dr["LASTNAME"].ToString();
                        applicant.term = dr["SEMESTER"].ToString();
                        applicant.level = dr["LEVL"].ToString();
           
                    }
                }
            }
            catch (Exception ex)
            {
                String str = ex.Message;
            }

            
            return applicant;
        }
        
        private void insertStudentPathDetails(String aidm, String path)
        {

            Library.insertStudentPathDetails(aidm, path);
            
        }
        public void ProcessRequest(HttpContext context)
        {

           

            string aidm = context.Request.QueryString["id"];
            string docType = context.Request.QueryString["docType"];
  
            //string filePath = "//uploaded//";

            PhotoApplication.ImpersonateUser.Impersonate("cavehill", "webimages", "crEn7s*e");

            String dte = DateTime.Now.ToString("M/d/yyyy");

            dte = dte.Replace("/", "_");

            //write your handler implementation here.
            context.Response.ContentType = "image/png";

            

                if (context.Request.Files.Count <= 0)
                {
                    context.Response.Write("No file uploaded");
                }
                else
                {
                    for (int i = 0; i <= context.Request.Files.Count; ++i)
                    {
                        if (i >= 1)
                        {

                            HttpPostedFile file = context.Request.Files[i - 1];
                            
                            string extension = System.IO.Path.GetExtension(file.FileName.ToString());
                            if (docType.Equals("photo"))
                            {
                                if (extension.Equals(".png") || extension.Equals(".jpg"))
                                {

                                    try
                                    {
                                        this.processPhoto(extension, file, context, aidm, dte, docType);
                                    }
                                    catch (Exception ex)
                                    {
                                        context.Response.ContentType = "text/plain";
                                        context.Response.Write("the error is = " + ex.Message.ToString());
                                    }
                                    break;
                                  
                                }
                                else
                                {
                                    context.Response.ContentType = "text/plain";
                                    context.Response.Write("error, Document Type Should be Photo" );
                                    break;

                                }
                            }
                            if (!docType.Equals("photo"))
                            {

                                if (extension.Equals(".pdf") || extension.Equals(".docx") || extension.Equals(".doc"))
                                {
                                    try
                                    {
                                        this.processOtherFiles(extension, file, context, aidm, dte, docType);

                                        break;
                                    }
                                    catch (Exception ex)
                                    {
                                        context.Response.ContentType = "text/plain";
                                        context.Response.Write("error, " + ex.Message.ToString());

                                        break;
                                    }
                                }
                                else
                                {

                                    context.Response.ContentType = "text/plain";
                                    context.Response.Write("error, file of incorrect type:Required docx, pdf or doc");

                                }

                            }

                            file.InputStream.Close();
                            file.InputStream.Dispose();
                        }

                        //context.Response.Write("File uploaded");
                    }
                }

                PhotoApplication.ImpersonateUser.Undo(); 
        }
        private void processPhoto(String extension, HttpPostedFile file, HttpContext context, String aidm, String dte, String docType)
        {
            Applicant applicant = this.getApplicantName(aidm,context);

            if (extension.Equals(".jpg") || (extension.Equals(".png")))
            {

                Image image = Image.FromStream(file.InputStream, true, true);
                int height = image.Height;
                int width = image.Width;

            
                if (width > 192 || width <= 193)
                {
                    if (height > 192 || height <= 193)
                    {

                        String s = this.CreateIfMissing("", context, applicant.level, applicant.term, aidm, applicant.firstname + "_" + applicant.lastname,docType);
                        String name = applicant.firstname + "_" + applicant.lastname;
                        s = s + aidm + "_" + applicant.level + "_" + name + "_" + dte + "_" + applicant.term + extension;
                        file.SaveAs(s);
                        String B64Photo = B64Encode(s);

                        this.insertStudentPathDetails(aidm, s);
                        context.Response.ContentType = "text/plain";
                        context.Response.Write(B64Photo);
                        file.InputStream.Flush();
                        file.InputStream.Dispose();
                        file.InputStream.Close();
                    }
                    else
                    {
                        context.Response.ContentType = "text/plain";
                        context.Response.Write("error, check dimensions of image");

                    }
                }
                else
                {
                    context.Response.ContentType = "text/plain";
                    context.Response.Write("error, check dimensions of image");
                }

            } 
        }
        private void processOtherFiles(String extension, HttpPostedFile file, HttpContext context, String aidm, String dte, String docType)
        {
            Applicant applicant = this.getApplicantName(aidm, context);
            String s = this.CreateIfMissing("", context, applicant.level, applicant.term, aidm, applicant.firstname + "_" + applicant.lastname, docType);
            String name = applicant.firstname + "_" + applicant.lastname;
            //s = context.Server.MapPath(s + aidm + "_" + applicant.level + "_" + name + "_" + dte + "_" + applicant.term + extension);
            s = s + aidm + "_" + applicant.level + "_" + name + "_" + dte + "_" + applicant.term + extension;
            file.SaveAs(s);

            this.insertStudentPathDetails(aidm, s);
        }
        private String CreateIfMissing(string path, HttpContext context, String level, String term, String aidm, String name, String docType)
        {
           
            if (docType.Equals("transcript")){
            
                path =  term + "/" + level + "/" + aidm + "_" + name + "/" + "transcripts/";
            
            } else if (docType.Equals("photo")){

                path =   term + "/" + level + "/" + aidm + "_" + name + "/" + "photo/";

            }
            else if (docType.Equals("CV"))
            {
                path = term + "/" + level + "/" + aidm + "_" + name + "/" + "cv/";
            }
            else if (docType.Equals("other"))
            {

                path = term + "/" + level + "/" + aidm + "_" + name + "/" + "other/";

            } else if (docType.Equals("BirthCertificate")){

                path = term + "/" + level + "/" + aidm + "_" + name + "/" + "BirthCertificate/";

            }
            else if (docType.Equals("ReferenceLetter"))
            {

                path = term + "/" + level + "/" + aidm + "_" + name + "/" + "ReferenceLetter/";
            
            }
            
            bool folderExists = false;

            if (level.Equals("UG"))
            {
                path = underGradUpload + path;
                folderExists = Directory.Exists(path);
            }
            else if (level.Equals("GR"))
            {
                path = postGradUpload + path;
                folderExists = Directory.Exists(path);
            }

            try
            {

                if (!folderExists)
                {

                    Directory.CreateDirectory(path);

                }
            }
            catch (Exception ex)
            {
                context.Response.Write("Exception creating directory " + ex.Message);


             

            }
            return path;
        }
        private String B64Encode(String path)
        {
            String B64String = "";
            try
            {
                Image a = new Bitmap(path);
                

                using (MemoryStream ms = new MemoryStream())
                {
                    // Convert Image to byte[]
                    a.Save(ms, a.RawFormat);
                    byte[] imageBytes = ms.ToArray();

                    // Convert byte[] to Base64 String
                    B64String = Convert.ToBase64String(imageBytes);
                    a.Dispose();
                   
                }
            }
            catch (Exception ex)
            {
                String v = ex.Message.ToString();
            }
            return B64String;

        }
        private String CreateLocalFolder(string path, HttpContext context, String level, String term, String aidm, String name, String docType)
        {
            path = "/images/" + "level/" + "term/";

            Boolean folderExists = Directory.Exists(context.Server.MapPath("~"+path));
            try
            {

                if (!folderExists)
                {
                    Directory.CreateDirectory(context.Server.MapPath("~" + path));
                }
            }
            catch (Exception ex)
            {
                context.Response.Write("Exception creating directory " + ex.Message);




            }
            return path;
        }
        private void oracleConnectSQL()
        {

                con = new OracleConnection();
                con.ConnectionString = "User Id=baninst1;Password=ban_8_admin;Data Source=PRODCH";
                con.Open();
                Console.WriteLine("Connected to Oracle" + con.ServerVersion);
        }
        private void oracleTestConnectSQL()
        {

            con = new OracleConnection();
            con.ConnectionString = "User Id=baninst1;Password=u_pick_it;Data Source=fintest";
            con.Open();
            Console.WriteLine("Connected to Oracle" + con.ServerVersion);
        }
    }
        
        
        
    }

