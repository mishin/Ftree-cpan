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


package SerializerFormat;
use strict;
use warnings;
use version; our $VERSION = qv('2.3.29');
use Ftree::DataParsers::FieldValidatorParser;
use Ftree::DataParsers::ExtendedSimonWardFormat; # for getting pictures. Temporal solution
use Ftree::FamilyTreeData;
use Storable;
use CGI::Carp qw(fatalsToBrowser);

sub createFamilyTreeDataFromFile {
  my ($config_) = @_;
  my $file_name = $config_->{file_name} or die "No file_name is given in config";

  my $family_tree_data = Storable::retrieve($file_name);
  if(defined $config_->{photo_dir}) {
    Ftree::ExtendedSimonWardFormat::setPictureDirectory($config_->{photo_dir});
    Ftree::ExtendedSimonWardFormat::fill_up_pictures($family_tree_data);
  }
  
  return $family_tree_data;
}

1;
