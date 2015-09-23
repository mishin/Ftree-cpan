#!/usr/bin/perl -w
# -----------------------------------------------------------------------------
# Title: WeeklyBilling.pl
#
# Author: Harley Young
#
# Date: Ongoing
#
# Purpose: Connects to the Google Apps API and fetches data from a
#          specific worksheet and prepares an HTML file showing 
#          weekly billings
#
#
# SYNTAX: WeeklyBilling.pl 
#
# -- Licence Terms --
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation.  No representations are made about the suitability of this
# software for any purpose.  It is provided "as is" without express or 
# implied warranty.
#
# -----------------------------------------------------------------------------
 
# Pull in required modules and force declaration
use strict;
use LWP::UserAgent;
use XML::Simple;
use Time::Local;
 
 
# Configure the program
# The various parameters passed in the UA POST are documented on Google's page
# Authentication: http://bit.ly/1apxYA
# Spreadsheets access: http://bit.ly/Qfcxg
my $iTotalHours;
my %hConfig = (
		URL 		=> "https://www.google.com/accounts/ClientLogin",	
		AccountType	=> "GOOGLE",   
		UserName 	=> "nikolay.mishin",
		Password 	=> "3pvrIeEm4bVb",
		Serivce 	=> "wise",
		Source 		=> "Billing Automator",
		APIVersion	=> "2",
		AuthToken	=> "",
		Header		=> "includes/header.tpl",
		Footer		=> "includes/footer.tpl",
		OutputFile	=> "Weekly Billing.html"
	      );
 
# Create browser and XML objects, and send a request for authentication
my $objUA = LWP::UserAgent->new;
my $objXML = XML::Simple->new;
my $objResponse = $objUA->post(
	$hConfig{URL},
	{
	accountType	=> $hConfig{AccountType},
	Email		=> $hConfig{UserName},
	Passwd		=> $hConfig{Password},
	service		=> $hConfig{Serivce},
	source		=> $hConfig{Source},
	"GData-Version" => $hConfig{APIVersion},
	}
); 
 
# Fail if the HTTP request didn't work
die "\nError: ", $objResponse->status_line unless $objResponse->is_success;
 
# Extract the authentication token from the response and add 
# it to future UA requests
$hConfig{AuthToken} = ExtractAuth($objResponse->content);
$objUA->default_header('Authorization' => "GoogleLogin auth=$hConfig{AuthToken}");
 
# Worksheet contents list
# The URL I'm using here is a list-based feed of a particular worksheet. If you
# want to build a more generic solution, you can loop through all
# your documents, find one in particular, open it, loop through all the worksheets 
# in the spreadsheet and then open the one you want.
# Details on the different URL constructions are described in the developers guide:
# http://code.google.com/apis/spreadsheets/docs/2.0/developers_guide_protocol.html
#
# If you just want to do the same thing I've done, open the document of interest
# in your web browser and look at your URL. You'll notice a key parameter in the
# query string. Clip that and slip it into the the URL below where I have
# this value: MY_SHEET_KEY
$objResponse = Fetch($objUA, "http://spreadsheets.google.com/feeds/list/MY_SHEET_KEY/od6/private/full");
my $objWorksheet = $objXML->XMLin($objResponse, ForceArray => 1);
 
# Open the file handle to create the output file
open (fhWRITE, ">$hConfig{OutputFile}") || die "Could not write to output file: $!\n";
 
# Put a header on the file
print fhWRITE GetFileChunk($hConfig{Header});
 
# For each row in the Google Docs sheet, print the date, hours, participants and notes
foreach my $sRow (@{$objWorksheet->{entry}}) {
 
	# Print out the rows where the date falls within the current week
        # For this to work you have to use the D/M/Y format in your date field
        # Depending what you name your spreadsheet columns, the gsx:date, etc
        # elements in the XML will change. You can use Data::Dumper to print the
        # XML to see what you're getting back if needed for debugging
	if (IsDateInPeriod($sRow->{'gsx:date'}[0])) {
		print fhWRITE "<tr>\n";
 
		print fhWRITE "<td>" . $sRow->{'gsx:date'}[0] . "</td>\n";
		print fhWRITE "<td class=\"hours\">" . $sRow->{'gsx:timehours'}[0] . "</td>\n";
		print fhWRITE "<td>" . $sRow->{'gsx:participants'}[0] . "</td>\n";
		print fhWRITE "<td>" . $sRow->{'gsx:notes'}[0] . "</td>\n";	
 
		print fhWRITE "</tr>\n";
 
		# Accumulate the total hours
		$iTotalHours += $sRow->{'gsx:timehours'}[0];
 
	} 
}
 
 
# Add the totals row
print fhWRITE "<tr class=\"totals\">\n";
print fhWRITE "<td colspan=\"2\" class=\"hours\">$iTotalHours</td>\n";
print fhWRITE "<td colspan=\"2\">Total Hours for Period</td>\n";
print fhWRITE "</tr>\n";
 
# Put a footer on the file
print fhWRITE GetFileChunk($hConfig{Footer});
 
close fhWRITE || warn "Could not write to output file: $!\n";
 
#------------------------------------------------------------------------------
# Subroutines
#------------------------------------------------------------------------------
 
# Extract the authorization token from Google's return string
sub ExtractAuth {
	# Split the input into lines, loop over and return the value for the 
	# one starting Auth=
   	for (split /\n/, shift) { 
   		return $1 if $_ =~ /^Auth=(.*)$/; 
   	}
   	return '';
 }
 
# Fetch a URL
sub Fetch {
	# Create the local variables and pull in the UA and URL
	my ($objUA, $sURL) = @_;
 
	# Grab the URL, but fail if you can't get the content
	my $objResponse = $objUA->get($sURL);
	die "Failed to fetch $sURL " . $objResponse->status_line if !$objResponse->is_success;
 
	# Return the result
	return $objResponse->content;
}
 
 
# Bring in an external file chunk and print it out 
sub GetFileChunk {
	# Pull the file name to print into a local variable
	my $sFile = shift;
	my $sFileChunk;
 
	# Whip through the file and fetch it into an array
	open(fhREAD, $sFile) || die "Could not open $sFile: $!\n";
 
	while (<fhREAD>) {
		# Local variables
		my $sLine = $_;
		my $sReplacementString;	
 
		# Fetch the date range
		if (/BILLING__PERIOD/) {
			my ($sStartDate, $sEndDate) = FetchDateRange();
			$sLine =~ s/BILLING__PERIOD/$sStartDate - $sEndDate/;
		}
 
		# Append this line
		$sFileChunk .= $sLine;
	}
 
	# Close the file handle
	close(fhREAD) || warn "Could not close $sFile: $!\n";
 
	# Return the result
	return($sFileChunk);
}
 
 
# Get the weekly date range
sub FetchDateRange {
	# Get the current time
	my $iEndTime = time();
 
	# Go back 7 days (604,800 seconds) to get the start of the billing period
	my $iStartTime = $iEndTime - 604800;
 
	# Convert all the dates into standard DD/MM/YYYY format
	my ($iEndDay, $iEndMonth, $iEndYear) = (localtime($iEndTime))[3,4,5];
	my ($iStartDay, $iStartMonth, $iStartYear) = (localtime($iStartTime))[3,4,5];
 
	# Fix the zero based month & year
	$iStartYear+=1900;
	$iEndYear+=1900;
	$iStartMonth+=1;
	$iEndMonth+=1;
 
	# Pad the dates with leading zeros if required
	$iStartDay = PadNumber($iStartDay);
	$iStartMonth = PadNumber($iEndMonth);
	$iEndDay = PadNumber($iEndDay);
	$iEndMonth = PadNumber($iEndMonth);
 
	# Return the results
	return ("$iStartMonth/$iStartDay/$iStartYear", "$iEndMonth/$iEndDay/$iEndYear");
}
 
sub IsDateInPeriod {
	# Get the date and time (resetting the 0 based month and 1900-less year)
	my ($iMonth, $iDay, $iYear) = split(/\//, shift);
	my $iTime = timelocal(0, 0, 0, $iDay, $iMonth-1, $iYear-1900);
 
	# Get the current time and the period start time (604,800 seconds ago)
	my $iEndTime = time();
	my $iStartTime = $iEndTime - 604800;
 
	# Test to see if the supplied time falls in the range and return T(1) or F(0)
	if ( $iTime > $iStartTime && $iTime < $iEndTime ) {
		return(1);
	}
	else {
		return(0);
	}
}
 
 
# Pad data where the value is less than 10
sub PadNumber {
	# Local variables
	my $sData = $_[0];
 
	# Zero pad if the value is less than 10
	if ($sData < 10) {
		$sData = "0" . $sData;
	}
 
	# Return the results
	return($sData);
}