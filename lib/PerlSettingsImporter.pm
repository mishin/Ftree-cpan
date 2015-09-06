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

use strict;
use warnings;

package PerlSettingsImporter;
use Config::General qw(SaveConfig ParseConfig);
# ..
# SaveConfig("ftree.config", importSettings());

sub importSettings {
my %config = ParseConfig("ftree.config");
return \%config;
  # return {
    # default_language => "gb", #other options: de,fr,hu,pl,gb
    # adminName        => "Ferenc Bodon",
    # adminEmail       => "bodon\@cs.bme.hu",
    # adminHomepage    => "http://www.cs.bme.hu/~bodon",

	    # data_source      => {
      # type => "excel",
      # config => {
        # # file_name => "../tree.xls",
        # file_name => "mishin_family.xls",#export-BloodTree.ser",
        # photo_dir        => "c:/Users/TOSH/Documents/GitHub/Ftree-cpan/htdocs/pictures/", # relative to ftree.cgi file 
        # # photo_dir        => "../../../htdocs/pictures/", # relative to ftree.cgi file 
        # #photo_dir        => "../../../htdocs/pictures/", # relative to ftree.cgi file 
        # photo_url        => "/pictures/", # set this according to webserver's settings 
      # }
    # },
# #   EXCEL DATASOURCE: 
    # # data_source      => {
      # # type => "excel",
      # # config => {
        # # # file_name => "../tree.xls",
        # # file_name => "../export-BloodTree.xls",
        # # photo_dir        => "../pictures/", # relative to ftree.cgi file 
        # # photo_url        => "../pictures/", # set this according to webserver's settings 
      # # }
    # # },

# ##   CSV/TXT DATASOURCE: 
# #    data_source      => {
# #      type => 'csv',
# #      config => {
# #        file_name => "../simpsons.txt",
# #        encoding  => "utf8",
# #        photo_dir        => "../pictures/", # relative to ftree.cgi file
# #        photo_url        => "../pictures/", # set this according to webserver's settings 
# #      }
# #    },


# ## GEDCOM DATASOURCE
   # # data_source      => {
     # # type => "gedcom",
     # # config => {
       # # # file_name => "../royal.ged",
       # # file_name => "../export-BloodTree.ged",
       # # photo_url        => "../pictures/", # set this according to webserver's settings 
     # # }
   # # },


# ## DATA FROM DATABASE
# #    data_source      => {
# #      type => "dbi",
# #      config => {
# #        datasource_name => 'DBI:mysql:my_database:localhost',        
# ##        datasource_name => 'DBI:Oracle:my_database:localhost',
# #        db_user_name => "bart",
# #        db_password  => "lisa",
# #        db_table     => "family",
# #        column_mapping => {
# #          id         => 'ID',  
# #          first_name => 'FIRST_NAME',
# #          mid_name   => 'MID_NAME',
# #          last_name  => 'LAST_NAME',
# #          title      => 'TITLE',
# #          father_id  => 'FATHER',
# #          mother_id  => 'MOTHER',
# #          email      => 'EMAIL',
# #          homepage   => 'HOMEPAGE',
# #          date_of_birth=> 'DATEOFBIRTH',
# #          date_of_death=> 'DATEOFDEATH',
# #          gender     => 'SEX',
# #          is_living  => 'ISLIVING',
# #          place_of_birth => 'BIRTHPLACE',
# #          place_of_death => 'DEATHPLACE',
# #          cemetery   => 'CEMETERY',
# #          schools    => 'SCHOOLS',
# #          jobs       => 'JOBS',
# #          work_places => 'WORKPLACES',
# #          places_of_living => 'LIVINGPLACES',
# #          general    =>  'GENERAL'           
# #        },     
# #        photo_dir        => "../pictures/", # relative to ftree.cgi file
# #        photo_url        => "../pictures/", # set this according to webserver's settings 
# #      }
# #    },



    # date_format      => "%d/%m/%Y",     # %d, %m, %Y denotes day, month, year respectively
# #    date_format      => "%Y-%m-%d",
    
    # css_filename     => "../css/bodon_default.css",

    # sitemeter_needed => 1,
    # sitemeter_id     => "s22bodonangol",
    # password         => "",
    # passwordPrompt   => "Enter Bart's surname:",
    # passwordReq      => "",
  # };
}

1;
