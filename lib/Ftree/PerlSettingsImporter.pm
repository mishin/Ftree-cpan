use strict;
use warnings;
use version; our $VERSION = qv('2.3.40');

package Ftree::PerlSettingsImporter;
use Config::General qw(SaveConfig ParseConfig);
sub importSettings {
	my ($config_name) = @_;
	my %config = ParseConfig($config_name);
	return \%config;
}

1;
