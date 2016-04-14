#!/usr/bin/env perl

=head1 NAME
convert_csv_from_genopro_2_ftree.pl - convert from genopro to ftree csv file
=head1 SYNOPSIS
    perl convert_csv_from_genopro_2_ftree.pl [OPTION]...
    -v, --verbose  use verbose mode
    --help         print this help message

Examples:
    perl convert_csv_from_genopro_2_ftree.pl --date '15.05.2015'
	--message 'Hi YAPC Russia 2015' --file 'file2commit'

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

use v5.10;
use Text::CSV_PP;#Text::CSV;
use Data::Show;
use Data::Dumper;
my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";
$slurp_text = slurp($file);

sub slurp {
    my ($abs_file_path) = @_;
    open my $fh, '<', $abs_file_path or croak $!;
    local $/;
    my $text = <$fh>;
}

my %contents_of = do { local $/; "", split /\[(\S+)\]\n/, $slurp_text };

my $Individuals=$contents_of{Individuals};
my $Contacts=$contents_of{Contacts};
my $Educations=$contents_of{Educations};
my $Families=$contents_of{Families};
my $Marriages=$contents_of{Marriages};
my $Occupations=$contents_of{Occupations};
my $Pictures=$contents_of{Pictures};
my $Places=$contents_of{Places};
my $SourcesAndCitations=$contents_of{SourcesAndCitations};
# say $Individuals;

my $csv = Text::CSV_PP->new(
    {
        binary           => 1,
        # auto_diag        => 1,
        sep_char         => '	',
        # allow_whitespace => 1,
    }
);

my @Individuals_lines=split /\n/,$Individuals;
# @full_name_a[ 1 .. $#full_name_a - 1 ]

my $Individuals_heades=$Individuals_lines[ 0 ];#split /\n/,$Individuals;
   my $status_body = $csv->parse($Individuals_heades);
    my @columns_names = $csv->fields();
	 say "columns_names";
say "@columns_names";
my @Individuals_body=@Individuals_lines[ 1 .. $#Individuals_lines - 1 ];#split /\n/,$Individuals;
my @people;
say "columns_values";

#������ package ExtendedSimonWardFormat;!!

#https://github.com/mishin/Ftree-cpan/blob/master/lib/Ftree/DataParsers/ExtendedSimonWardFormat.pm

#      id => ID getID($fields[0]),
#          first_name => Name.First $name_ref->{first_name},
#          mid_name   => Name.Middle $name_ref->{mid_name},
#          last_name  => Name.Last $name_ref->{last_name},
#          title      => $fields[7],
#          prefix     => $fields[8],
#          suffix     => $fields[9],
#          nickname   => $fields[10],
#          father_id  => getID($fields[1]),
#          mother_id  => getID($fields[2]),
#          email      => $fields[3],
#          homepage   => $fields[4],
#          date_of_birth => $date_of_birth,
#          date_of_death => $date_of_death,
#          gender     => $fields[6],
#          is_living  => $fields[11],
#          place_of_birth => $fields[12],
#          place_of_death => $fields[13],
#          cemetery   => $fields[14],
#          schools    => (defined $fields[15]) ?
#            [split( /,/, $fields[15])] : undef,
#          jobs       => (defined $fields[16]) ?
#            [split( /,/, $fields[16])] : undef,
#          work_places => (defined $fields[17]) ?
#            [split( /,/, $fields[17] )] : undef,
#          places_of_living => $fields[18],
#          general    => $fields[19] });

#		  ID Gender Name.First Name.Middle Name.Last Comment IsAdopted FamilyRank Birth.Date Birthday Age Birth.Place IsDead Death.Date Death.Cause Death.Cause.Description Death.Place Death.Childless Pictures.Count Pictures Sources Mates Fathers FathersAgeAtBirth Mothers MothersAgeAtBirth Siblings.Twins Siblings Siblings.Half Siblings.Step Siblings.Other Children Children.Age AgeAtChildBirths Employer Occupation Occupations Educations Contacts Contact.Address Contact.Telephone Contact.TelephoneMobile Contact.TelephoneWork Contact.Email Contact.Homepage Hyperlink.Internal Hyperlink Birth.Baptism.Date Birth.Baptism.Place Birth.Baptism.Officiator.Title Birth.Baptism.Officiator Birth.Baptism.Godfather Birth.Baptism.Godmother Birth.Baptism.Source Death.Funerals.Date Death.Funerals.Agency Death.Funerals.Place Death.Funerals.Source Death.Disposition.Type Death.Disposition.Date Death.Disposition.Place Death.Disposition.Source DataLevel custom_tag1 custom_tag2 custom_tag3 custom_tag4 custom_tag5
for my $line (@Individuals_body){
# while ( my $line = <$fh> ) {
    my $status = $csv->parse($line);
    my @columns = $csv->fields();
	# say Dumper @columns;
	if ($columns[0] eq 'ind00001'){
	say "@columns";
	}

    # my %h;
    # @h{('Name','Comment')} = @columns;
    # push @people, \%h;
# }

# while ( my $fields = $csv->getline($data) ) {
    # push @result, ( join( ';', @{$fields}[ 1, 3 .. 5, 2 ] ) . ';' );
	# show $fields;
# }
if ( not $csv->eof ) {
    $csv->error_diag();
}
}
#
# my @column_names=split /\t/,$Individuals_lines[0];
# say "@column_names";
# my $len=@Individuals_lines+0;
# say join "\n",@Individuals_lines;#[l..$len];
# show $Individuals;#%contents_of;
# show @Individuals_lines;#%contents_of;
