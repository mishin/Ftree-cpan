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


package ExcelFormat;
use Spreadsheet::ParseExcel;
use DataParsers::ExtendedSimonWardFormat; # for getting pictures. Temporal solution
use FamilyTreeData;
use CGI::Carp qw(fatalsToBrowser);
use Encode qw(decode);


sub createFamilyTreeDataFromFile {
  my ($config_) = @_;
  my $file_name = $config_->{file_name} or die "No file_name is given in config";
    
  my $family_tree_data = FamilyTreeData->new();
  my $excel = Spreadsheet::ParseExcel::Workbook->Parse($file_name)
    or die "Unable to parse file " . $file_name;
  foreach my $sheet (@{$excel->{Worksheet}}) {
    $sheet->{MaxRow} ||= $sheet->{MinRow};
    foreach my $row ($sheet->{MinRow}+1 .. $sheet->{MaxRow}) {
       my $tempperson = {
          id => convertCell($sheet->{Cells}[$row][0]),
          first_name => convertCell($sheet->{Cells}[$row][3]),
          mid_name   => convertCell($sheet->{Cells}[$row][4]),
          last_name  => convertCell($sheet->{Cells}[$row][5]),
          title      => convertCell($sheet->{Cells}[$row][1]),
          prefix     => convertCell($sheet->{Cells}[$row][2]),
          suffix     => convertCell($sheet->{Cells}[$row][6]),
          nickname   => convertCell($sheet->{Cells}[$row][7]),
          father_id  => convertCell($sheet->{Cells}[$row][8]),
          mother_id  => convertCell($sheet->{Cells}[$row][9]),
          email      => convertCell($sheet->{Cells}[$row][10]),
          homepage   => convertCell($sheet->{Cells}[$row][11]),
          date_of_birth => convertCell($sheet->{Cells}[$row][12]),          
          date_of_death => convertCell($sheet->{Cells}[$row][13]),
          gender     => convertCell($sheet->{Cells}[$row][14]),
          is_living  => convertCell($sheet->{Cells}[$row][15]),
          place_of_birth => convertCell($sheet->{Cells}[$row][16]),
          place_of_death => convertCell($sheet->{Cells}[$row][17]),
          cemetery   => convertCell($sheet->{Cells}[$row][18]),
          schools    => (defined $sheet->{Cells}[$row][19]) ?
            [split( /,/, convertCell($sheet->{Cells}[$row][19]))] : undef,
          jobs       => (defined $sheet->{Cells}[$row][20]) ?
            [split( /,/, convertCell($sheet->{Cells}[$row][20]))] : undef,
          work_places => (defined $sheet->{Cells}[$row][21]) ? 
            [split( /,/, convertCell($sheet->{Cells}[$row][21]))] : undef,
          places_of_living => convertCell($sheet->{Cells}[$row][22]),
          general    => convertCell($sheet->{Cells}[$row][23])};
       $family_tree_data->add_person($tempperson);
    }
  }
  if (defined $config_->{photo_dir}) {
    ExtendedSimonWardFormat::setPictureDirectory($config_->{photo_dir});
    ExtendedSimonWardFormat::fill_up_pictures($family_tree_data);
  }
  
  return $family_tree_data;
}

sub convertCell {
	my ($cell) = @_;
	return undef unless defined $cell;
	return $cell->{Val} if( $cell->{Type} eq "Numeric" );
	return $cell->{Val} unless( defined $cell->{Code} );
	  # use Encode qw(decode encode);
    # $characters = decode('UTF-8', $octets,     Encode::FB_CROAK);
	return  decode('UTF-8',$cell->{Val},Encode::FB_CROAK);#decode('UTF-16LE', $cell->{Val});	
	# Encode::from_to( $cell->{Val}, "utf8", "utf16le" );
}

1;
