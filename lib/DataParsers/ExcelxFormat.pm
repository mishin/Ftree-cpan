#######################################################
#
# Family Tree generation program, v2.0
# Written by Ferenc Bodon and Simon Ward, March 2000 (simonward.com)
# Copyright (C) 2000 Ferenc Bodon, Simon K Ward
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# For a copy of the GNU General Public License, visit
# http://www.gnu.org or write to the Free Software Foundation, Inc.,
# 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#
#######################################################

package ExcelxFormat;

# use Spreadsheet::ParseXLSX;
# use Spreadsheet::Read;
use Spreadsheet::XLSX;
# use Spreadsheet::ParseExcel;
use DataParsers::ExtendedSimonWardFormat
  ;    # for getting pictures. Temporal solution
use FamilyTreeData;
use CGI::Carp qw(fatalsToBrowser);
use Encode qw(decode);

sub createFamilyTreeDataFromFile {
    my ($config_) = @_;
    my $file_name = $config_->{file_name}
      or die "No file_name is given in config";

    my $family_tree_data = FamilyTreeData->new();
	my $excel = Spreadsheet::XLSX -> new ( $file_name);#, $converter);
    # my $workbook         = ReadData($file_name)
      # or die "Unable to parse file " . $file_name;

    # my $excel            = Spreadsheet::ParseXLSX->new->parse($file_name);
    # Spreadsheet::ParseXLSX::Workbook->Parse($file_name)
    # or die "Unable to parse file " . $file_name;
      foreach my $row ($sheet -> {MinRow}+1 .. $sheet -> {MaxRow}) {
        # foreach my $row ( $start .. $end ) {
		
            my $tempperson = {
                id             =>  $workbook->[$sheet_number]{cell}[1][$row] ,
                first_name     =>  $workbook->[$sheet_number]{cell}[4][$row] ,
                mid_name       =>  $workbook->[$sheet_number]{cell}[5][$row] ,
                last_name      =>  $workbook->[$sheet_number]{cell}[6][$row] ,
                title          =>  $workbook->[$sheet_number]{cell}[2][$row] ,
                prefix         =>  $workbook->[$sheet_number]{cell}[3][$row] ,
                suffix         =>  $workbook->[$sheet_number]{cell}[7][$row] ,
                nickname       =>  $workbook->[$sheet_number]{cell}[8][$row] ,
                father_id      =>  $workbook->[$sheet_number]{cell}[9][$row] ,
                mother_id      =>  $workbook->[$sheet_number]{cell}[10][$row] ,
                email          =>  $workbook->[$sheet_number]{cell}[11][$row] ,
                homepage       =>  $workbook->[$sheet_number]{cell}[12][$row] ,
                date_of_birth  =>  $workbook->[$sheet_number]{cell}[13][$row] ,
                date_of_death  =>  $workbook->[$sheet_number]{cell}[14][$row] ,
                gender         =>  $workbook->[$sheet_number]{cell}[15][$row] ,
                is_living      =>  $workbook->[$sheet_number]{cell}[16][$row] ,
                place_of_birth =>  $workbook->[$sheet_number]{cell}[17][$row] ,
                place_of_death =>  $workbook->[$sheet_number]{cell}[18][$row] ,
                cemetery       =>  $workbook->[$sheet_number]{cell}[19][$row] ,
                schools        => ( defined $workbook->[$sheet_number]{cell}[20][$row] )
                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[20][$row] ) ]
                : undef,
                jobs => ( defined $workbook->[$sheet_number]{cell}[21][$row] )
                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[21][$row] ) ]
                : undef,
                work_places => ( defined $workbook->[$sheet_number]{cell}[22][$row] )
                ? [ split( /,/,  $workbook->[$sheet_number]{cell}[22][$row] ) ]
                : undef,
                places_of_living =>  $workbook->[$sheet_number]{cell}[23][$row] ,
                general          =>  $workbook->[$sheet_number]{cell}[24][$row] 
            };
			# say Dumper $tempperson;
            $family_tree_data->add_person($tempperson);
        }
     }
    if ( defined $config_->{photo_dir} ) {
        ExtendedSimonWardFormat::setPictureDirectory( $config_->{photo_dir} );
        ExtendedSimonWardFormat::fill_up_pictures($family_tree_data);
    }

    return $family_tree_data;
}

1;
