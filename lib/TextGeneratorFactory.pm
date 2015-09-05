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

package TextGeneratorFactory;
use strict;
use warnings;

use Perl6::Export::Attrs;
use Switch;

my $language = "gb";
my %langToPict = (
    hungarian => "hu",    
    english => "gb",
    german => "de",
#    spanish => "es",
    italian => "it",    
    french => "fr",
    polish => "pl",
    romanian => "ro",
    russian => "ru",
#    slovenian => "si",
#    japanese => "jp",
#    chinese => "cn",
);
my $reverse_name = 0;

sub init : Export{
  ( $language ) = @_;	
}

sub getLangToPict : Export{
  return %langToPict;
}
sub get_reverse_name : Export{
  return $reverse_name;
}

sub getTextGenerator : Export{
  switch ($language) {
    case "hu" {
      $reverse_name = 1;;
      require TextGenerators::HungarianTextGenerator;
      return HungarianTextGenerator->new( ); 
    }
    case "gb" {
      require TextGenerators::EnglishTextGenerator; 
      return EnglishTextGenerator->new( ); 
    }
    case "de" {
      require TextGenerators::GermanTextGenerator; 
      return GermanTextGenerator->new( ); 
    }
    case "fr" {
      require TextGenerators::FrenchTextGenerator; 
      return FrenchTextGenerator->new( ); 
    }
    case "pl" {
      require TextGenerators::PolishTextGenerator; 
      return PolishTextGenerator->new( ); 
    }
    case "it" {
      require TextGenerators::ItalianTextGenerator; 
      return ItalianTextGenerator->new( ); 
    }
    case "ro" {
      require TextGenerators::RomanianTextGenerator; 
      return RomanianTextGenerator->new( ); 
    }
    case "ru" {
      require TextGenerators::RussianTextGenerator; 
      return RussianTextGenerator->new( ); 
    }
    else {
      require TextGenerators::EnglishTextGenerator;
      EnglishTextGenerator->new( );
    }
  } 
}

1;
