use v5.10;
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

my $Individuals=$contents_of{Individuals};
my $Contacts=$contents_of{Contacts};
my $Educations=$contents_of{Educations};
my $Families=$contents_of{Families};
my $Marriages=$contents_of{Marriages};
my $Occupations=$contents_of{Occupations};
my $Pictures=$contents_of{Pictures};
my $Places=$contents_of{Places};
my $SourcesAndCitations=$contents_of{SourcesAndCitations};
my @Individuals_lines=split /\n/,$Individuals;
my @column_names=split /\t/,$Individuals_lines[0];
say "@column_names";
# my $len=@Individuals_lines+0;
# say "@Individuals_lines";#[l..$len];
# show $Individuals;#%contents_of;
show @Individuals_lines;#%contents_of;
