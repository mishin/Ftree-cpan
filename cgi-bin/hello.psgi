my $app = sub {
    my $env = shift;
    if ($env->{PATH_INFO} eq '/i59.jpg') {
        open my $fh, "<:raw", "c:/Users/TOSH/Documents/GitHub/Ftree-cpan/cgi-bin/pictures/i59.jpg" or die $!;
        return [ 200, ['Content-Type' => 'image/jpeg'], $fh ];
    } elsif ($env->{PATH_INFO} eq '/') {
        return [ 200, ['Content-Type' => 'text/plain'], [ "Hello again" ] ];
    } else {
        return [ 404, ['Content-Type' => 'text/html'], [ '404 Not Found' ] ];
    }
};