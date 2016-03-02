
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Collections.Generic" %>



<script language="C#" runat="server" >



void Page_Load(object sender, EventArgs ev)

{
//ŠÂ‹«‚É‡‚í‚¹‚Äİ’è
string pf_base_url = "https://PF_HOST:PF_PORT";

//REFID‚ğQueryString‚Å“n‚·‚Æ‚¢‚¤“_‚É’ˆÓ
string ref_value = Page.Request.QueryString.Get("REF");

//ŠÂ‹«‚É‡‚í‚¹‚Äİ’è
string app_instanceid = "RefID_Adapter_InstanceName";

//ŠÂ‹«‚É‡‚í‚¹‚Äİ’è
string app_username = "USERNAME";

//ŠÂ‹«‚É‡‚í‚¹‚Äİ’è
string app_password = "PASSWORD";
string pickup_loc = pf_base_url + "/ext/ref/pickup?REF=" + ref_value;

string jsonResponseMessage = "";
string httpResponseMessage = "";
string httpResponseCode = "500";
string returnUrl = "";


try
{



  HttpWebRequest httpRequest =(HttpWebRequest)HttpWebRequest.Create(pickup_loc);

  // DEBUG / TESTING ONLY - Ignore SSL Cert Mismatch Errors
  System.Net.ServicePointManager.ServerCertificateValidationCallback = delegate {return true; };


  byte[] httpAuthZHeaderBytes = System.Text.Encoding.UTF8.GetBytes(app_username + ":" + app_password);
  httpRequest.Headers.Add("Authorization", "Basic " + Convert.ToBase64String(httpAuthZHeaderBytes));
  httpRequest.Headers.Add("ping.instanceId", app_instanceid);
  httpRequest.Method = "GET";
  HttpWebResponse httpResponse = (HttpWebResponse)httpRequest.GetResponse();
  httpResponseCode = httpResponse.StatusCode.ToString();
  httpResponseMessage = httpResponse.StatusDescription;
  using (StreamReader rd = new
  StreamReader(httpResponse.GetResponseStream()))
  {
      jsonResponseMessage = rd.ReadToEnd();
  }



   httpResponse.Close();


}

catch (WebException webex)
{
   httpResponseCode = "500";
   httpResponseMessage = webex.Message;
}
if (httpResponseCode == "OK")
{


Response.Write(jsonResponseMessage);

}

}



</Script>

<html>
<body>
</body>
</html>