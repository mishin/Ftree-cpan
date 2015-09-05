#!/usr/bin/perl -w

package StringUtils;
use strict;
use warnings;
use Params::Validate qw(:all);

# Perl trim function to remove whitespace from the start and end of the string
sub trim
{
	my ($string) = validate_pos(@_, {type => SCALAR|UNDEF});
	return rtrim(ltrim($string)) if (defined $string);
}
# Left trim function to remove leading whitespace
sub ltrim
{
	my ($string) = validate_pos(@_, {type => SCALAR|UNDEF});
	$string =~ s/^\s+//;
	return $string;
}
# Right trim function to remove trailing whitespace
sub rtrim
{
	my ($string) = validate_pos(@_, {type => SCALAR|UNDEF});;
	$string =~ s/\s+$//;
	return $string;
}

1;
