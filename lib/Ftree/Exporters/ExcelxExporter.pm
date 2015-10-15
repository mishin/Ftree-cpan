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

package ExcelxExporter;

use strict;
use warnings;
use version; our $VERSION = qv('2.3.31');
# use Spreadsheet::WriteExcel;
use Excel::Writer::XLSX;

sub export {
  my ($filename, $family_tree_data) = @_;
  my $workbook = Excel::Writer::XLSX->new($filename);
  my $worksheet = $workbook->add_worksheet();
  my @header = ('ID', 'title', 'prefix', 'first name', 'midname', 'last name', 'suffix',
    'nickname', 'father\'s ID', 'mother\'s ID', 'email',	'webpage', 'date of birth', 'date of death',
    'gender', 'is living?', 'place of birth', 'place of death', 'cemetery', 'schools', 'jobs',
    'work places', 'places of living', 'general' );
  $worksheet->write_row(0, 0, \@header);
  my $row = 1;
  foreach my $person (values %{$family_tree_data->{people}}) {
  	if(defined $person) {
    my @person_row = ();
    push @person_row, $person->get_id();
    
    if(defined $person->get_name()) {
     push @person_row, ($person->get_name()->get_title(), 
      $person->get_name()->get_prefix(), $person->get_name()->get_first_name(),
      $person->get_name()->get_mid_name(), $person->get_name()->get_last_name(), 
      $person->get_name()->get_suffix(), $person->get_name()->get_nickname())
    }
    else {
    	push @person_row, (undef, undef, undef, undef, undef, undef, undef)
    }
    push @person_row, (defined $person->get_father()) ? $person->get_father()->get_id() : undef; 
    push @person_row, (defined $person->get_mother()) ? $person->get_mother()->get_id() : undef; 
    push @person_row, ($person->get_email(), $person->get_homepage());
      
    my $date = "";
    if(defined $person->get_date_of_birth()) {
      my $date_of_birth = $person->get_date_of_birth();
      $date .= defined $date_of_birth->day ? $date_of_birth->day."/" : "";
      $date .= defined $date_of_birth->month ? $date_of_birth->month."/" : "";
      $date .= defined $date_of_birth->year ? $date_of_birth->year : "";
    }
    push @person_row, $date;
    
    $date = "";  
    if(defined $person->get_date_of_death()) {
      my $date_of_death = $person->get_date_of_death();
      $date .= defined $date_of_death->day ? $date_of_death->day."/" : "";
      $date .= defined $date_of_death->month ? $date_of_death->month."/" : "";
      $date .= defined $date_of_death->year ? $date_of_death->year : "";
    }
    push @person_row, $date;
    push @person_row, ($person->get_gender(), $person->get_is_living(), 
      getPlaceString($person->get_place_of_birth()), getPlaceString($person->get_place_of_death()));
    
    my $cemetery = "";
    if (defined $person->get_cemetery()) {
      $cemetery .= '"' . $person->get_cemetery()->{country} .'"';
      $cemetery .= defined $person->get_cemetery()->{city} ? ' "' . 
        $person->get_cemetery->{city} . '"' : "";
      $cemetery .= defined $person->get_cemetery()->{cemetery} ? ' "' . 
        $person->get_cemetery->{cemetery} . '"' : "";
    }
    push @person_row, ($cemetery, defined $person->get_schools() ? 
      join(',', @{$person->get_schools()}) : "", 
      defined $person->get_jobs() ? join(',', @{$person->get_jobs()}) : "", 
      defined $person->get_work_places() ? join(',', @{$person->get_work_places()}) : "",
      defined $person->get_places_of_living() ? 
        join(',', map {getPlaceString($_)} @{$person->get_places_of_living()} ) : "",
      $person->get_general() );
    $worksheet->write_row($row, 0, \@person_row);
    ++$row;
  	}
  }
}
sub getPlaceString {
  my ($place) = @_;
  my $place_string = "";
  if (defined $place) {
      $place_string .= "\"$place->{country}\"";
      $place_string .= defined $place->{city} ? " \"$place->{city}\"" : "";
   }
   return $place_string;
    
}
1;
