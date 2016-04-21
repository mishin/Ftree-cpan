#!/usr/bin/env perl

=head1 NAME
convert_csv_from_genopro_2_ftree.pl - convert from genopro to ftree csv file
=head1 SYNOPSIS
    perl convert_csv_from_genopro_2_ftree.pl [OPTION]... 
    -v, --verbose  use verbose mode
    --help         print this help message
    --date         date in 'dd.mm.yyyy' format or 'today'
    --message      message for commit
    --file         file for commit or '.'
    --repo_dir     default curr directory or you can pass it from command line
    --debug        only print current git command with formatted date
Examples:
    perl convert_csv_from_genopro_2_ftree.pl --date '15.05.2015' 
	--message 'Hi YAPC Russia 2015' --file 'file2commit'
	--repo_dir "c:\Users\rb102870\Documents\job\svn\04 ETL\01 DATAHUB\01_Backup\02_data"
	--debug=1
=head1 DESCRIPTION
This program need to full holes on github history.
=head1 LICENSE
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
=head1 AUTHOR
=over 1
=item * Nikolay Mishin (L<MISHIN|https://metacpan.org/author/MISHIN>)
=back
=cut

use strict;
use warnings;
use 5.010;
use utf8;
use open qw/:std :utf8/;
use Getopt::Long qw(:config auto_help);
use Pod::Usage;
use Cwd;
use FindBin '$RealBin';

use Modern::Perl;
use DateTime;
use Log::Log4perl qw(:easy);
use IO::Interactive qw(is_interactive);
use Encode::Locale qw(decode_argv);
use Text::CSV;

exit main();

sub main {

&prepare_encoding_console();

my $csv = Text::CSV->new(
    {
        binary           => 1,
        auto_diag        => 1,
        sep_char         => '|',
        allow_whitespace => 1,
    }
);
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
my @result = ();
open( my $data, '<:encoding(utf8)', $file )
  or die "Could not open '$file' $!\n";

while ( my $fields = $csv->parse($data) ) {
    push @result, ( join( ';', @{$fields}[ 1, 3 .. 5, 2 ] ) . ';' );
}
if ( not $csv->eof ) {
    $csv->error_diag();
}
close $data;
print join( "\n", @result );
    # # Argument parsing
    # my $verbose  = 0;          # frequently referred
    # my $debug    = 0;          # if you want to try command
    # my $file     = '.';        # default git add .
    # my $date     = 'today';    # default git commit today date
    # my $repo_dir = getcwd;     # default curr directory

    # my $log_file = $RealBin . "/git_commit.log";

    # #Init logging
    # Log::Log4perl->easy_init(
        # {   level  => $DEBUG,
            # file   => ":utf8>>$log_file",
            # layout => '%d %p> %F{1}:%L %M - %m%n'
        # }
    # );

    # #or you can pass it from command line
    # my %options = (
        # 'verbose'  => $verbose,
        # 'debug'    => $debug,
        # 'file'     => $file,
        # 'date'     => $date,
        # 'repo_dir' => $repo_dir,
    # );
    # GetOptions(
        # \%options,   'verbose', 'debug', 'date=s',
        # 'message=s', 'file=s',  'repo_dir=s',
    # ) or pod2usage(1);
    # if (!exists $options{date} || !exists $options{message}) {
        # pod2usage(1);
    # }
    # git_commit(\%options);
    return 0;
}




sub prepare_encoding_console {
    if ( is_interactive() ) {
        binmode STDIN,  ':encoding(console_in)';
        binmode STDOUT, ':encoding(console_out)';
        binmode STDERR, ':encoding(console_out)';
    }
    Encode::Locale::decode_argv();
    return 1;
}
