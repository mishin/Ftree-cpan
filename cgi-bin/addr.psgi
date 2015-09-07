my $app = sub {
    my $env = shift;
    return [
        200, 
        ['Content-Type' => 'text/plain'],
        [ "Hello stranger from $env->{REMOTE_ADDR}!"],
    ];
};