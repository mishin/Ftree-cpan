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

package Ftree::DataParsers::ArrayImporters::CSVArrayImporter;
use strict;
use warnings;
use version; our $VERSION = qv('2.3.39');
use Params::Validate qw(:all);
# use CGI::Carp qw(fatalsToBrowser);
my $fh;

sub new {
    my ($classname, $file_name, $encoding) = @_;
	my $self = {
    	current_line => undef,
  };
  open $fh, "<:encoding($encoding)", "$file_name"
     or die "Unable to open datafile $file_name";
  $self->{current_line} = <$fh>;
  return bless $self, $classname;
}
sub hasNext {
	my ($self) = validate_pos(@_, {type => HASHREF});
	return $self->{current_line};
}
sub next {
	my ($self) = validate_pos(@_, {type => HASHREF});
	my $prevline = $self->{current_line};
	do {
		$self->{current_line} = <$fh>;
	}
	while($self->{current_line} && $self->{current_line} =~ m/^\s*\#/x);  # skip comments


	chomp($prevline);
	return split( /;/, $prevline);
}
sub close {
	my ($self) = validate_pos(@_, {type => HASHREF});
	close($fh) or die "Unable to close datafile";
}

1;
