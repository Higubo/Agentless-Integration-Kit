<%@ page import="javax.net.ssl.SSLContext"%>
<%@ page import="javax.net.ssl.TrustManager"%>
<%@ page import="javax.net.ssl.X509TrustManager"%>
<%@ page import="javax.net.ssl.SSLSocketFactory"%>
<%@ page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.URLConnection"%>
<%@ page import="java.security.cert.X509Certificate"%>
<%@ page import="java.security.cert.CertificateException"%>
<%@ page import="java.io.InputStream"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.io.OutputStreamWriter"%>


<%@ page import="javax.net.ssl.SSLSession"%>
<%@ page import="javax.net.ssl.HostnameVerifier"%>


<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONValue"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ContainerFactory"%>
<%@ page import="org.json.simple.parser.ParseException"%>

<HTML>
<BODY>
<H1>PingFederate (IdP) Agentless test</H1>

<H3>

<%

      // Create a dummy X509TrustManager that will trust any server certificate
     // This is for example only and should not be used in production
      X509TrustManager tm = new X509TrustManager()
      {
         public void checkClientTrusted(X509Certificate[] x509Certs, String s)
         throws CertificateException
         {

         }
 
         public void checkServerTrusted(X509Certificate[] x509Certs, String s)
         throws CertificateException
         {
          
         }
 
         public X509Certificate[] getAcceptedIssuers()
         {
            return new X509Certificate[0];
         }
        };



 
 
      // Use the trust manager to get an SSLSocketFactory
      SSLContext sslContext = SSLContext.getInstance("TLS");
      sslContext.init(null, new TrustManager[] {tm}, null);
      SSLSocketFactory socketFactory = sslContext.getSocketFactory();
  
// Create a JSON Object containing user attributes
  JSONObject idpUserAttributes = new JSONObject();
  idpUserAttributes.put("subject", "username");  //Usename for Test
  //idpUserAttributes.put("attribute1", "value1");
  //idpUserAttributes.put("attribute2", "value2");
  //idpUserAttributes.put("foo", "bar");

// Drop the attributes into PingFederate
  String dropoffLocation = "https://<PF_HOST>:<PF_PORT>/ext/ref/dropoff";
  System.out.println(dropoffLocation);
  URL dropUrl = new URL(dropoffLocation);
  URLConnection urlConnection = dropUrl.openConnection();
  HttpsURLConnection httpsURLConnection = (HttpsURLConnection)urlConnection;
  httpsURLConnection.setSSLSocketFactory(socketFactory);
  urlConnection.setRequestProperty("ping.uname", "higumaru");
  urlConnection.setRequestProperty("ping.pwd", "higumaru");
  
  

  // ping.instanceId is optional and only needs to be specified if multiple instances of ReferenceId adapter are configured.
  
  urlConnection.setRequestProperty("ping.instanceId", "hoge");
  
  //SSL Certificate Hostname check  
       HostnameVerifier hv = new HostnameVerifier()
     {
        public boolean verify(String arg0, SSLSession arg1)
       {
         return true;
       }
     };
     HttpsURLConnection.setDefaultHostnameVerifier(hv);

  
  
  
  // Write the attributes in URL Connection, this example uses UTF-8 encoding
  
  urlConnection.setDoOutput(true);
  
  OutputStreamWriter outputStreamWriter = new OutputStreamWriter(urlConnection.getOutputStream(), "UTF-8");
  idpUserAttributes.writeJSONString(outputStreamWriter);
  outputStreamWriter.flush();
  outputStreamWriter.close();

  // Get the response and parse it into a JSON object
  InputStream is = urlConnection.getInputStream();
  InputStreamReader streamReader = new InputStreamReader(is, "UTF-8");
  JSONParser parser = new JSONParser();
  JSONObject jsonRespObj = (JSONObject)parser.parse(streamReader);

  // Grab the value of the reference Id from the JSON Object. This value
  // must be passed to PingFederate on resumePath as the parameter 'REF'
  String referenceValue = (String)jsonRespObj.get("REF");
  
  
  String resumePath = request.getParameter("resumePath");

  String finalLocation = "https://<PF_HOST>:<PF_PORT>" + resumePath + "?REF=" + referenceValue;

   
%>
</H3>

<H3>
<%
out.println("Reference ID = " + referenceValue);
%>
</H3>

<H3>
<%
out.println("resumePath = " + resumePath);
%>
</H3>

<H3>
<%
out.println(finalLocation);
%>
</H3>


</BODY>
</HTML>