use Data::Dumper;
use Data::XLSX::Parser;


my $parser    = Data::XLSX::Parser->new;
my $file_name = 'mishin_family.xls.xlsx';

# $parser->add_row_event_handler(sub {
# my ($row) = @_;
# print Dumper $row;
# });
$parser->open($file_name);
my $cells = [];
$parser->add_row_event_handler(
	sub {
		my ($row) = @_;
		push @$cells, $row;
	}
);
print Dumper $cells;

# my $cells = [];
# $parser->add_row_event_handler(
# sub {
# my ($row) = @_;
# push @$cells, $row;
# }
# );
# $parser->parse($file_name);
