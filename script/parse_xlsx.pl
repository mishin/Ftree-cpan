use Spreadsheet::ParseXLSX;
 
my $parser = Spreadsheet::ParseXLSX->new;
my $workbook = $parser->parse("mishin_family.xls.xlsx");
# see Spreadsheet::ParseExcel for further documentation