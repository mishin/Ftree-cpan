 package Perl6::Export::Attrs;

use version; $VERSION = qv('0.0.3');

use warnings;
use strict;
use Carp;
use Attribute::Handlers;

sub import {
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::import'} = \&_generic_import;
    *{$caller.'::MODIFY_CODE_ATTRIBUTES'} = \&_generic_MCA;
    return;
}

my %tagsets_for;
my %is_exported_from;
my %named_tagsets_for;

my $IDENT = '[^\W\d]\w*';

sub _generic_MCA {
    my ($package, $referent, @attrs) = @_;

    ATTR:
    for my $attr (@attrs) {

        ($attr||=q{}) =~ s/\A Export (?: \( (.*) \) )? \z/$1||q{}/exms
            or next ATTR;

        my @tagsets = grep {length $_} split m/ \s+,?\s* | ,\s* /xms, $attr;

        my (undef, $file, $line) = caller();
        $file =~ s{.*/}{}xms;

        if (my @bad_tags = grep {!m/\A :$IDENT \z/xms} @tagsets) {
            die 'Bad tagset',
                (@bad_tags==1?' ':'s '),
                "in :Export attribute at '$file' line $line: [@bad_tags]\n";
        }

        my $tagsets = $tagsets_for{$package} ||= {};

        for my $tagset (@tagsets) {
            push @{ $tagsets->{$tagset} }, $referent;
        }
        push @{ $tagsets->{':ALL'} }, $referent;

        $is_exported_from{$package}{$referent} = 1;

        undef $attr
    }

    return grep {defined $_} @attrs;
}

sub _invert_tagset {
    my ($package, $tagset) = @_;
    my %inverted_tagset;

    for my $tag (keys %{$tagset}) {
        for my $sub_ref (@{$tagset->{$tag}}) {
            my $sym = Attribute::Handlers::findsym($package, $sub_ref, 'CODE')
                or die "Internal error: missing symbol for $sub_ref";
            $inverted_tagset{$tag}{*{$sym}{NAME}} = $sub_ref;;
        }
    }

    return \%inverted_tagset;
}

# Reusable import() subroutine for all packages...
sub _generic_import {
    my $package = shift;

    my $tagset
        = $named_tagsets_for{$package}
        ||= _invert_tagset($package, $tagsets_for{$package});

    my $is_exported = $is_exported_from{$package};

    my $errors;

    my %request;
    my @pass_on_list;
    my $subs_ref;

    REQUEST:
    for my $request (@_) {
        if (my ($sub_name) = $request =~ m/\A &? ($IDENT) (?:\(\))? \z/xms) {
            next REQUEST if exists $request{$sub_name};
            no strict 'refs';
            no warnings 'once';
            if (my $sub_ref = *{$package.'::'.$sub_name}{CODE}) {
                if ($is_exported->{$sub_ref}) {
                    $request{$sub_name} = $sub_ref;
                    next REQUEST;
                }
            }
        }
        elsif ($request =~ m/\A :$IDENT \z/xms
               and $subs_ref = $tagset->{$request}) {
            @request{keys %{$subs_ref}} = values %{$subs_ref};
            next REQUEST;
        }
        $errors .= " $request";
        push @pass_on_list, $request;
    }

    # Report unexportable requests...
    my $real_import = do{
        no strict 'refs';
        no warnings 'once';
        *{$package.'::IMPORT'}{CODE};
    };
    croak "$package does not export:$errors\nuse $package failed"
        if $errors && !$real_import;

    if (!@_) {
        %request = %{$tagset->{':DEFAULT'}||={}}
    }

    my $mandatory = $tagset->{':MANDATORY'} ||= {};
    @request{ keys %{$mandatory} } = values %{$mandatory};

    my $caller = caller;
    for my $sub_name (keys %request) {
        no strict 'refs';
        *{$caller.'::'.$sub_name} = $request{$sub_name};
    }

    goto &{$real_import} if $real_import;
    return;
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Perl6::Export::Attrs - The Perl 6 'is export(...)' trait as a Perl 5 attribute


=head1 VERSION

This document describes Perl6::Export::Attrs version 0.0.3


=head1 SYNOPSIS

	package Some::Module;
    use Perl6::Export::Attrs;

	# Export &foo by default, when explicitly requested,
	# or when the ':ALL' export set is requested...

	sub foo :Export(:DEFAULT) {
		print "phooo!";
	}


	# Export &var by default, when explicitly requested,
	# or when the ':bees', ':pubs', or ':ALL' export set is requested...
	# the parens after 'is export' are like the parens of a qw(...)

	sub bar :Export(:DEFAULT :bees :pubs) {
		print "baaa!";
	}


	# Export &baz when explicitly requested
	# or when the ':bees' or ':ALL' export set is requested...

	sub baz :Export(:bees) {
		print "baassss!";
	}


	# Always export &qux 
	# (no matter what else is explicitly or implicitly requested)

	sub qux :Export(:MANDATORY) {
		print "quuuuuuuuux!";
	}


	IMPORT {
		# This block is called when the module is used (as usual),
		# but it is called after any export requests have been handled.
		# Those requests will have been stripped from its @_ argument list
    }


=head1 DESCRIPTION

Implements a Perl 5 native version of what the Perl 6 symbol export mechanism
will look like.

It's very straightforward:

=over

=item *

If you want a subroutine to be capable of being exported (when
explicitly requested in the C<use> arguments), you mark it
with the C<:Export> attribute.

=item *

If you want a subroutine to be automatically exported when the module is
used (without specific overriding arguments), you mark it with
the C<:Export(:DEFAULT)> attribute.

=item *

If you want a subroutine to be automatically exported when the module is
used (even if the user specifies overriding arguments), you mark it with
the C<:Export(:MANDATORY)> attribute.

=item * 

If the subroutine should also be exported when particular export groups
are requested, you add the names of those export groups to the attribute's
argument list.

=back

That's it.

=head2 C<IMPORT> blocks

Perl 6 replaces the C<import> subroutine with an C<IMPORT> block. It's
analogous to a C<BEGIN> or C<END> block, except that it's executed every
time the corresponding module is C<use>'d. 

The C<IMPORT> block is passed the argument list that was specified on
the C<use> line that loaded the corresponding module. However, any
export specifications (names of subroutines or tagsets to be exported)
will have already been removed from that argument list before
C<IMPORT> receives it.


=head1 DIAGNOSTICS

=over

=item %s does not export: %s\nuse %s failed

You tried to import the specified subroutine, but the module didn't
export it. Often caused by a misspelling, or forgetting to add an
C<:Export> attribute to the definition of the subroutine in question.

=item Bad tagset in :Export attribute at %s line %s: [%s]

You tried to import a collection of subroutines via a tagset, but the module
didn't export any subroutines under that tagset. Is the tagset name misspelled
(maybe you forgot the colon?).

=item Internal error: missing symbol for %s

A subroutine was specified as being exported during module compilation
but mysteriously ceased to exist before the module was imported. 

=back


=head1 CONFIGURATION AND ENVIRONMENT

Perl6::Export::Attrs requires no configuration files or environment variables.


=head1 DEPENDENCIES

This module requires the Attribute::Handlers module to handle the attributes.


=head1 INCOMPATIBILITIES

None reported.


=head1 BUGS AND LIMITATIONS

No bugs have been reported.
Note that the module does not support exporting variables.
This is considered a I<feature>, not a bug. See Chapter 17 of
Perl Best Practices (O'Reilly, 2005).

Please report any bugs or feature requests to
C<bug-perl6-export-attrs@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Damian Conway  C<< <DCONWAY@cpan.org> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, Damian Conway C<< <DCONWAY@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
