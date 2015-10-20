use v5.20;
use feature qw(signatures);
no warnings qw(experimental::signatures);

test1('Hellow');
my $test;
say test2($test);

sub test1($a){
 say $a;
}

sub test2($b){
my $local_test=$b // 'undef1';
return $local_test;
}
