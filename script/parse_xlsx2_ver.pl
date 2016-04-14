# use Spreadsheet::ParseXLSX;
use     Spreadsheet::Read;
use utf8;
use open qw(:std :utf8);
# my $parser = Spreadsheet::Read::parses ("xlsx");
# print STDERR "# Parser: $parser-", $parser->VERSION, "\n";
use Data::Dumper;
use Data::Printer;
use v5.14;
 # my $file_name='mishin_family.xls.xlsx';
 my $file_name = shift || 'mishin_family.xls.xlsx';

# my $e = new Spreadsheet::ParseExcel;
# my $eBook = $e->Parse($filename);

# p $eBook;
# my $sheets = $eBook->{SheetCount};
# my ($eSheet, $sheetName);
# say "\$sheets: $sheets";
# my $parser = Spreadsheet::ParseXLSX->new;
 my $workbook  = ReadData ($file_name)
  # # my $excel            = Spreadsheet::ParseXLSX->new->parse($file_name)
       or die "Unable to parse file " . $file_name;
# p $workbook;
# say $workbook->[$sheet_number]{label};
# say $workbook->[$sheet_number]{cell}[1][2];
# say $workbook->[$sheet_number]{cell}[1][2];
# say $workbook->[$sheet_number]{cell}[4][2];

    # [0] {
        # error     undef,
        # parser    "Spreadsheet::ParseXLSX",
        # sheet     {
            # Sheet1   1
        # },
        # sheets    1,
        # type      "xlsx",
        # version   0.17
    # },
	  # say Dumper ($excel);
	  # my $sheets = $excel->{SheetCount};
	  # Spreadsheet::ParseXLSX::Workbook->Parse($file_name)
	  # @{ $excel->{sheets}
#   foreach my $sheet_number ( 1 .. $workbook->[0]{sheets} ) {
#    printf("Sheet: %s\n", $sheet->{Name});
#
#       $sheet -> {MaxRow} ||= $sheet -> {MinRow};
#
#   # say "\$sheet_number: $sheet_number";
#   	# my $start=$workbook->[$sheet_number]{minrow}+1;
#		# my $end=$workbook->[$sheet_number]{maxrow};
#		# say "\$start: $start .. \$end: $end";
#		  foreach my $row ($sheet -> {MinRow}+1 .. $sheet -> {MaxRow}) {
#        # foreach my $row ( $start .. $end ) {
#
#            my $tempperson = {
#                id             =>  $workbook->[$sheet_number]{cell}[1][$row] ,
#                first_name     =>  $workbook->[$sheet_number]{cell}[4][$row] ,
#                mid_name       =>  $workbook->[$sheet_number]{cell}[5][$row] ,
#                last_name      =>  $workbook->[$sheet_number]{cell}[6][$row] ,
#                title          =>  $workbook->[$sheet_number]{cell}[2][$row] ,
#                prefix         =>  $workbook->[$sheet_number]{cell}[3][$row] ,
#                suffix         =>  $workbook->[$sheet_number]{cell}[7][$row] ,
#                nickname       =>  $workbook->[$sheet_number]{cell}[8][$row] ,
#                father_id      =>  $workbook->[$sheet_number]{cell}[9][$row] ,
#                mother_id      =>  $workbook->[$sheet_number]{cell}[10][$row] ,
#                email          =>  $workbook->[$sheet_number]{cell}[11][$row] ,
#                homepage       =>  $workbook->[$sheet_number]{cell}[12][$row] ,
#                date_of_birth  =>  $workbook->[$sheet_number]{cell}[13][$row] ,
#                date_of_death  =>  $workbook->[$sheet_number]{cell}[14][$row] ,
#                gender         =>  $workbook->[$sheet_number]{cell}[15][$row] ,
#                is_living      =>  $workbook->[$sheet_number]{cell}[16][$row] ,
#                place_of_birth =>  $workbook->[$sheet_number]{cell}[17][$row] ,
#                place_of_death =>  $workbook->[$sheet_number]{cell}[18][$row] ,
#                cemetery       =>  $workbook->[$sheet_number]{cell}[19][$row] ,
#                schools        => ( defined $workbook->[$sheet_number]{cell}[20][$row] )
#                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[20][$row] ) ]
#                : undef,
#                jobs => ( defined $workbook->[$sheet_number]{cell}[21][$row] )
#                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[21][$row] ) ]
#                : undef,
#                work_places => ( defined $workbook->[$sheet_number]{cell}[22][$row] )
#                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[22][$row] ) ]
#                : undef,
#                places_of_living =>  $workbook->[$sheet_number]{cell}[23][$row] ,
#                general          =>  $workbook->[$sheet_number]{cell}[24][$row]
#            };
#			say Dumper $tempperson;
#            # $family_tree_data->add_person($tempperson);
#        }
#     }
## my $workbook = $parser->parse("mishin_family.xls.xlsx");
## see Spreadsheet::ParseExcel for further documentation
#
#
## sub convertCell {
#    # my ($cell) = @_;
#	 # # return $cell;
#    # # return undef unless defined $cell;
#    # # my $rowtxt = '';
#    # # if ( !$cell ) {
#        # # $rowtxt = "\t";
#
#        # # # next;
#    # # }
#    # my $val = $cell->{Val};
#    # # if ( !defined($val) or $val eq '' ) {
#        # # $rowtxt = "\t";
#
#        # # # next;
#    # # }
#    # # $val = decode( "UTF-16BE", $val ) if ( $cell->{Code} eq 'ucs2' );
#    # # $val =~ s/^\s+//;
#    # # $val =~ s/\s+$//;
#    # # if ( $val eq '' ) {
#        # # $rowtxt = "\t";
#        # # next;
#    # # }
#    # # $rowtxt = "$val";
#
#    # return $val;#$rowtxt;
#
## # return $cell->{Val} if( $cell->{Type} eq "Numeric" );
## # return $cell->{Val} unless( defined $cell->{Code} );
## # use Encode qw(decode encode);
## # $characters = decode('UTF-8', $octets,     Encode::FB_CROAK);
## # return  decode('UTF-8',$cell->{Val},Encode::FB_CROAK);#decode('UTF-16LE', $cell->{Val});
## # Encode::from_to( $cell->{Val}, "utf8", "utf16le" );
## }