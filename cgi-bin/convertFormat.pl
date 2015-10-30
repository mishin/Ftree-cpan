#!/usr/bin/perl -w

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

use lib ('cgi', 'cgi/lib');
use Free::FamilyTreeDataFactory;
use Switch;
use utf8;

my $input_file_name = $ARGV[0];
my $output_file_name = $ARGV[1];

if(!defined $input_file_name || !defined $output_file_name) {
  print "usage: $0 input_file_name output_file_name\n",
    "some examples:\n",
    "  $0 tree.txt tree.xls\n",
    "  $0 tree.xls tree.ser\n",
    "  $0 tree.xlsx tree.ser\n",
}
else {
  my %type_hash = (
    csv => "csv",
    txt => "csv",
    xls => "excel",
    xlsx => "excelx",
    ged => "gedcom",
    ser => "ser",
  );
  my $input_extension = (split(/\./, $input_file_name))[-1];
  my %config = (
    type => $type_hash{$input_extension},
    config => {
      file_name => $input_file_name,
    }    
  );
  
  
  my $family_tree = FamilyTreeDataFactory::getFamilyTree( \%config );
  my $extension = (split(/\./, $output_file_name))[-1];
  switch ($extension) {
    case "xls" {
      require Exporters::ExcelExporter;
      ExcelExporter::export($output_file_name, $family_tree);
      }
    case "xlsx" {
      require Exporters::ExcelxExporter;
      ExcelxExporter::export($output_file_name, $family_tree);
      }	  
    case "ser" {
      require Exporters::Serializer;
      Serializer::export($output_file_name, $family_tree);
      }
} 
  
}

