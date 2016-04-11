use Data::Dumper;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use FamilyTreeData;
use Spreadsheet::ParseExcel;
use Spreadsheet::ParseExcel::FmtJapan;

print Dumper createFamilyTreeDataFromFile();

sub createFamilyTreeDataFromFile {
  # my ($config_) = @_;
  my $file_name = 'mishin_family.xls';#$config_->{file_name} or die "No file_name is given in config";

  my $family_tree_data = FamilyTreeData->new();
    my $parser    = Spreadsheet::ParseExcel->new();
    my $formatter = Spreadsheet::ParseExcel::FmtJapan->new();

    my $workbook  = $parser->parse($file_name, $formatter)
	or die "Unable to parse file " . $file_name;
  # my $excel = Spreadsheet::ParseExcel::Workbook->Parse($file_name)
   if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }

	 for my $worksheet ( $workbook->worksheets() ) {
	  my ( $row_min, $row_max ) = $worksheet->row_range();
      my ( $col_min, $col_max ) = $worksheet->col_range();
	   for my $row ( $row_min .. $row_max ) {
            # for my $col ( $col_min .. $col_max ) {

                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;
my $tempperson = {
          id => $worksheet->get_cell( $row, 0 )->value(),#convertCell($sheet->{Cells}[$row][0]),
          first_name => $worksheet->get_cell( $row, 3 )->value(),#convertCell($sheet->{Cells}[$row][3]),
          mid_name   => $worksheet->get_cell( $row, 4 )->value(),#convertCell($sheet->{Cells}[$row][4]),
          last_name  => $worksheet->get_cell( $row, 5 )->value(),#convertCell($sheet->{Cells}[$row][5]),
          title      => $worksheet->get_cell( $row, 1 )->value(),#convertCell($sheet->{Cells}[$row][1]),
          prefix     => $worksheet->get_cell( $row, 2 )->value(),#convertCell($sheet->{Cells}[$row][2]),
          suffix     => $worksheet->get_cell( $row, 6 )->value(),#convertCell($sheet->{Cells}[$row][6]),
          nickname   => $worksheet->get_cell( $row, 7 )->value(),#convertCell($sheet->{Cells}[$row][7]),
          father_id  => $worksheet->get_cell( $row, 8 )->value(),#convertCell($sheet->{Cells}[$row][8]),
          mother_id  => $worksheet->get_cell( $row, 9 )->value(),#convertCell($sheet->{Cells}[$row][9]),
          email      => $worksheet->get_cell( $row, 10 )->value(),#convertCell($sheet->{Cells}[$row][10]),
          homepage   => $worksheet->get_cell( $row, 11 )->value(),#convertCell($sheet->{Cells}[$row][11]),
          date_of_birth => $worksheet->get_cell( $row, 12 )->value(),#convertCell($sheet->{Cells}[$row][12]),
          date_of_death => $worksheet->get_cell( $row, 13 )->value(),#convertCell($sheet->{Cells}[$row][13]),
          gender     => $worksheet->get_cell( $row, 14 )->value(),#convertCell($sheet->{Cells}[$row][14]),
          is_living  => $worksheet->get_cell( $row, 15 )->value(),#convertCell($sheet->{Cells}[$row][15]),
          place_of_birth => $worksheet->get_cell( $row, 16 )->value(),#convertCell($sheet->{Cells}[$row][16]),
          place_of_death => $worksheet->get_cell( $row, 17 )->value(),#convertCell($sheet->{Cells}[$row][17]),
          cemetery   => $worksheet->get_cell( $row, 0 )->value(),#convertCell($sheet->{Cells}[$row][18]),
          # schools    => (defined $sheet->{Cells}[$row][19]) ?
          schools    => (defined $worksheet->get_cell( $row, 19 )->value()) ?
            [split( /,/, $worksheet->get_cell( $row, 19 )->value())] : undef,
          jobs       => (defined $worksheet->get_cell( $row, 20 )->value()) ?
            [split( /,/, $worksheet->get_cell( $row, 20 )->value())] : undef,
          work_places => (defined $worksheet->get_cell( $row, 21 )->value()) ?
            [split( /,/, $worksheet->get_cell( $row, 21 )->value())] : undef,
          places_of_living => $worksheet->get_cell( $row, 22 )->value(),#convertCell($sheet->{Cells}[$row][22]),
          general    => $worksheet->get_cell( $row, 23 )->value()#convertCell($sheet->{Cells}[$row][23])
		  };
       $family_tree_data->add_person($tempperson);

				  # print $cell->value()."\n";
                # Do something with $cell->value() and remember to encode
                # any output streams if required.
            # }
        }

}
  # foreach my $sheet (@{$excel->{Worksheet}}) {
    # $sheet->{MaxRow} ||= $sheet->{MinRow};
    # foreach my $row ($sheet->{MinRow}+1 .. $sheet->{MaxRow}) {
       # my $tempperson = {
          # id => convertCell($sheet->{Cells}[$row][0]),
          # first_name => convertCell($sheet->{Cells}[$row][3]),
          # mid_name   => convertCell($sheet->{Cells}[$row][4]),
          # last_name  => convertCell($sheet->{Cells}[$row][5]),
          # title      => convertCell($sheet->{Cells}[$row][1]),
          # prefix     => convertCell($sheet->{Cells}[$row][2]),
          # suffix     => convertCell($sheet->{Cells}[$row][6]),
          # nickname   => convertCell($sheet->{Cells}[$row][7]),
          # father_id  => convertCell($sheet->{Cells}[$row][8]),
          # mother_id  => convertCell($sheet->{Cells}[$row][9]),
          # email      => convertCell($sheet->{Cells}[$row][10]),
          # homepage   => convertCell($sheet->{Cells}[$row][11]),
          # date_of_birth => convertCell($sheet->{Cells}[$row][12]),
          # date_of_death => convertCell($sheet->{Cells}[$row][13]),
          # gender     => convertCell($sheet->{Cells}[$row][14]),
          # is_living  => convertCell($sheet->{Cells}[$row][15]),
          # place_of_birth => convertCell($sheet->{Cells}[$row][16]),
          # place_of_death => convertCell($sheet->{Cells}[$row][17]),
          # cemetery   => convertCell($sheet->{Cells}[$row][18]),
          # schools    => (defined $sheet->{Cells}[$row][19]) ?
            # [split( /,/, convertCell($sheet->{Cells}[$row][19]))] : undef,
          # jobs       => (defined $sheet->{Cells}[$row][20]) ?
            # [split( /,/, convertCell($sheet->{Cells}[$row][20]))] : undef,
          # work_places => (defined $sheet->{Cells}[$row][21]) ?
            # [split( /,/, convertCell($sheet->{Cells}[$row][21]))] : undef,
          # places_of_living => convertCell($sheet->{Cells}[$row][22]),
          # general    => convertCell($sheet->{Cells}[$row][23])};
       # $family_tree_data->add_person($tempperson);
    # }
  # }
  # if (defined $config_->{photo_dir}) {
    # ExtendedSimonWardFormat::setPictureDirectory($config_->{photo_dir});
    # ExtendedSimonWardFormat::fill_up_pictures($family_tree_data);
  # }

  return $family_tree_data;
}