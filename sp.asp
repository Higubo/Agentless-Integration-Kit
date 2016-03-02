<%@ LANGUAGE = VBSCRIPT %>
<html>
<body>


<%

'セルフサイン証明書のエラーを無視するための設定 その１
SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS = 2
SXH_SERVER_CERT_IGNORE_UNKNOWN_CA = 256
SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056

'アプリがつなぎにいくPingFedereteのベースURL
SV="https://PingFederata_FQDN:9031/ext/ref/pickup?REF="

'ベースURLにリファレンスID（REF）の値を付けた最終URL, REFをクエリパラメータではなくForm POSTで渡すときは,Request.QueryString("REF")ではなく Request.Form("REF")を使用すること。
URL=SV & Request.QueryString("REF")


'XMLHTTPでつなぎにいく準備
Dim oXMLHTTP
Set oXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.3.0")

'GETメソッドで、上記のURLに対して、非同期でアクセスする。Basic認証のID/Passwordはhigumaru/higumaru
oXMLHTTP.Open "GET",URL,False,"higumaru","higumaru"

'セルフサイン証明書のエラーを無視するための設定 その２
oXMLHTTP.setOption 2,13056

'PingFederateにアクセスする際に必要となる独自リクエストヘッダ(ping.instanceId)とその値（RefidForASPはお客様の環境に合わせる）
oXMLHTTP.setRequestHeader "ping.instanceId","RefidForASP"

'PingFederateに接続
oXMLHTTP.Send


'応答結果をテキストで表示
Response.Write(oXMLHTTP.responseText)



%>


</body>
</html>