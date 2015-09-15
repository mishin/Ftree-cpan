use Spreadsheet::ParseExcel;
use Encode qw(decode);
use Data::Dumper;
use v5.14;
 my $file_name='mishin_family.xls';
# my $parser = Spreadsheet::ParseXLSX->new;
  # my $excel            = Spreadsheet::ParseXLSX->new->parse($file_name)
      # or die "Unable to parse file " . $file_name;
	  
	      my $excel            = Spreadsheet::ParseExcel::Workbook->Parse($file_name)
      or die "Unable to parse file " . $file_name;
	  # Spreadsheet::ParseXLSX::Workbook->Parse($file_name)
  foreach my $sheet ( @{ $excel->{Worksheet} } ) {
        $sheet->{MaxRow} ||= $sheet->{MinRow};
		say '$sheet->{MaxRow}: '.$sheet->{MaxRow};
		say '$sheet->{MinRow}: '.$sheet->{MinRow};
        foreach my $row ( $sheet->{MinRow} + 1 .. $sheet->{MaxRow} ) {
            my $tempperson = {
                id             => convertCell( $sheet->{Cells}[$row][0] ),
                first_name     => convertCell( $sheet->{Cells}[$row][3] ),
                mid_name       => convertCell( $sheet->{Cells}[$row][4] ),
                last_name      => convertCell( $sheet->{Cells}[$row][5] ),
                title          => convertCell( $sheet->{Cells}[$row][1] ),
                prefix         => convertCell( $sheet->{Cells}[$row][2] ),
                suffix         => convertCell( $sheet->{Cells}[$row][6] ),
                nickname       => convertCell( $sheet->{Cells}[$row][7] ),
                father_id      => convertCell( $sheet->{Cells}[$row][8] ),
                mother_id      => convertCell( $sheet->{Cells}[$row][9] ),
                email          => convertCell( $sheet->{Cells}[$row][10] ),
                homepage       => convertCell( $sheet->{Cells}[$row][11] ),
                date_of_birth  => convertCell( $sheet->{Cells}[$row][12] ),
                date_of_death  => convertCell( $sheet->{Cells}[$row][13] ),
                gender         => convertCell( $sheet->{Cells}[$row][14] ),
                is_living      => convertCell( $sheet->{Cells}[$row][15] ),
                place_of_birth => convertCell( $sheet->{Cells}[$row][16] ),
                place_of_death => convertCell( $sheet->{Cells}[$row][17] ),
                cemetery       => convertCell( $sheet->{Cells}[$row][18] ),
                schools        => ( defined $sheet->{Cells}[$row][19] )
                ? [ split( /,/, convertCell( $sheet->{Cells}[$row][19] ) ) ]
                : undef,
                jobs => ( defined $sheet->{Cells}[$row][20] )
                ? [ split( /,/, convertCell( $sheet->{Cells}[$row][20] ) ) ]
                : undef,
                work_places => ( defined $sheet->{Cells}[$row][21] )
                ? [ split( /,/, convertCell( $sheet->{Cells}[$row][21] ) ) ]
                : undef,
                places_of_living => convertCell( $sheet->{Cells}[$row][22] ),
                general          => convertCell( $sheet->{Cells}[$row][23] )
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
    return undef unless defined $cell;
    my $rowtxt = '';
    if ( !$cell ) {
        $rowtxt = "\t";

        # next;
    }
    my $val = $cell->{Val};
    if ( !defined($val) or $val eq '' ) {
        $rowtxt = "\t";

        # next;
    }
    $val = decode( "UTF-16BE", $val ) if ( $cell->{Code} eq 'ucs2' );
    $val =~ s/^\s+//;
    $val =~ s/\s+$//;
    if ( $val eq '' ) {
        $rowtxt = "\t";
        next;
    }
    $rowtxt = "$val";

    return $rowtxt;

# return $cell->{Val} if( $cell->{Type} eq "Numeric" );
# return $cell->{Val} unless( defined $cell->{Code} );
# use Encode qw(decode encode);
# $characters = decode('UTF-8', $octets,     Encode::FB_CROAK);
# return  decode('UTF-8',$cell->{Val},Encode::FB_CROAK);#decode('UTF-16LE', $cell->{Val});
# Encode::from_to( $cell->{Val}, "utf8", "utf16le" );
}