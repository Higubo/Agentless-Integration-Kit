<%@ LANGUAGE = VBSCRIPT %>
<html>
<body>


<%

'�Z���t�T�C���ؖ����̃G���[�𖳎����邽�߂̐ݒ� ���̂P
SXH_OPTION_IGNORE_SERVER_SSL_CERT_ERROR_FLAGS = 2
SXH_SERVER_CERT_IGNORE_UNKNOWN_CA = 256
SXH_SERVER_CERT_IGNORE_ALL_SERVER_ERRORS = 13056

'�A�v�����Ȃ��ɂ���PingFederete�̃x�[�XURL
SV="https://PingFederata_FQDN:9031/ext/ref/pickup?REF="

'�x�[�XURL�Ƀ��t�@�����XID�iREF�j�̒l��t�����ŏIURL, REF���N�G���p�����[�^�ł͂Ȃ�Form POST�œn���Ƃ���,Request.QueryString("REF")�ł͂Ȃ� Request.Form("REF")���g�p���邱�ƁB
URL=SV & Request.QueryString("REF")


'XMLHTTP�łȂ��ɂ�������
Dim oXMLHTTP
Set oXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.3.0")

'GET���\�b�h�ŁA��L��URL�ɑ΂��āA�񓯊��ŃA�N�Z�X����BBasic�F�؂�ID/Password��higumaru/higumaru
oXMLHTTP.Open "GET",URL,False,"higumaru","higumaru"

'�Z���t�T�C���ؖ����̃G���[�𖳎����邽�߂̐ݒ� ���̂Q
oXMLHTTP.setOption 2,13056

'PingFederate�ɃA�N�Z�X����ۂɕK�v�ƂȂ�Ǝ����N�G�X�g�w�b�_(ping.instanceId)�Ƃ��̒l�iRefidForASP�͂��q�l�̊��ɍ��킹��j
oXMLHTTP.setRequestHeader "ping.instanceId","RefidForASP"

'PingFederate�ɐڑ�
oXMLHTTP.Send


'�������ʂ��e�L�X�g�ŕ\��
Response.Write(oXMLHTTP.responseText)



%>


</body>
</html>