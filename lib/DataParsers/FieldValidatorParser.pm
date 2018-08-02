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


package FieldValidatorParser;
use Date::Tiny;
use Place;
use Cemetery;
use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser warningsToBrowser);
use StringUtils;

my %month_array = (
  january => 1, 
  february => 2, 
  march => 3, 
  april => 4, 
  may => 5, 
  june => 6,
  july => 7, 
  august => 8, 
  september => 9, 
  october => 10, 
  november => 11, 
  december => 12);
  

my $id_regexp = qr/\w+/;   
sub validIDEntry {
	my ( $entry ) = @_;
	return defined $entry && $entry ne "" && $entry =~ m/$id_regexp/;
}

my $email_regexp = qr/^[^@]+@([-\w]+\.)+[A-Za-z]{2,4}$/; 
sub validEmail {
	my ( $entry ) = @_;
	return defined $entry && $entry ne "" && $entry =~ m/$email_regexp/;
}

my $url_regexp = qr/^https?:.*/;
sub validURL {
	my ( $entry ) = @_;
	return defined $entry && $entry ne "" && $entry =~ m/$url_regexp/;
}
sub validYear {
  my ($year) = @_;
  my $this_year = 1900 + (localtime)[5];
  if ($year > $this_year) {
    warn "Strange year: $year. Year cannot be larger than $this_year";
    return;
  }
  if($year != int($year)) {
    warn "Strange year: $year. Year should be an integer";
    return;
  }
  return 1;  
}

sub validMonth {
  my ($month) = @_;
  if ($month >=1 && $month <= 12 || $month_array{lc($month)}) {
    return 1;
  }
  warn "Strange month: $month. Month should be be between 1 and 12 or"
    . " the name of the month in english";
  return;
}

my $bool_regexp = qr/^[01]/;
sub validBool {
  my ($entry) = @_;
  return defined $entry && $entry ne "" && $entry =~ m/$bool_regexp/;
}

sub getDate {
   my ($date) = @_;
   my @date_a = split( '/', $date );
   if(scalar @date_a == 1) {
     if(validYear($date_a[0])) { #speed up needed!! 
      return Date::Tiny->new(year  => $date_a[0]);
     } else {
       return;
     }
   }
   elsif(scalar @date_a == 2) {
     $date_a[0] = lc($date_a[0]);
     if(validYear($date_a[1]) && validMonth($date_a[0])) {
       return Date::Tiny->new(month => defined $month_array{$date_a[0]} ? $month_array{$date_a[0]} : $date_a[0],
        year  => $date_a[1]);
     } else {
       return;
     }
     
   }
   elsif(scalar @date_a == 3) {
     $date_a[1] = lc($date_a[1]);
     if(validYear($date_a[2]) && validMonth($date_a[1])) {
      return Date::Tiny->new(day => $date_a[0],
          month => defined $month_array{$date_a[1]} ? $month_array{$date_a[1]} : $date_a[1],
          year  => $date_a[2]);
     }
     else {
       return;
     }
   }
   else {
     return;
   }
}
sub getCemetery {
  my ($field) = @_;
  if(defined $field && $field ne "") {
    $field = Ftree::StringUtils::trim($field);
    if($field =~ /"(\S.+)"\s+"(\S.+)"\s+"(\S.+)"/) {
      return Ftree::Cemetery->new($1, $2, $3);
    }
    if($field =~ /"(\S.+)"\s+"(\S.+)"/) {
      return Ftree::Cemetery->new($1, $2, undef);
    }
    if($field =~ /"(\S.+)"/) {
      return Ftree::Cemetery->new($1, undef, undef);
    }
    warn "Nonvalid cemetery: ". $field . ". It should be like \"Hungary\" \"Budapest\" \"Farkasréti\"";
  }
  return;
}
sub getPlace {
  my ($field) = @_;
  if(defined $field && $field ne "") {
    $field = Ftree::StringUtils::trim($field);
    if($field =~ /"(\S.+)"\s+"(\S.+)"/) {
      return Ftree::Place->new($1, $2);
    }
    elsif($field =~ /"(\S.+)"/) {
      return Ftree::Place->new($1, undef);
    }
    else {
      warn "Nonvalid place: ". $field . ". It should be like \"Hungary\" \"Budapest\" ";
      return;
    }
  }
  else {
    return;
  }
}

sub getPlacesArray {
  my ($places_string) = @_;
  my @pair_array = split(/,/, $places_string);
  my @places_array;
  for (@pair_array) {
    my $a_place = getPlace($_);
    push @places_array, $a_place if(defined $a_place);
  }
  return \@places_array;
}


1;