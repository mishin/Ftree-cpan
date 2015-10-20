use Data::Show;
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
$slurp_text = slurp($file);

sub slurp {
    my ($abs_file_path) = @_;
    open my $fh, '<', $abs_file_path or croak $!;
    local $/;
    my $text = <$fh>;
}

my %contents_of = do { local $/; "", split /\[(\S+)\]\n/, $slurp_text };

show %contents_of;
