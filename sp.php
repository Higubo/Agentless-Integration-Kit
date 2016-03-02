<?php

// Requires libcurl to be installed. For more info, see:
// http://us.php.net/manual/en/book.curl.php

function createUserSession($subject, $your_attribute)
{
   echo "<p>Welcome, ".strip_tags($subject)."</p>";
}

$refid = $_POST['REF'];

$ping.username = 'USERNAME';
$ping.password = 'PASSWORD';

$sso_service = "https://YOUR_PINGFEDERATE_URL:9031/ext/ref/pickup?REF=$refid";


$c = curl_init($sso_service);
curl_setopt($c, CURLOPT_RETURNTRANSFER, true);
curl_setopt($c, CURLOPT_SSL_VERIFYPEER,false);
curl_setopt($c, CURLOPT_HTTPAUTH, CURLAUTH_BASIC);
curl_setopt($c, CURLOPT_USERPWD, "$ping.username:$ping.password");
curl_setopt($c, CURLOPT_HTTPHEADER,  array('ping.instanceId: REF_ID_ADAPTER_NAME'));


$response = curl_exec($c);
curl_close($c);


echo $response;


?>

