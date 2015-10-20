# In your program
use Config::Tiny;
 
# Create a config
my $Config = Config::Tiny->new;
 
# Open the config
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
$slurp_text=slurp($file);
sub slurp{
my ($abs_file_path)=@_;
open my $fh, '<', $abs_file_path or croak $!;
    local $/;
    my $text = <$fh>;
	}
# $Config = Config::Tiny->read( $file );
# use Data::Dumper;
# print Dumper $Config;

my %contents_of = do { local $/; "", split /\[ (\S+) \]_+\n/, $slurp_text };