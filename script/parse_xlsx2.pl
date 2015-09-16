# use Spreadsheet::ParseXLSX;
# use     Spreadsheet::Read;
use Data::Dumper;
use Data::Printer;
use v5.14;
use Spreadsheet::XLSX;
 my $file_name='mishin_family.xls.xlsx';
my $excel = Spreadsheet::XLSX -> new ( $file_name);#, $converter);
 # my $file_name='mishin_family.xls.xlsx';
# my $parser = Spreadsheet::ParseXLSX->new;
  # my $excel            = Spreadsheet::ParseXLSX->new->parse($file_name)
      # or die "Unable to parse file " . $file_name;
	  
	  # my $workbook  = ReadData ($file_name) 
         # or die "Unable to parse file " . $file_name;
		  	# my $start=$workbook->[$sheet_number]{minrow}+1;
		# my $end=$workbook->[1]{maxrow};
	  # Spreadsheet::ParseXLSX::Workbook->Parse($file_name)
	  # p $excel ;
	  # foreach my $sheet (@{$excel -> {Worksheet}}) {
  foreach my $sheet ( @{ $excel->{Worksheet} } ) {
        # $sheet->{MaxRow} ||= $sheet->{MinRow};
		 # my ( $row_min, $row_max ) = $sheet->row_range();
		# next if $sheet -> {MinRow} > $sheet -> {MaxRow};
		# say '$sheet->{MaxRow}: '.$sheet->{MaxRow};
		# say '$end: '.$end;
		# # say '$sheet->{MinRow}: '.$sheet->{MinRow};
		# say '$sheet->{MinRow}: '.$row_min;
        # foreach my $row ( $sheet->{MinRow} + 1 .. $sheet->{MaxRow} ) {
        foreach my $row ( $sheet -> {MinRow} +1  .. $sheet -> {MaxRow} ) {
            my $tempperson = {
                id             =>  $sheet->{Cells}[$row][0]->{Val},
                first_name     =>  $sheet->{Cells}[$row][3]->{Val},
                mid_name       =>  $sheet->{Cells}[$row][4]->{Val},
                last_name      =>  $sheet->{Cells}[$row][5]->{Val},
                title          =>  $sheet->{Cells}[$row][1]->{Val},
                prefix         =>  $sheet->{Cells}[$row][2]->{Val},
                suffix         =>  $sheet->{Cells}[$row][6]->{Val},
                nickname       =>  $sheet->{Cells}[$row][7]->{Val},
                father_id      =>  $sheet->{Cells}[$row][8]->{Val},
                mother_id      =>  $sheet->{Cells}[$row][9]->{Val},
                email          =>  $sheet->{Cells}[$row][10]->{Val},
                homepage       =>  $sheet->{Cells}[$row][11] ,
                date_of_birth  =>  $sheet->{Cells}[$row][12]->{Val} ,
                date_of_death  =>  $sheet->{Cells}[$row][13]->{Val},
                gender         =>  $sheet->{Cells}[$row][14]->{Val},
                is_living      =>  $sheet->{Cells}[$row][15]->{Val},
                place_of_birth =>  $sheet->{Cells}[$row][16]->{Val},
                place_of_death =>  $sheet->{Cells}[$row][17]->{Val},
                cemetery       =>  $sheet->{Cells}[$row][18]->{Val},
                schools        => ( defined $sheet->{Cells}[$row][19] )
                ? [ split( /,/, $sheet->{Cells}[$row][19]->{Val} ) ]
                : undef,
                jobs => ( defined $sheet->{Cells}[$row][20] )
                ? [ split( /,/,  $sheet->{Cells}[$row][20]->{Val}  ) ]
                : undef,
                work_places => ( defined $sheet->{Cells}[$row][21] )
                ? [ split( /,/,  $sheet->{Cells}[$row][21]->{Val}  ) ]
                : undef,
                places_of_living =>  $sheet->{Cells}[$row][22]->{Val},
                general          =>  $sheet->{Cells}[$row][23]->{Val}
            };
			print Dumper $tempperson;
            # $family_tree_data->add_person($tempperson);
        }
    }
# my $workbook = $parser->parse("mishin_family.xls.xlsx");
# see Spreadsheet::ParseExcel for further documentation


sub convertCell {
    my ($cell) = @_;
	 # return $cell;
    # return undef unless defined $cell;
    # my $rowtxt = '';
    # if ( !$cell ) {
        # $rowtxt = "\t";

        # # next;
    # }
    my $val = $cell->{Val};
    # if ( !defined($val) or $val eq '' ) {
        # $rowtxt = "\t";

        # # next;
    # }
    # $val = decode( "UTF-16BE", $val ) if ( $cell->{Code} eq 'ucs2' );
    # $val =~ s/^\s+//;
    # $val =~ s/\s+$//;
    # if ( $val eq '' ) {
        # $rowtxt = "\t";
        # next;
    # }
    # $rowtxt = "$val";

    return $val;#$rowtxt;

# return $cell->{Val} if( $cell->{Type} eq "Numeric" );
# return $cell->{Val} unless( defined $cell->{Code} );
# use Encode qw(decode encode);
# $characters = decode('UTF-8', $octets,     Encode::FB_CROAK);
# return  decode('UTF-8',$cell->{Val},Encode::FB_CROAK);#decode('UTF-16LE', $cell->{Val});
# Encode::from_to( $cell->{Val}, "utf8", "utf16le" );
}