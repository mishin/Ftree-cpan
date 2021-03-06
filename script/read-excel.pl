﻿#!/usr/bin/perl -w

use Spreadsheet::ParseExcel;

use strict;

my $filename = shift || "test.xls";

my $e = new Spreadsheet::ParseExcel;
my $eBook = $e->Parse($filename);

my $sheets = $eBook->{SheetCount};
my ($eSheet, $sheetName);

foreach my $sheet (0 .. $sheets - 1) {
    $eSheet = $eBook->{Worksheet}[$sheet];
    $sheetName = $eSheet->{Name};
    print "Worksheet $sheet: $sheetName\n";
    next unless (exists ($eSheet->{MaxRow}) and (exists ($eSheet->{MaxCol})));
    foreach my $row ($eSheet->{MinRow} .. $eSheet->{MaxRow}) {
        foreach my $column ($eSheet->{MinCol} .. $eSheet->{MaxCol}) {
            next unless (defined $eSheet->{Cells}[$row][$column]);
            print $eSheet->{Cells}[$row][$column]->Value . " ";
        }
        print "\n";
    }
}