package Ftree::Name;

# ABSTRACT: Ftree - family tree generator
use strict;
use warnings;
use Ftree::TextGeneratorFactory qw(getTextGenerator get_reverse_name);
use version; our $VERSION = qv('2.3.39');

use Params::Validate qw(:all);

use Class::Std::Fast::Storable;
{
  my %title_of : ATTR(:get<title> :set<title>);
  my %prefix_of : ATTR(:get<prefix> :set<prefix>);
  my %first_name_of : ATTR(:name<first_name>);
  my %mid_name_of : ATTR(:name<mid_name>);
  my %last_name_of : ATTR(:name<last_name>);
  my %suffix_of  : ATTR(:get<suffix> :set<suffix>);
  my %nickname_of : ATTR(:get<nickname> :set<nickname>);


  sub set_name {
    my $self = shift;
    my %arg_ref = validate( @_, {first_name => {type => SCALAR|UNDEF},
                                mid_name => {type => SCALAR|UNDEF},
                                last_name => {type => SCALAR|UNDEF} });
    my $ident = ident $self;

    $first_name_of{$ident} = $arg_ref{first_name};
    $mid_name_of{$ident} = $arg_ref{mid_name};
    $last_name_of{$ident} = $arg_ref{last_name};

    return;
  }

  sub get_full_name {
    my ( $self ) = validate_pos(@_, {type => SCALARREF});
    my $ident = ident $self;

    my @name_array = grep {defined $_ && $_ ne ""} (Ftree::TextGeneratorFactory::get_reverse_name( ) ?
                    ($last_name_of{$ident}, $mid_name_of{$ident}, $first_name_of{$ident}) :
                    ($first_name_of{$ident}, $mid_name_of{$ident}, $last_name_of{$ident}));

    return Ftree::TextGeneratorFactory::getTextGenerator( )->{Unknown} if(0 == @name_array);
	return join(' ', @name_array);
  }

  sub get_long_name {
    my ( $self ) = validate_pos(@_, {type => SCALARREF});
    my $ident = ident $self;

    my $long_name = "";
    $long_name.= $title_of{$ident} . ' ' if(defined $title_of{$ident});
    $long_name.= $prefix_of{$ident} . ' ' if(defined $prefix_of{$ident});

    $long_name.= $self->get_full_name();

    $long_name.= " " . $suffix_of{$ident} if(defined $suffix_of{$ident});

    return $long_name;
  }
  sub get_short_name {
    my ( $self) = validate_pos(@_, {type => SCALARREF});
    my $ident = ident $self;

    if(Ftree::TextGeneratorFactory::get_reverse_name( )) {
      return join(" ", grep {defined $_ && $_ ne ""}
      ($last_name_of{$ident}, $first_name_of{$ident}) );
    } else {
      return join(" ", grep {defined $_ && $_ ne ""}
      ($first_name_of{$ident}, $last_name_of{$ident}) );
    }
  }

#######################################################
# converts a name to a url
# (removes middle name and converts spaces)
  sub urlname {
    my ( $self) = validate_pos(@_, {type => SCALARREF});
    my $full_name = $self->get_full_name();
    $full_name =~ s/ /%20/g;
    return $full_name;
  }
}
1;