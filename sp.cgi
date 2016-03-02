#!C:/Perl64/bin/perl.exe

print "Content-type: text/plain; charset=iso-8859-1\n\n";

use strict;
use warnings;
use CGI;
use CGI qw(param);
use LWP::UserAgent;
use HTTP::Request::Common;

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;

my $name = "PF_USERNAME";
my $pass = "PF_PASSWORD";
my $referenceValue = param('REF');
my $headername = "ping.instanceId";
my $headervalue = "PF_INSTANCEID";

my $ua = LWP::UserAgent->new;
my $req = HTTP::Request::Common::GET(
    "https://PF_HOST:PF_PORT/ext/ref/pickup?REF=$referenceValue", 
    $headername => $headervalue,
    );
$req->authorization_basic($name, $pass);
my $res = $ua->request($req);
die $res->status_line if $res->is_error;

print $res->decoded_content;



