#!"c:\Users\TOSH\Documents\job\perl\strawberry-perl-5.20.0.1-64bit-portable\perl\bin\perl.exe"
#!"c:\Dwimperl\perl\bin\perl.exe"

#c:\xampp\cgi-bin\ftree\.. 
##!"c:\Dwimperl\perl\bin\perl.exe"

###!"C:\xampp\perl\bin\perl.exe"
use strict;
use warnings;

use CGI qw(param);

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
# 
# What it does:
# * Generates a family tree from a simple underlying data file.
# * A tree can be plotted based around any person in the tree.
# * Any number of levels of ancestors/descendants can be shown,
#   using the zoom in/out buttons.
# * Additional information can be entered about each person:
#      dates, email, web-page for any further info
#
#######################################################
# * Call the script with the following parameters
#   - type (tree, email, bdays, snames, etc)
#   - name (tree will be drawn for this person)
#   - levels (tree will have this no. levels above and below)
#   - password (if a password is required, or "demo")
#   - lang (languages, i.e en, de, hu, it, fr)
# * Pass these parameters or in GET format (like 
#   type=tree;name=fred;levels=1;lang=en;password=dummy)
#
#######################################################
#
# For a demonstration of this software, and details of how the 
# underlying data file is formatted, visit here:
# http://www.cs.bme.hu/~bodon/Simpsons/cgi/ftree.cgi 
#

use FindBin;
use lib "$FindBin::Bin";
use lib "$FindBin::Bin/lib";


my $family_tree;
my $type = CGI::param("type");
if(defined $type && $type eq "tree")
{
   require FamilyTreeGraphics;
   $family_tree = Ftree::FamilyTreeGraphics->new();
}
else {
   require FamilyTreeInfo;
   $family_tree = Ftree::FamilyTreeInfo->new();
}
$family_tree->main();

exit; 

 




