requires 'perl', '5.008005';
requires 'DBI';
requires 'Digest::MD4';
requires 'Digest::MD5';
requires 'Digest::Perl::MD4';
requires 'Encode';
requires 'File::Temp';
requires 'Gedcom', '1.15';
requires 'Config::General', '2.58';

requires 'Class::Std', '0.013';
requires 'Class::Std::Storable', '0.0.1';
#requires 'Date::Tiny', '1.0.4';
requires 'IO::Stringy', '2.110';
requires 'List::MoreUtils', '0.413';
requires 'OLE::Storage_Lite', '0.19';
requires 'Perl6::Export::Attrs', '0.0.3';
requires 'Set::Scalar', '1.29';
requires 'Spreadsheet::ParseExcel';
requires 'version', '0.9912';


requires 'Gedcom::Comparison', '1.15';
requires 'Gedcom::Event', '1.15';
requires 'Gedcom::Family', '1.15';
requires 'Gedcom::Grammar', '1.15';
requires 'Gedcom::Individual', '1.15';
requires 'Gedcom::Item', '1.15';
requires 'Gedcom::Record', '1.15';
requires 'Jcode';
requires 'List::Util';
requires 'Params::Validate';
requires 'Parse::RecDescent';
requires 'Scalar::Util';
requires 'Time::Local';
requires 'Unicode::Map';
requires 'Switch', '2.17';
requires 'Log::Log4perl', '1.46';
requires 'Plack', '1.0037';
requires 'CGI::Emulate::PSGI', '0.21';
requires 'CGI::Compile', '0.19';
requires 'Spreadsheet::ParseXLSX', '0.17';
requires 'Spreadsheet::Read', '0.62';

on test => sub {
    requires 'Test::More';
};
