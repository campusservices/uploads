using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PhotoApplication.drag
{
    public partial class uploads : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String s = Request.Form.Get("aidm");

            Session["aidm"] = s;
        }
    }
}