<<<<<<< HEAD
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
  	  return Ftree::DataParsers::ExtendedSimonWardFormat::createFamilyTreeDataFromFile($config->{config});
  	}
  	case 'excel' {
  	  require Ftree::DataParsers::ExcelFormat;
  	  return Ftree::DataParsers::ExcelFormat::createFamilyTreeDataFromFile($config->{config});
  	}
	case 'excelx' {
  	  require Ftree::DataParsers::ExcelxFormat;
  	  return Ftree::DataParsers::ExcelxFormat::createFamilyTreeDataFromFile($config->{config});
  	}
    case 'ser' {
      require Ftree::DataParsers::SerializerFormat;
      return Ftree::DataParsers::SerializerFormat::createFamilyTreeDataFromFile($config->{config});
    }
  	case 'gedcom' {
  	  require Ftree::DataParsers::GedcomFormat;
  	  return Ftree::DataParsers::GedcomFormat::createFamilyTreeDataFromFile($config->{config});
  	  }
  	case 'dbi' {
      require Ftree::DataParsers::DBIFormat;
      return Ftree::DataParsers::DBIFormat::getFamilyTreeData($config->{config});
    }
  	else {croak "Unknown type: $type" }
  }
  
  return;
}

1;
=======
package Ftree::FamilyTreeDataFactory;
use strict;
use warnings;
use version; our $VERSION = qv('2.3.41');
use v5.10.1;
use experimental 'smartmatch';

sub getFamilyTree {
	my ($config) = @_;
	my $type = $config->{type};
	$type = 'csv' if ( $type eq 'txt' );

	given ($type) {
		when (/\bcsv\b/) {
			require Ftree::DataParsers::ExtendedSimonWardFormat;
			return
			  Ftree::DataParsers::ExtendedSimonWardFormat::createFamilyTreeDataFromFile(
				$config->{config} );
		}
		when (/\bexcel\b/) {
			require Ftree::DataParsers::ExcelFormat;
			return
			  Ftree::DataParsers::ExcelFormat::createFamilyTreeDataFromFile(
				$config->{config} );
		}
		when (/\bexcelx\b/) {
			require Ftree::DataParsers::ExcelxFormat;
			return
			  Ftree::DataParsers::ExcelxFormat::createFamilyTreeDataFromFile(
				$config->{config} );
		}
		when (/\bser\b/) {
			require Ftree::DataParsers::SerializerFormat;
			return
			  Ftree::DataParsers::SerializerFormat::createFamilyTreeDataFromFile(
				$config->{config} );
		}
		when (/\bgedcom\b/) {
			require Ftree::DataParsers::GedcomFormat;
			return
			  Ftree::DataParsers::GedcomFormat::createFamilyTreeDataFromFile(
				$config->{config} );
		}
		when (/\bdbi\b/) {
			require Ftree::DataParsers::DBIFormat;
			return Ftree::DataParsers::DBIFormat::getFamilyTreeData(
				$config->{config} );
		}
		default { die "Unknown type: $type" }
	}

	return;
}

1;
>>>>>>> refs/heads/master
