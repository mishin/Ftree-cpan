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

package Ftree::FamilyTreeDataFactory;
use strict;
use warnings;

use Switch;
use CGI::Carp qw(fatalsToBrowser);

sub getFamilyTree {
  my ( $config ) = @_;
  my $type = $config->{type};
  $type = 'csv' if ($type eq 'txt');
  
  switch ($type) {
  	case 'csv' {
  	  require Ftree::DataParsers::ExtendedSimonWardFormat;
  	  return ExtendedSimonWardFormat::createFamilyTreeDataFromFile($config->{config});
  	}
  	case 'excel' {
  	  require Ftree::DataParsers::ExcelFormat;
  	  return ExcelFormat::createFamilyTreeDataFromFile($config->{config});
  	}
	case 'excelx' {
  	  require Ftree::DataParsers::ExcelxFormat;
  	  return ExcelxFormat::createFamilyTreeDataFromFile($config->{config});
  	}
    case 'ser' {
      require Ftree::DataParsers::SerializerFormat;
      return SerializerFormat::createFamilyTreeDataFromFile($config->{config});
    }
  	case 'gedcom' {
  	  require Ftree::DataParsers::GedcomFormat;
  	  return GedcomFormat::createFamilyTreeDataFromFile($config->{config});
  	  }
  	case 'dbi' {
      require Ftree::DataParsers::DBIFormat;
      return DBIFormat::getFamilyTreeData($config->{config});
    }
  	else {croak "Unknown type: $type" }
  }
  
  return;
}

1;
