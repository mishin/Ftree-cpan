 #!/usr/bin/perl -w

    use strict;
	use utf8;
	use open qw/:std :utf8/;
    use Spreadsheet::ParseExcel;
    use Spreadsheet::ParseExcel::FmtJapan;

    my $parser    = Spreadsheet::ParseExcel->new();
    my $formatter = Spreadsheet::ParseExcel::FmtJapan->new();
    my $workbook  = $parser->parse('mishin_family.xls', $formatter);

    if ( !defined $workbook ) {
        die $parser->error(), ".\n";
    }

    for my $worksheet ( $workbook->worksheets() ) {

        print "Worksheet name: ", $worksheet->get_name(), "\n\n";

        my ( $row_min, $row_max ) = $worksheet->row_range();
        my ( $col_min, $col_max ) = $worksheet->col_range();

        for my $row ( $row_min .. $row_max ) {
            for my $col ( $col_min .. $col_max ) {

                my $cell = $worksheet->get_cell( $row, $col );
                next unless $cell;

				 # my $val = $cell->{Val};
            # if ( !defined( $val ) or $val eq '' ) {
                # $rowtxt .= "\t";
                # next;
            # }
            # $val = decode( "UTF-16BE", $val ) if ( $cell->{Code} eq 'ucs2' );
				  print $cell->value()."\n";
                # Do something with $cell->value() and remember to encode
                # any output streams if required.

            }
        }
    }
    __END__