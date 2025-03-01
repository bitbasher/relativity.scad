include <strings.scad>

footest = "foo  (1, bar2)";
regex_test = "foooobazfoobarbaz";

ts = "this is a test"; // test string
//echo( "ascii code test string ", ascii_code( ts ) );

pts = str( " " , ts , " " );
mts = "This IS a tESt"; // test string with capitals

nullString = "";

tsEnd = len(ts)-1;
tsQty = len(ts);

numbers = "some 123 numb 15.5 ers, a-23nd pun5556; tations99";
//echo( "ascii code numbers ", ascii_code( numbers ) );
//echo( before( ts, 6 ) );
//echo( after( ts, 6 ), "<<" );
//echo( between( ts, 5,8 ) );
//echo( parse_int( "14223" ) );
//echo( is_num( parse_int( "14223" ) ) );

//echo( grep( ts, "[^0..9-]*" ) );
// echo( grep( numbers, "[^0..9-]*" ) );

//echo( replace(ts, "[a,t]" , "#", ignore_case=true, regex=true) );
//echo( "" );
//parsed = replace(numbers, "[^0-9\-\.]+" , "#", ignore_case=true, regex=true);
//echo( parsed );
//echo("");


echo( "testing ascii_code" );
legalCodes = ts;
//echo( "legal codes ", legalCodes, ascii_code(legalCodes) );

illegalCodes = "\u20AC 10 \u263A"; // UNICODE for 10 euro and a smilie;
echo( "illegal codes ", illegalCodes, ascii_code(illegalCodes) );


// teststring (ts) converted to ascii codes
assert( ascii_code( legalCodes )   == [116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116] );
assert( ascii_code( illegalCodes ) == [undef, 32, 49, 48, 32, undef] );
notString = 42;
assert( is_undef( ascii_code( notString ) ) );

//echo( ascii_code( _ASCII_VISIBLE ) );
//echo( ascii_code( _ASCII_ALL ) );

// make a reference string based on _WHITESPACE and _ASCII

codevect = [for(c=_ASCII) ord(c)];
//echo( "code vect", codevect, _CHAR_NL );
//echo( "code asci", ascii_code( _ASCII ), _CHAR_NL );
//echo( "code alt ", alt_ascii_code( _ASCII ), _CHAR_NL );

//echo( "truth",  orig_ascii_code( _ASCII ) == codevect );
//echo( "dare ",  orig_ascii_code( _ASCII ) == ascii_code( _ASCII ));
//echo( "sure ",  orig_ascii_code( _ASCII_ALL ) == ascii_code( _ASCII_ALL ));

//assert( orig_ascii_code( _ASCII ) == codevect );
//assert( orig_ascii_code( _ASCII ) == ascii_code( _ASCII ) );
//assert( orig_ascii_code( _ASCII_ALL ) == ascii_code( _ASCII_ALL ));
assert( ascii_code( _ASCII ) == codevect );

echo( "testing boolean test functions" );

echo( "\tstr_is_empty" );
assert( ! str_is_empty( "  " ) );
assert(   str_is_empty( "" ) );
assert( ! str_is_empty( "xyz" ) );
assert( is_undef( str_is_empty( [] ) ) );


echo( "\tstr_is_null_or_empty" );
assert( ! str_is_null_or_empty( "  " ) );
assert(   str_is_null_or_empty( "" ) );
assert( ! str_is_null_or_empty( "xyz" ) );
assert( ! str_is_null_or_empty( [] ) ); // non strings as input give "false"


echo( "\tstr_is_null_or_allspaces" );
assert(   str_is_null_or_allspaces( "  " ) );
assert(   str_is_null_or_allspaces( "" ) );
assert( ! str_is_null_or_allspaces( "xyz" ) );
assert( ! str_is_null_or_allspaces( [] ) ); // non strings as input give "false"

echo( "\tstr_is_allspaces" );
assert( str_is_allspaces( "" ) == "" );
assert( str_is_allspaces( "  " ) );
assert( ! str_is_allspaces( "abcd" ) );
assert( ! str_is_allspaces( " a b c d " ) );
assert( is_undef( str_is_allspaces( [] ) ) );
assert( is_undef( str_is_allspaces( ["  "] ) ) );



echo(	"testing slice()" );
testvec = [ 1, 2, 3, "four", [5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15]];
tv1 = [ 2, 3, "four", [5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15]];
tv8 = [ for( i=[0:8] ) i ]; // fill a test array

matrix = 
	[
	["1a","2a","3a","4a"],
	["1b","2b","3b","4b"],
	["1c","2c","3c","4c"],
	["1d","2d","3d","4d"]
	];

//echo( slice( undefArray ) );				// undef
//echo( slice( testvec, undefStart ) );		// undef
//echo( slice( testvec, 0, undefEnd ) );		// undef

assert( is_undef( slice( undefArray ) ) );
assert( is_undef( slice( testvec, undefStart ) ) );
assert( is_undef( slice( testvec, 0, undefEnd ) ) );

resultvec = slice( [] );
assert( is_list( resultvec ) && resultvec == [] );
rv2 = slice( [], 0 );
assert( is_list( rv2 ) && rv2 == [] );		// []
rv3 = slice( [], 0, -1 );
assert( is_list( rv3 ) && rv3 == [] );		// []

//echo( "defaults ", slice( testvec ) );		// the testvec is returned
//echo( "0 0  ", slice( testvec, 0, 0 ) );	// [1]
//echo( "0 1  ", slice( testvec, 0, 1 ) );	// [1,2]
echo( str( "0", len(testvec) ), slice( testvec, 0, len(testvec)-1 ) );		// the testvec is returned
assert( slice( testvec ) == testvec );		// testvec is returned
assert( slice( testvec, 0, 0 ) == [1]); 	// [1]
assert( slice( testvec, 0, 1 ) == [1,2] );	// [1,2]
assert( slice( testvec, 0, len(testvec)-1 ) == testvec );		// testvec is returned

//echo( "1    ", slice( testvec, 1 ) );		// [2, 3, "four" etc]
//echo( "1 -1 ", slice( testvec, 1, -1 ) );	// ditto
//echo( "1 1  ", slice( testvec, 1, 1 ) );	// [2]
//echo( "1 2  ", slice( testvec, 1, 2 ) );	// [2,3]
//echo( "1 3  ", slice( testvec, 1, 3 ) );	// [2,3,"four"]
//echo( "1 4  ", slice( testvec, 1, 4 ) );	// [2,3,"four"]
//echo( "1 5  ", slice( testvec, 1, 5 ) );	// [2,3,"four"]
//echo( "1 6  ", slice( testvec, 1, 6 ) );	// [2,3, .., 11]
//echo( "1 20 ", slice( testvec, 1, 20 ) );	// undef ** error
assert( slice( testvec, 1 ) == tv1 );		// from 1-st to end of array
assert( slice( testvec, 1, -1 ) );	// ditto
assert( slice( testvec, 1, 1 ) == [2] );	// [2]
assert( slice( testvec, 1, 2 ) == [2,3]);	// [2,3]
assert( slice( testvec, 1, 3 ) == [2,3,"four"] );	// [2,3,"four"]
assert( slice( testvec, 1, 4 ) == [2,3,"four",[5,6] ] );
assert( slice( testvec, 1, 5 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10] ] );
assert( slice( testvec, 1, 6 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( slice( testvec, 1, 20 ) == tv1 );	// from 1 to 20, reduced to end of array

//echo( "2 2  ", slice( testvec, 2, 2 ) );	// [3]
assert( slice( testvec, 2, 2 ) == [3]);	// [3]

//echo( "3 3  ", slice( testvec, 3, 3 ) );	// ["four"]
//echo( "3 6  ", slice( testvec, 3, 6 ) );	// ["four" .. 11]
assert( slice( testvec, 3, 3  ) == ["four"] );	// ["four"]
assert( slice( testvec, 3, 6  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( slice( testvec, 3, 7  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );
assert( slice( testvec, 3, 20 ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );

//echo( "6 3  ", slice( testvec, 6, 3 ) );	// test swapping indecies
echo( "5 3 swap", slice( testvec, 5, 3 ) );
assert( slice( testvec, 5, 3 ) == [ "four", [5,6], ["seven", "eight", 9, 10] ] );

echo( tv8 );
echo( "-3   6", slice( tv8, -3,  6 ) );
echo( " 3  -2", slice( tv8,  3, -2 ) );



//echo( "     ", slice( matrix ) );
//echo( "0  1 ", slice( matrix, 0, 1 ) );
//echo( "2  3 ", slice( matrix, 2, 3 ) );
assert( slice( matrix ) );
assert( slice( matrix, 0, 1 ) );
assert( slice( matrix, 2, 3 ) );

//echo( "1  1 ", slice( matrix, 1, 1 ) );
//echo( "1    ", slice( matrix, 1 ) );
//echo( "1 -1 ", slice( matrix, 1, -1 ) );
//echo( "1  1 ", slice( matrix, 1, 1 ) );
//echo( "1  2 ", slice( matrix, 1, 2 ) );
//echo( "1  3 ", slice( matrix, 1, 3 ) );
//echo( "3  1 ", slice( matrix, 3, 1 ) );
assert( slice( matrix, 1, 1 ) );
assert( slice( matrix, 1 ) );
assert( slice( matrix, 1, -1 ) );
assert( slice( matrix, 1, 1 ) );
assert( slice( matrix, 1, 2 ) );
assert( slice( matrix, 1, 3 ) );
assert( slice( matrix, 3, 1 ) );

//echo( "6  8 ", slice( matrix, 6, 8 ) );
assert( "6  8 ", slice( matrix, 6, 8 ) );




echo(	"testing after()" );
assert(	after(ts, -1) == ts );
assert(	after(ts, 0) == "his is a test" );
assert(	after(ts, 1) == "is is a test" );
assert(	after(ts, 4) == "is a test" );
//echo( after(ts, tsEnd) );
assert(	after(ts, tsEnd) == nullString );
//echo( after(ts, tsQty) );
assert(	after(ts, tsQty) == nullString );
assert(	after(ts, undef) == undef );

echo( "testing before()" );
assert( before(ts, -1) == nullString );
assert( before(ts, 0) == nullString );
assert( before(ts, 1) == ts[0] );
assert( before(ts, 2) == str(ts[0],ts[1]) );
assert( before(ts, tsEnd) == "this is a tes" );
assert( before(ts, tsQty) == ts );
assert( before(ts, undef) == undef );
    

echo( "testing between()" );
assert( between("bar", undef, undef) == undef );
assert( between("bar", undef, 1) == undef );
assert( between("bar", 1, undef) == undef );
assert( between( ts, -1,  1) == ts[0] );
assert( between( ts,  1,  2) == ts[1] );
assert( between( ts,  1,  3) == str( ts[1],ts[2]) );
assert( between( ts,  0,  2) == str( ts[0],ts[1]) );
assert( between( ts,  1,  1) == nullString );
// echo( between( ts, -1, -1) );
assert( between( ts, -1, -1) == undef );
assert( between( ts,  tsEnd+1,  tsEnd+1) == nullString );
assert( between( ts,  tsEnd+2,  tsEnd+2) == undef );
assert( between( ts,  5,  7)== "is" );
assert( between( ts,  7,  5)== undef );
assert( between( ts,  tsEnd+2,  tsEnd) == undef );
    

echo( "testing substring:" );
assert( substring( ts, tsQty+1, 2) == undef );
assert( substring( ts, 5, 2) == "is" );
// test if length == undef devolves to after()
//echo( substring(ts,5,20) );
//echo( substring(ts,5) );
assert( substring( ts, 5) == "is a test" );


echo( "testing join:" );
assert( join(["foo", "bar", "baz"], ", ") == "foo, bar, baz" );
assert( join(["foo", "bar", "baz"], "") == "foobarbaz" );
assert( join(["foo"], ",") == "foo" );
assert( join([], "") == "" );
assert( join([], " ") == "" );
assert( join([], ",") == "" );

echo( "testing is_in:" );
assert( is_in("t",  ts) );
assert( !is_in("x",  ts) );
//echo( is_in( 12, ts ) );
assert( is_in( 12,  ts) == false);

assert( lower("!@#$1234FOOBAR!@#$1234") == "!@#$1234foobar!@#$1234");
assert( upper("!@#$1234foobar!@#$1234") == "!@#$1234FOOBAR!@#$1234");

echo("testing equals:" );
assert( equals(ts, "foobar" ) == false );
assert( equals(ts, ts) == true );
assert( equals(nullString, nullString) == true );
assert( equals(ts, ts, ignore_case=true) == true );

echo(	"testing starts_with:" ); 
assert( starts_with( ts, "this") );
assert( starts_with( ts, "his", 1) );

echo( "testing ends_with:" ); 
assert( ends_with( ts, "test") );

echo( "testing _is_in_range:" );
assert( is_undef( _is_in_range( undef, 0, 12) ) );
assert( _is_in_range( 2, 0, 12) );


echo( "testing tokenize: default is ignore_space=true " );
assert( tokenize(" ") == [] );
assert( tokenize(footest)[0] == "foo" );
assert( tokenize(footest)[1] == "(" );
assert( tokenize(footest)[2] == "1" );
assert( tokenize(footest)[3] == "," );
assert( tokenize(footest)[4] == "bar2" );
assert( tokenize(footest)[5] == ")" );
assert( tokenize(footest)[6] == undef );

echo( "testing tokenize: with ignore_space=false " );
assert( tokenize(" ", ignore_space=false) == [" "] );
tokenlist = tokenize(footest, ignore_space=false);
//echo( tokenlist );
assert( tokenlist == ["foo", "  ", "(", "1", ",", " ", "bar2", ")" ] );
assert( tokenlist[8] == undef );


echo( "testing trim:" );
assert( trim(pts) == ts );
assert( trim(str(" ",ts)) == ts );
assert( trim(str(ts," ")) == ts );
assert( trim(ts) == ts );
assert( trim("") == "" );
assert( trim(" ") == "" );
assert( trim("  ") == "" );
assert( is_undef( trim(undef) ) );


echo( "testing reverse:" );
assert( reverse("bar") == "rab" );
assert( reverse("ba") == "ab" );
assert( reverse("") == "" );
assert( is_undef( reverse( notString ) ) );



echo( "testing _parse_rx:" );
echo( "atomic operations" );
assert( _parse_rx("a?") == ["zero_to_one", ["literal", "a"]] );
assert( _parse_rx("a*") == ["zero_to_many", ["literal", "a"]] );
assert( _parse_rx("a+") == ["one_to_many", ["literal", "a"]] );

assert( _parse_rx( "foo" ) 
    == ["sequence", 
	  	["literal", "f"],
     	["literal", "o"],
    	["literal", "o"]
 	   ] 
	);

assert( _parse_rx("a|b")
    == ["choice", ["literal", "a"], ["literal", "b"] ] 
	);
     
echo( "variable repetition" );
assert( _parse_rx(".{3}") == ["many_to_many", ["wildcard"], "3"] );
assert( _parse_rx(".{3,5}") == ["many_to_many", ["wildcard"], "35"] );

echo( "charsets" );
assert( _parse_rx(".[abcdef]")
      == ["sequence", ["wildcard"],
     		["positive_character_set",
     			["character_literal", "a"],
     			["character_literal", "b"],
     			["character_literal", "c"],
     			["character_literal", "d"],
     			["character_literal", "e"],
     			["character_literal", "f"]
     		]
     	]
		);

assert( _parse_rx("[a-z]")
	== ["positive_character_set",
		["character_range", "az"]
	   ]
	);

assert( _parse_rx(".[^abcdef]")
      == ["sequence", ["wildcard"],
     		["negative_character_set", 
     			["character_literal", "a"],
     			["character_literal", "b"],
     			["character_literal", "c"],
     			["character_literal", "d"],
     			["character_literal", "e"],
     			["character_literal", "f"]
     		]
     	]
		);
assert( _parse_rx("^[a-z]") 
      == ["sequence",
	  		["start"],
     		["positive_character_set", ["character_range", "az"]]
     	 ]
		);

echo( "escape characters" );
assert( _parse_rx("\\d") 	== ["character_set_shorthand", "d"] );
assert( _parse_rx("\\d\\d")
      == ["sequence", 
     		["character_set_shorthand", "d"],
     		["character_set_shorthand", "d"]
     	]
		);
assert( _parse_rx("\\d?") 	== ["zero_to_one", ["character_set_shorthand", "d"]] );
assert( _parse_rx("\\s\\d?") 
      == ["sequence", 
     		["character_set_shorthand", "s"],
     		["zero_to_one", ["character_set_shorthand", "d"]]
     	] );
assert( _parse_rx("\\d?|b*\\d+")
      == ["choice", 
     		["zero_to_one", ["character_set_shorthand", "d"]],
     		["sequence", 
     			["zero_to_many", ["literal", "b"]],
     			["one_to_many", ["character_set_shorthand", "d"]]
     		]
     	] );

assert( _parse_rx("a|\\(bc\\)")
      == ["choice", 
     		["literal", "a"],
     		["sequence", 
				["character_set_shorthand", openParen],
     			["literal", "b"],
     			["literal", "c"],
     			["character_set_shorthand", closParen]
			]
		]
		);

echo( "order of operations" );
assert( _parse_rx("ab?")
      == ["sequence", 
      		["literal", "a"],
     		["zero_to_one",
			["literal", "b"]]
     	] 
		);
assert( _parse_rx("(ab)?")
      == ["zero_to_one", 
      		["sequence", 
      			["literal", "a"],
     			["literal", "b"]
     		]
     	] 
		);
assert( _parse_rx("a|b?")
      == ["choice", 
      		["literal", "a"],
     		["zero_to_one", ["literal", "b"]]
     	]
		);
assert( _parse_rx("(a|b)?")
      == ["zero_to_one", 
      		["choice", 
      			["literal", "a"],
     			["literal", "b"]
     		]
     	] 
		);
assert( _parse_rx("a|bc") 
      == ["choice", 
      		["literal", "a"],
     		["sequence", 
     			["literal", "b"],
     			["literal", "c"]
     		]
     	] );
assert( _parse_rx("ab|c")
      == ["choice", 
      		["sequence", 
      			["literal", "a"],
     			["literal", "b"]
     		],
     		["literal", "c"]
     	] );
assert( _parse_rx("(a|b)c")
      == ["sequence", 
      		["choice", 
      			["literal", "a"],
     			["literal", "b"]
     		],
     		["literal", "c"]
     	] );
assert( _parse_rx("a|(bc)")
      == ["choice", 
     		["literal", "a"],
     		["sequence", 
     			["literal", "b"],
     			["literal", "c"]
     		]
     	] );

assert( _parse_rx("a?|b*c+")
      == ["choice", 
      		["zero_to_one",
				["literal", "a"]
			],
     		["sequence", 
     			["zero_to_many", 
					["literal", "b"]
				],
     			["one_to_many", 
					["literal", "c"]
				]
     		]
     	] 
	);
assert( _parse_rx("a?|b*c+d|d*e+")
      == ["choice", 
      		["zero_to_one", ["literal", "a"]],
     		["sequence", 
     			["zero_to_many", ["literal", "b"]],
     			["one_to_many", ["literal", "c"]],
     			["literal", "d"]
     		],
     		["sequence", 
     			["zero_to_many", ["literal", "d"]],
     			["one_to_many", ["literal", "e"]]
     		]
     	]
	);

echo( "edge cases" );
assert( _parse_rx("a") == ["literal", "a"] );
assert( _parse_rx("")  );
assert( _parse_rx(undef) == undef );

echo( "invalid syntax" );
//assert( _parse_rx( "((()))" ) );
//assert( _parse_rx( "(()))"  ) );
//assert( _parse_rx( "((())"  ) );
//assert( _parse_rx( "a?*+"   ) );
assert( _parse_rx( "[^a-z]*"  ) );

echo( "testing _parse_rx" );
assert( _parse_rx( "[foba]{2,5}") );
assert( _parse_rx( "[foba]{6,9}")  );
assert( _parse_rx( "[fobar]{2,6}") );
assert( _parse_rx( "[fobar]{2,9}") );
assert( _parse_rx( "[a-z]*") );
assert( _parse_rx( "[f-o]*") );
assert( _parse_rx( "[^a-z]*")  );
assert( _parse_rx( "[^f-o]*") );

//echo( "[foba]{2,5}", _parse_rx( "[foba]{2,5}") );

fivetabs = "\t\t\t\t\t";
// tabs = substring( fivetabs, 0, 1 );

module printNestedList( data, pos=0, tablevel=0 )
	let( tabs = substring( fivetabs, 0, tablevel ) )

	for( s = data )
		if( is_list( s ) )
			printNestedList( s, pos=pos+1, tablevel=tablevel+1 );
		else
			echo( str( tabs,s ) );

/*
echo( "\n\t[foba]{2,5}" );
printNestedList( _parse_rx( "[foba]{2,5}") );

echo( "\n\t[foba]{6,9}" );
printNestedList( _parse_rx( "[foba]{6,9}") );

echo( "\n\t[fobar]{2,6}" );
printNestedList( _parse_rx( "[fobar]{2,6}") );

echo( "\n\t[fobar]{2,9}" );
printNestedList( _parse_rx( "[fobar]{2,9}") );

echo( "\n\t[a-z]*" );
printNestedList( _parse_rx( "[a-z]*") );

echo( "\n\t[f-o]*" );
printNestedList( _parse_rx( "[f-o]*") );

echo( "\n\t[^a-z]*" );
printNestedList( _parse_rx( "[^a-z]*")  );

echo( "\n\t[^f-o]*" );
printNestedList( _parse_rx( "[^f-o]*") );
 */

echo( "testing _match_regex" );
assert( _match_regex("foobarbaz", "[foba]{2,5}") == 5 );
assert( _match_regex("foobarbaz", "[foba]{6,9}") == undef );
assert( _match_regex("foobarbaz", "[fobar]{2,6}") == 6 );
assert( _match_regex("foobarbaz", "[fobar]{2,9}") == 8 );
assert( _match_regex("foobarbaz", "[a-z]*") == 9 );
assert( _match_regex("foobarbaz", "[f-o]*") == 3 );
assert( _match_regex("012345", "[^a-z]*") == 6 );

//echo( _match_regex( "foobarbaz", "[^a-z]*" ) );

assert( _match_regex("foobarbaz", "[^a-z]*") == 0 );
echo( _match_regex("foo13bar,,baz", "[^a-z]*") );

echo( _match_regex( "foobarbaz", "[^f-o]*" ) ); // expect 4 get 0
echo( _match_regex( "foobarbaz", "fo" ) ); // get 2
echo( _match_regex( "foobarbaz", "ba" ) ); // get undef

assert( _match_regex("foobarbaz", "[^f-o]*") == 0 ); // **BUG ? not right


echo(  "testing contains:" );
assert( contains("foo bar baz", "ba[rz]", regex=true) == true );
assert( contains("foo bar baz", "spam",   regex=true) == false );
assert( contains("foo bar baz", "BA[RZ]", ignore_case=true, regex=true ) == true );
assert( contains("foo bar baz", "SPAM", ignore_case=true , regex=true) == false );

echo( "testing index_of:" );
//echo( index_of( ts, "t") );
assert( index_of( ts, "t") ==  [[0, 1], [10, 11], [13, 14]] );
assert( index_of("foobar foobar", "oo") == [[1,3], [8,10]] );
assert( index_of( mts, "fooBAR") == [] );
//echo( index_of( mts, "test", ignore_case=true) );
assert( index_of( mts, "test", ignore_case=true) == [[10,14]] );
assert( index_of("foo bar baz", "ba[rz]", regex=true) == [[4,7], [8,11]] );
assert( index_of("foo bar baz", "BA[RZ]", regex=true, ignore_case=true) == [[4,7], [8,11]] );
assert( index_of("", "x") == [] );


echo( "testing grep:" );
assert( grep("foo bar baz", "ba[rz]") == ["bar", "baz"] );
assert( grep("foo bar baz", "BA[RZ]") == [] );
assert( grep("foo 867-5309 baz", "\\d\\d\\d-?\\d\\d\\d\\d") == ["867-5309"] );
assert( grep("foo bar baz", "BA[RZ]", ignore_case=true) == ["bar", "baz"] );


echo( "testing replace:" );
assert( replace( "foobar", "oo", "ee") == "feebar" );
assert( replace( "foobar foobar", "oo", "ee") == "feebar feebar" );
assert( replace( "foobar", "OO", "ee", ignore_case=true) == "feebar" );
assert( replace( "foobar foobar", "OO", "ee", ignore_case=true) == "feebar feebar" );
assert( replace( "foo bar baz", "ba[rz]", "boo", regex=true) == "foo boo boo" );
assert( replace( "foo bar baz", "BA[RZ]", "spam", regex=true, ignore_case=true) == "foo spam spam" );

echo( "testing split:" );

//echo( split( "" ) );
assert( split("") == [] );

//echo( "index ", index_of( ts, " ", true ) );
//echo( "index ", index_of( ts, " ", false ) );


//echo( "split ts ", split(ts, " ") );
assert( split(ts, " ") );

cts = ",a string, with, commas,";
//echo( str( "with commas ", cts ) );
//echo( split(cts) );
assert( split(cts) == split(cts, " " ) );
assert( split(cts) == [ ",a", "string,", "with,", "commas," ]);
//echo( split(cts, "," ) );
assert( split(cts, ",") == [ "a string", " with", " commas" ] );

//assert( split(regex_test, "fo+", regex=true) );
//assert( split("bazfoobar", "fo+", regex=true) );
//assert( split("", "fo+", regex=true)  );
//assert( split("", "fo+", regex=true)  );
//assert( split(regex_test, "FO+", regex=true, ignore_case=true) == ["baz", "barbaz"] );

echo ( "all done" );
