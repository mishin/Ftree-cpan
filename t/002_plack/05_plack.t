# base.t
use strict;
use warnings;
use Test::More tests => 3;
use Plack::Test;
use HTTP::Request;
use FindBin qw($Bin);
use lib "$Bin/../lib";

#use MyApp;

use CGI::Emulate::PSGI;
use CGI::Compile;
$CGI::Compile::RETURN_EXIT_VAL = 1;
use Plack::Builder;

my $cgi_script = $Bin . '/ftree.cgi';
my $sub        = CGI::Compile->compile($cgi_script);
my $app        = CGI::Emulate::PSGI->handler($sub);

my $cgi_person = $Bin . '/person_page.cgi';
my $sub_person = CGI::Compile->compile($cgi_person);
my $app2       = CGI::Emulate::PSGI->handler($sub_person);

my $test_app = builder {
	enable "Plack::Middleware::Static",
	  path => qr{[gif|png|jpg|swf|ico|mov|mp3|pdf|js|css]$},
	  root => './';
	mount "/person_page" => $app2;
	mount "/ftree"       => $app;
	mount "/"            => builder { $app };
};

is ref($app), 'CODE';

#my $app = MyApp->to_app;
my $test = Plack::Test->create($app);

my $request = HTTP::Request->new( GET => '/ftree' );
my $response = $app2->request($request);

ok( $response->is_success, '[GET /] Successful request' );
is( $response->content, 'OK', '[GET /] Correct content' );

#
#
#my $app = MyApp->to_app;
#my $test = Plack::Test->create($app);
#
#my $request  = HTTP::Request->new( GET => '/' );
#my $response = $test->request($request);
#
#ok( $response->is_success, '[GET /] Successful request' );
#is( $response->content, 'OK', '[GET /] Correct content' );
