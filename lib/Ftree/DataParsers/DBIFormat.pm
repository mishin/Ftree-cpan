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

package Ftree::DataParsers::DBIFormat;

use strict;
use warnings;
use version; our $VERSION = qv('2.3.31');

use Ftree::FamilyTreeData;
use Params::Validate qw(:all);
use Ftree::DataParsers::ExtendedSimonWardFormat; # for getting pictures. Temporal solution
use DBI;
use Ftree::DataParsers::FieldValidatorParser;
# use CGI::Carp qw(fatalsToBrowser);

my $picture_directory;

sub _get_date {
  my $DBIdate = shift;
  return undef if(! defined $DBIdate || $DBIdate eq "0000-00-00 00:00:00");
  if($DBIdate =~ m/(\d\d\d\d)-(\d\d)-(\d\d)/) {
    return "$3/$2/$1";
  }
  return undef;
}
# return: 0, in case of file open error
sub getFamilyTreeData {
  my ($config_) = @_;
  
  my $family_tree_data = Ftree::FamilyTreeData->new();

  #this may be a security hole!!! config parameters can be obtained directly!!!
  my $datasource_name = $config_->{datasource_name} 
    or die "No datasource_name is given in config";
  my $db_user_name = $config_->{db_user_name}
    or die "No db_user_name is given in config";
  my $db_password = $config_->{db_password}
    or die "No db_password is given in config";
  my $db_table = $config_->{db_table}
    or die "No db_table is given in config";
    
  my $dbh = DBI->connect($datasource_name, $db_user_name, $db_password)
    or die "Couldn't connect to database: " . DBI->errstr;    
  my $sth = $dbh->prepare('SELECT * FROM ' . $db_table)
    or die "Couldn't prepare statement: " . $dbh->errstr;
  $sth->execute() or die "Couldn't execute statement: " . $sth->errstr;    
  my $column_mapping = $config_->{column_mapping};
  
  while (my $row_href = $sth->fetchrow_hashref){
    $family_tree_data->add_person({
          id => $row_href->{$column_mapping->{id}},
          first_name => $row_href->{$column_mapping->{first_name}},
          mid_name   => (defined $column_mapping->{mid_name}) ? 
                  $row_href->{$column_mapping->{mid_name}} : undef,
          last_name  => $row_href->{$column_mapping->{last_name}},
          title      => (defined $column_mapping->{title}) ? 
                  $row_href->{$column_mapping->{title}} : undef,
          prefix     => (defined $column_mapping->{prefix}) ? 
                  $row_href->{$column_mapping->{prefix}}  : undef,
          suffix     => (defined $column_mapping->{suffix}) ?
                  $row_href->{$column_mapping->{suffix}} : undef,
          nickname   => (defined $column_mapping->{nickname}) ?
                  $row_href->{$column_mapping->{nickname}} : undef,
          father_id  => $row_href->{$column_mapping->{father_id}},
          mother_id  => $row_href->{$column_mapping->{mother_id}},
          email      => (defined $column_mapping->{email}) ?
                  $row_href->{$column_mapping->{email}} : undef,
          homepage   => (defined $column_mapping->{homepage}) ?
                  $row_href->{$column_mapping->{homepage}} : undef,
          date_of_birth => (defined $column_mapping->{date_of_birth}) ?
                  _get_date($row_href->{$column_mapping->{date_of_birth}}) : undef,          
          date_of_death => (defined $column_mapping->{date_of_death}) ?
                  _get_date($row_href->{$column_mapping->{date_of_death}}) : undef,
          gender     => (defined $column_mapping->{gender}) ?
                  $row_href->{$column_mapping->{gender}} : undef,
          is_living  => (defined $column_mapping->{is_living}) ?
                  $row_href->{$column_mapping->{is_living}} : undef,
          place_of_birth => (defined $column_mapping->{place_of_birth}) ?
                  $row_href->{$column_mapping->{place_of_birth}} : undef,
          place_of_death => (defined $column_mapping->{place_of_death}) ?
                  $row_href->{$column_mapping->{place_of_death}} : undef,
          cemetery   => (defined $column_mapping->{title}) ?
                  $row_href->{$column_mapping->{title}} : undef,
          schools    => (defined $column_mapping->{schools}) ?
                  [split( /,/, $row_href->{$column_mapping->{schools}})] : undef,
          jobs       => (defined $column_mapping->{jobs}) ?
                  [split( /,/, $row_href->{$column_mapping->{jobs}})] : undef,
          work_places => (defined $column_mapping->{work_places}) ?
                  [split( /,/, $row_href->{$column_mapping->{work_places}} )] : undef,
          places_of_living => (defined $column_mapping->{places_of_living}) ?
                  $row_href->{$column_mapping->{places_of_living}} : undef,
          general    => (defined $column_mapping->{general}) ?
                  $row_href->{$column_mapping->{general}} : undef});          
  }
  $sth->finish;
  $dbh->disconnect;
 
  if (defined $config_->{photo_dir}) {
    Ftree::ExtendedSimonWardFormat::setPictureDirectory($config_->{photo_dir});
    Ftree::ExtendedSimonWardFormat::fill_up_pictures($family_tree_data);    
  }       

  return $family_tree_data;
}

1;

