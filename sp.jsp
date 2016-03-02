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

<%@ page import="javax.net.ssl.SSLSession"%>
<%@ page import="javax.net.ssl.HostnameVerifier"%>


<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONValue"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ContainerFactory"%>
<%@ page import="org.json.simple.parser.ParseException"%>

<HTML>
<BODY>
<H1>PingFederate (SP) Agentless test</H1>

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

     

      // Grab the value of the reference Id from the request, this
      // will be sent by PingFederate as a query parameter 'REF'
      String referenceValue = request.getParameter("REF");
      out.println("REF = " + referenceValue + "<BR><BR>");

      // Call back to PF to get the attributes associated with the reference
      String pickupLocation = "https://<PF_HOST>:<PF_PORT>/ext/ref/pickup?REF=" + referenceValue;   // Please modify.
      System.out.println(pickupLocation);
      URL pickUrl = new URL(pickupLocation);


      //証明書CNとFQDNミスマッチ時のエラーを回避 Added by Higuchi 2013年3月13日
     HostnameVerifier hv = new HostnameVerifier()
     {
        public boolean verify(String arg0, SSLSession arg1)
       {
         return true;
       }
     };
     HttpsURLConnection.setDefaultHostnameVerifier(hv);



      URLConnection urlConn = pickUrl.openConnection();
      HttpsURLConnection httpsURLConn = (HttpsURLConnection)urlConn;
      httpsURLConn.setSSLSocketFactory(socketFactory);
      urlConn.setRequestProperty("ping.uname", "Administrator"); // !!! Plase modify.
      urlConn.setRequestProperty("ping.pwd", "2Federate2");  // !!!  Plase modify.
      // ping.instanceId is optional and only needs to be specified if multiple instances of ReferenceId adapter are configured.
      //urlConn.setRequestProperty("ping.instanceId", "spadapter");  // !!!  Please modify.

      // Get the response and parse it into another JSON object which are the
      //'user attributes'.
      // This example uses UTF-8 if encoding is not found in request.
      String encoding = urlConn.getContentEncoding();
      InputStream is = urlConn.getInputStream();
      InputStreamReader streamReader = new InputStreamReader(is, encoding != null ? encoding : "UTF-8");

      JSONParser parser = new JSONParser();
      JSONObject spUserAttributes = (JSONObject)parser.parse(streamReader);
      out.println("Attributes = " + spUserAttributes.toString() + "<BR><BR>");
   
%>
</H3>

</BODY>
</HTML>
 
 
