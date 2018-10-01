$book = [
    # Entry 0 is the overall control hash
    { sheets  => 2,
      sheet   => {
        "Sheet 1"  => 1,
        "Sheet 2"  => 2,
        },
      type    => "xls",
      parser  => "Spreadsheet::ParseExcel",
      version => 0.59,
      error   => undef,
      },
    # Entry 1 is the first sheet
    { label   => "Sheet 1",
      maxrow  => 2,
      maxcol  => 4,
      cell    => [ undef,
        [ undef, 1 ],
        [ undef, undef, undef, undef, undef, "Nugget" ],
        ],
      attr    => [],
      merged  => [],
      A1      => 1,
      B5      => "Nugget",
      },
	  ]