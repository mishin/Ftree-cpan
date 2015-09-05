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

package FamilyTreeInfo;

use strict;
use warnings;

use FamilyTreeBase;

use Switch;
use Params::Validate qw(:all);
use Perl6::Export::Attrs;
use Encode qw(decode_utf8);
use utf8;


my $q = new CGI;

use base 'FamilyTreeBase';
sub new : Export {
    my $type = shift;
    my $self = $type->SUPER::new(@_);
    $self->{family_tree_data} =
    	FamilyTreeDataFactory::getFamilyTree( $self->{settings}{data_source} );
    $self->{pagetype} = undef;
    return $self;
  }

sub main : Export {
  my ($self) = validate_pos(@_, {type => HASHREF} );
  $self->_process_parameters();
  $self->_password_check();

  switch ($self->{pagetype}) {
    case "" {$self->_draw_index_page();}
    case 'subfamily' {$self->_draw_same_surname_page();}
    case 'snames' {$self->_draw_surname_page();}
    case 'faces' {$self->_draw_facehall_page();}
    case 'emails' {$self->_draw_general_page(\&Person::get_email, 'email', $self->{textGenerator}->{Emails},
    		$self->{textGenerator}->{Total_with_email});}
    case 'hpages' {$self->_draw_general_page(\&Person::get_homepage, 'homepage', $self->{textGenerator}->{Homepages},
    		$self->{textGenerator}->{Total_with_homepage});}
    case 'bdays' {$self->_draw_birthday_page();}
    else { $self->_draw_invalid_page(); }
  }
  
  return;
}

#######################################################
# processing the parameters (type and passwd)
sub _process_parameters {
	my ( $self ) = validate_pos(@_, {type => HASHREF} );
	$self->SUPER::_process_parameters();
	$self->{pagetype} = $self->{cgi}->param('type');
	$self->{pagetype} = "" unless(defined $self->{pagetype});
	
	return;
}

# private functions
sub _draw_people_table {
    my ($self, $people, $column_number) = validate_pos(@_, 
      {type => HASHREF}, {type => ARRAYREF}, {defaulf => 5});
    $column_number = 5 unless defined $column_number;  #AAARRRRGGGHHH
    my $nr_of_man  = 0;
    my $nr_of_woman= 0;
    print $self->{cgi}->start_table({-cellpadding => '5', -border=>'1', -align=>'center'}),"\n";
    
    for my $index (0 .. @{$people} - 1 ) {
      print $self->{cgi}->start_Tr() if ( $index % $column_number == 0 );
      my $class = $self->get_cell_class(
        $people->[$index], \$nr_of_man, \$nr_of_woman);
      print $self->{cgi}->td({-class => $class},
        $self->aref_tree($people->[$index]->get_name()->get_long_name(), $people->[$index])), "\n";
      print $self->{cgi}->end_Tr() if ( ($index % $column_number) == $column_number-1 );
  }
  print $self->{cgi}->end_Tr(),"\n" if ( (@{$people} % $column_number) != 1 );
  
  print $self->{cgi}->end_table(),"\n", $self->{cgi}->br,
    $self->{textGenerator}->summary(scalar(@{$people})), 
    " ($self->{textGenerator}{man}: ", $nr_of_man,  
    ", $self->{textGenerator}{woman}: ", $nr_of_woman, 
    ", $self->{textGenerator}{unknown}: ", scalar(@{$people}) - $nr_of_man - $nr_of_woman, ')' ;
    
  return;    
}
#########################################################
# INDEX PAGE
#########################################################
sub _draw_index_page {
  my ($self, $column_number) = validate_pos(@_, 
      {type => HASHREF}, {type => SCALAR, optional => 1});
  my @people = grep {defined $_->get_name()} $self->{family_tree_data}->get_all_people();
  @people = sort{$a->get_name()->get_full_name() cmp $b->get_name()->get_full_name()} @people;
  $self->_toppage($self->{textGenerator}->{members});
  $self->_draw_people_table(\@people, $column_number);
  $self->_endpage();
  
  return;
}

#########################################################
# Same surname people
#########################################################
sub _draw_same_surname_page {
  my ($self, $column_number) = validate_pos(@_, 
      {type => HASHREF}, {type => SCALAR, optional => 1});
  my $surname = decode_utf8($self->{cgi}->param('surname'));
	$surname = "" unless(defined $surname);
	my @people = grep {defined $_->get_name() &&
	                   $_->get_name()->get_last_name() eq $surname} 
	               $self->{family_tree_data}->get_all_people();
	               
  @people = sort{$a->get_name()->get_full_name() cmp $b->get_name()->get_full_name()} (@people);
  $self->_toppage($self->{textGenerator}->People_with_surname($surname));
  $self->_draw_people_table(\@people, $column_number);
  $self->_endpage();
  
  return;
}

#########################################################
# SURNAME PAGE
#########################################################
sub _draw_surname_page {
  my ($self, $column_number) = validate_pos(@_, 
      {type => HASHREF}, {type => SCALAR, optional => 1});
  $column_number = 8 unless( defined $column_number);

  require Set::Scalar;
  my $last_name_set = Set::Scalar->new;
  for my $person  ($self->{family_tree_data}->get_all_people()) {
    $last_name_set->insert($person->get_name()->get_last_name())
      if((defined $person->get_name()) && (defined $person->get_name()->get_last_name()));
  }
  
  $self->_toppage($self->{textGenerator}->{Surnames});

  while ( defined( my $a_last_name = $last_name_set->each ) ) {
    push @{ $self->{nodes} }, $a_last_name;
  }
  my @sortednodes = sort @{ $self->{nodes} };

  print $self->{cgi}->start_table({-cellpadding => '5', -border=>'1', -align=>'center'}),"\n";
  for my $people_count (0 .. $#sortednodes) {
    print $self->{cgi}->start_Tr() if ( $people_count % $column_number == 0 );
    print $self->{cgi}->td($self->{cgi}->a({-href => "$self->{treeScript}?type=subfamily&surname=$sortednodes[$people_count]&lang=$self->{lang}"}, 
      $sortednodes[$people_count]));
    print $self->{cgi}->end_Tr(),"\n" if ( $people_count % $column_number == $column_number - 1 );
  }
  print $self->{cgi}->end_Tr(),"\n" if ( $#sortednodes % $column_number != 0 );
  print $self->{cgi}->end_table(),"\n", $self->{cgi}->br,
    $self->{textGenerator}->{Total}.' '.$last_name_set->size.' '.$self->{textGenerator}->{people};
  $self->_endpage();
  
  return;
}

sub _draw_general_table {
  my ($self, $func, $attribute, $people_with_type_r, $text2) = validate_pos(@_, 
      {type => HASHREF}, {type => CODEREF}, {type => SCALAR}, {type => ARRAYREF}, {type => SCALAR});
  my $nr_of_man=0;
  my $nr_of_woman=0;
  
  print $self->{cgi}->start_table({-cellpadding => '5', -border=>'1', -align=>'center'}),"\n",
  	$self->{cgi}->Tr($self->{cgi}->th($self->{textGenerator}{photo}), $self->{cgi}->th($self->{textGenerator}{name}), 
  		$self->{cgi}->th($self->{textGenerator}{$attribute}));

  foreach my $a_person ( @{$people_with_type_r} ) {
  	my $class = $self->get_cell_class(
        $a_person, \$nr_of_man, \$nr_of_woman);
	print  $self->{cgi}->start_Tr({-class => $class}),
		$self->{cgi}->td($self->html_img($a_person)),
		
		$self->{cgi}->td($self->aref_tree($a_person->get_name()->get_full_name(), $a_person)),
    $self->{cgi}->td($func->($a_person)),
    $self->{cgi}->end_Tr, "\n";      
  }
  print $self->{cgi}->end_table, "\n", $self->{cgi}->br, $text2, scalar(@{$people_with_type_r}),
    " ($self->{textGenerator}{man}: ", $nr_of_man,  
    ", $self->{textGenerator}{woman}: ", $nr_of_woman, 
    ", $self->{textGenerator}{unknown}: ", scalar(@{$people_with_type_r}) - $nr_of_man - $nr_of_woman, ")" ;

  return;  
}
#########################################################
# GENERAL PAGE
#########################################################
sub _draw_general_page {
  my ($self, $func, $attribute, $title, $text2) = validate_pos(@_, 
      {type => HASHREF}, {type => CODEREF}, {type => SCALAR}, 
      {type => SCALAR}, {type => SCALAR});
  
  my @people_with_type = grep {defined $func->($_)} 
    (grep {defined $_->get_name()} $self->{family_tree_data}->get_all_people());
  @people_with_type = sort{$a->get_name()->get_full_name() cmp $b->get_name()->get_full_name()} (@people_with_type);
  
  $self->_toppage($title);
  $self->_draw_general_table($func, $attribute, \@people_with_type, $text2);
  $self->_endpage();
  
  return;
}


#########################################################
# BIRTHDAYS PAGE
#########################################################
sub _draw_birthday_page {
  my ($self) = validate_pos(@_, {type => HASHREF});
  my $months = $self->{textGenerator}->{months_array};
  my $month = decode_utf8($self->{cgi}->param('month'));

  if ( ! defined $month ) {
  	$month = (localtime)[4] + 1;
  }
  else {
    my $index = 0;
 	++$index while($months->[$index] ne $month);
    $month = $index + 1;
  }
 
  
  my @people_with_bday = grep {defined $_->get_name() && 
    defined $_->get_date_of_birth() && !defined $_->get_date_of_death() && 
  	defined $_->get_date_of_birth()->{month} && $_->get_date_of_birth()->{month} == $month} 
  	 ($self->{family_tree_data}->get_all_people());

  my $title = $self->{textGenerator}->birthday_reminder($month-1); 
  $self->_toppage($title);
  @people_with_bday = sort{$a->get_name()->get_full_name() cmp $b->get_name()->get_full_name()} (@people_with_bday);

  $self->_draw_general_table(\&Person::get_date_of_birth, 'date_of_birth', \@people_with_bday, 
    $self->{textGenerator}->total_living_with_birthday($month-1));

  # Add the button for other months
  print $self->{cgi}->start_form({-action => $self->{treeScript},
                        -method => 'get' }), 
    "\n$self->{textGenerator}->{CheckAnotherMonth}:\n",
    $self->{cgi}->start_Select({-name => 'month',
                -size => 1}), "\n";
  for my $index (0 .. 11)  {
    if ( $index == ( $month - 1 ) ) {
      print $self->{cgi}->option({-selected => "selected"}, $months->[$index]), "\n";
    }
    else {
      print $self->{cgi}->option( $months->[$index]), "\n";
    }
  }
  print $self->{cgi}->end_Select, "\n", $self->{cgi}->input({-type => 'hidden', -name => "type", -value => "bdays"}), "\n",
    $self->{cgi}->input({-type => 'hidden', -name => 'password', -value => $self->{settings}{password}}), "\n",
    $self->{cgi}->input({-type => 'hidden', -name => 'lang', -value => $self->{lang}}), "\n",

    $self->{cgi}->input({-type => "submit", -value => "$self->{textGenerator}->{Go}"}),
    $self->{cgi}->end_form;

  $self->_endpage();
  
  return;
}
#########################################################
# Facehall page
#########################################################
sub _draw_facehall_page {
  my ($self) = validate_pos(@_, {type => HASHREF});
  my $column_number = 5;
  
  my @people_with_photo = grep {defined $_->get_name() && 
    defined $_->get_default_picture()} 
    ($self->{family_tree_data}->get_all_people());
  @people_with_photo = sort{ $a->get_name()->get_full_name() cmp 
                             $b->get_name()->get_full_name() } (@people_with_photo);
  
  $self->_toppage($self->{textGenerator}->{Hall_of_faces});

  my $nr_of_man   = 0;
  my $nr_of_woman = 0;
  print $self->{cgi}->start_table({-cellpadding => '7', -align=>'center'}),"\n";
  
  foreach my $index (0 .. $#people_with_photo) {
      print $self->{cgi}->start_Tr,"\n" if ( $index % $column_number == 0 );
      my $class = $self->get_cell_class(
        $people_with_photo[$index], \$nr_of_man, \$nr_of_woman);
      print $self->{cgi}->start_td({-class => $class, -align=>'center'}), 
        $self->aref_tree($self->html_img($people_with_photo[$index]), $people_with_photo[$index]), $self->{cgi}->br, 
        $people_with_photo[$index]->get_name()->get_full_name(), $self->{cgi}->end_td;
      print $self->{cgi}->end_Tr,"\n" if ( $index % $column_number == $column_number-1 );
  }
  print $self->{cgi}->end_Tr,"\n" if ( $#people_with_photo % $column_number != 0 );
  print $self->{cgi}->end_table,"\n", $self->{cgi}->br,
    $self->{textGenerator}->{Total_with_photo}, scalar(@people_with_photo),
    " ($self->{textGenerator}{man}: ", $nr_of_man,  
    ", $self->{textGenerator}{woman}: ", $nr_of_woman, 
    ", $self->{textGenerator}{unknown}: ", scalar(@people_with_photo) - $nr_of_man - $nr_of_woman, ")" ;
  $self->_endpage();
  
  return;
}
#########################################################
# INVALID PAGE TYPE ERROR
#########################################################
sub _draw_invalid_page {
  my ($self) = validate_pos(@_, {type => HASHREF});
  $self->_toppage($self->{textGenerator}->{Error});

  print $self->{textGenerator}->{Invalid_option}, $self->{cgi}->br, "\n",
    $self->{textGenerator}->{Valid_options};

  $self->_endpage();
  exit 1;
}

1;


