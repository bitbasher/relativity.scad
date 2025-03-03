include <strings.scad>
include <unit_test.scad>



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




//testing PEG related functions, moved here from strings.scad
//
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



// PEG ENGINE TESTS
echo(_unit_test(
	"slice",
	[
	//TODO: more tests
	_slice(["literal", "a"], 1, -1), ["a"]
	]
));

echo(_unit_test(
	"empty_string",
	[
	_match_parsed_peg("", undef, 1, ["empty_string"]), undef,
	_match_parsed_peg(undef, undef, 0, ["empty_string"]), undef,
	_match_parsed_peg("", undef, 0, ["empty_string"])[_PARSED], [],
	_match_parsed_peg("a", undef, 0, ["empty_string"])[_PARSED], [],
	]
));

echo(_unit_test(
	"private",
	[
	_match_parsed_peg("a", undef, 0, ["private", ["literal", "a"]])[_PARSED], [] ,
	_match_parsed_peg("abc", undef, 0, 
		["private",
			["sequence", 
				["literal", "a"],
				["literal", "b"],
				["literal", "c"]
			]
		])[_PARSED], [] ,
        
        _match_parsed_peg("ab", undef, 0, peg_op=["sequence", ["private", ["literal", "a"]], ["literal", "b"]])[_PARSED], ["b"],
        _match_parsed_peg("ba", undef, 0, peg_op=["sequence", ["literal", "b"], ["private", ["literal", "a"]] ])[_PARSED], ["b"],
        _match_parsed_peg("abc", undef, 0, peg_op=["sequence", ["literal", "a"], ["private", ["literal", "b"]], ["literal", "c"] ])[_PARSED], ["ac"]
	]
));
echo(_unit_test(
	"wildcard",
	[
	_match_parsed_peg("a", undef, 0, ["wildcard"])[_PARSED], ["a"],
	_match_parsed_peg("ab", undef, 0, ["wildcard"])[_PARSED], ["a"],
	_match_parsed_peg("", undef, 0, ["wildcard"]), undef
	]
));
echo(_unit_test(
	"literal",
	[
	_match_parsed_peg("a", undef, 0, ["literal", "a"])[_PARSED], ["a"],
	_match_parsed_peg("ab", undef, 0, ["literal", "ab"])[_PARSED], ["ab"],
	_match_parsed_peg("c", undef, 0, ["literal", "a"]), undef
	]
));
echo(_unit_test(
	"character_set_shorthand",
	[
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "s"]), undef,
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "s"]), undef,
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "s"]), undef,
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "s"])[_PARSED], [" "],
	_match_parsed_peg("\t", undef, 0, ["character_set_shorthand", "s"])[_PARSED], ["\t"],
	_match_parsed_peg("\n", undef, 0, ["character_set_shorthand", "s"])[_PARSED], ["\n"],
	_match_parsed_peg("\r", undef, 0, ["character_set_shorthand", "s"])[_PARSED], ["\r"],
	
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "S"])[_PARSED], ["a"],
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "S"])[_PARSED], ["A"],
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "S"])[_PARSED], ["0"],
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "S"])[_PARSED], undef,	
	_match_parsed_peg("\t", undef, 0, ["character_set_shorthand", "S"])[_PARSED], undef,
	_match_parsed_peg("\n", undef, 0, ["character_set_shorthand", "S"])[_PARSED], undef,
	_match_parsed_peg("\r", undef, 0, ["character_set_shorthand", "S"])[_PARSED], undef,
	
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "w"])[_PARSED], ["a"],
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "w"])[_PARSED], ["A"],
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "w"])[_PARSED], ["0"],
	_match_parsed_peg("_", undef, 0, ["character_set_shorthand", "w"])[_PARSED], ["_"],
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "w"])[_PARSED], undef,
	
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "W"])[_PARSED], undef,
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "W"])[_PARSED], undef,
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "W"])[_PARSED], undef,
	_match_parsed_peg("_", undef, 0, ["character_set_shorthand", "W"])[_PARSED], undef,
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "W"])[_PARSED], [" "],
	
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "d"])[_PARSED], undef,
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "d"])[_PARSED], undef,
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "d"])[_PARSED], ["0"],
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "d"])[_PARSED], undef,
	
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "D"])[_PARSED], ["a"],
	_match_parsed_peg("A", undef, 0, ["character_set_shorthand", "D"])[_PARSED], ["A"],
	_match_parsed_peg("0", undef, 0, ["character_set_shorthand", "D"])[_PARSED], undef,
	_match_parsed_peg(" ", undef, 0, ["character_set_shorthand", "D"])[_PARSED], [" "],	
	
	_match_parsed_peg("\\", undef, 0, ["character_set_shorthand", "\\"])[_PARSED], ["\\"],
	_match_parsed_peg("a", undef, 0, ["character_set_shorthand", "\\"])[_PARSED], undef,
	]
));
echo(_unit_test("character_range", 
	[
	_match_parsed_peg("a", undef, 0, ["character_range", "az"])[_PARSED], ["a"],
	_match_parsed_peg("A", undef, 0, ["character_range", "az"]), undef,
	_match_parsed_peg("z", undef, 0, ["character_range", "az"])[_PARSED], ["z"],
	_match_parsed_peg("0", undef, 0, ["character_range", "az"]), undef,
	_match_parsed_peg(" ", undef, 0, ["character_range", "az"]), undef,

	_match_parsed_peg("a", undef, 0, ["character_range", "bz"]), undef,
	_match_parsed_peg("z", undef, 0, ["character_range", "ay"]), undef,
	
	_match_parsed_peg("a", undef, 0, ["character_range", "AZ"]), undef,
	_match_parsed_peg("A", undef, 0, ["character_range", "AZ"])[_PARSED], ["A"],
	_match_parsed_peg("z", undef, 0, ["character_range", "AZ"]), undef,
	_match_parsed_peg("Z", undef, 0, ["character_range", "AZ"])[_PARSED], ["Z"],
	_match_parsed_peg("0", undef, 0, ["character_range", "AZ"]), undef,
	_match_parsed_peg(" ", undef, 0, ["character_range", "AZ"]), undef,
	
	_match_parsed_peg("A", undef, 0, ["character_range", "BZ"]), undef,
	_match_parsed_peg("Z", undef, 0, ["character_range", "AY"]), undef,
	
	_match_parsed_peg("a", undef, 0, ["character_range", "09"]), undef,
	_match_parsed_peg("A", undef, 0, ["character_range", "09"]), undef,
	_match_parsed_peg("0", undef, 0, ["character_range", "09"])[_PARSED], ["0"],
	_match_parsed_peg("9", undef, 0, ["character_range", "09"])[_PARSED], ["9"],
	_match_parsed_peg(" ", undef, 0, ["character_range", "09"]), undef,

	_match_parsed_peg("0", undef, 0, ["character_range", "19"]), undef,
	_match_parsed_peg("9", undef, 0, ["character_range", "08"]), undef,
	]
));

echo(_unit_test("positive_character_set",
	[
	_match_parsed_peg("a", undef, 0, ["positive_character_set", "a"])[_PARSED], ["a"],
	_match_parsed_peg("b", undef, 0, ["positive_character_set", "a"]), undef,
	_match_parsed_peg("a", undef, 0, ["positive_character_set", ["character_set_shorthand", "w"]])[_PARSED], ["a"],
	_match_parsed_peg(" ", undef, 0, ["positive_character_set", ["character_set_shorthand", "w"]]), undef,
	_match_parsed_peg("0", undef, 0, ["positive_character_set", ["character_set_shorthand", "w"], "0"])[_PARSED], ["0"],
	_match_parsed_peg("a", undef, 0, ["positive_character_set", ["character_range", "ac"]])[_PARSED], ["a"],
	_match_parsed_peg("z", undef, 0, ["positive_character_set", ["character_range", "ac"]]), undef,
	_match_parsed_peg("z", undef, 0, ["positive_character_set", ["character_range", "ac"], "z"])[_PARSED], ["z"],
	]
));

echo(_unit_test("negative_character_set",
	[
	_match_parsed_peg("a", undef, 0, ["negative_character_set", "a"]), undef,
	_match_parsed_peg("b", undef, 0, ["negative_character_set", "a"])[_PARSED], ["b"],
	_match_parsed_peg("a", undef, 0, ["negative_character_set", ["character_set_shorthand", "w"]]), undef,
	_match_parsed_peg(" ", undef, 0, ["negative_character_set", ["character_set_shorthand", "w"]])[_PARSED], [" "],
	_match_parsed_peg("0", undef, 0, ["negative_character_set", ["character_set_shorthand", "w"], "0"]), undef,
	_match_parsed_peg("a", undef, 0, ["negative_character_set", ["character_range", "ac"]]), undef,
	_match_parsed_peg("z", undef, 0, ["negative_character_set", ["character_range", "ac"]])[_PARSED], ["z"],
	_match_parsed_peg("z", undef, 0, ["negative_character_set", ["character_range", "ac"], "z"]), undef,
	]
));

echo(_unit_test(
	"rule",
	[
	_match_parsed_peg("a", undef, 0, ["rule", "A", ["literal", "a"]])[_PARSED], [["A", "a"]],
	_match_parsed_peg("b", undef, 0, ["rule", "A", ["literal", "a"]]), undef,
	_match_parsed_peg("a", undef, 0, ["private_rule", "A", ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("b", undef, 0, ["private_rule", "A", ["literal", "a"]]), undef
	]
));
echo(_unit_test(
	"negative_lookahead",
	[
	_match_parsed_peg("b", undef, 0, ["negative_lookahead", ["literal", "a"]])[_PARSED], [],
	_match_parsed_peg("a", undef, 0, ["negative_lookahead", ["literal", "a"]]), undef,
	_match_parsed_peg("ab", undef, 0, ["sequence", ["negative_lookahead", ["literal", "b"]], ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("ab", undef, 0, 
		["sequence", 
			["negative_lookahead", 
				["sequence", 
					["literal", "a"], 
					["literal", "b"]
				]
			], 
			["literal", "a"],
		]), undef,
	_match_parsed_peg("ab", undef, 0, 
		["sequence", 
			["negative_lookahead", 
				["sequence", 
					["literal", "b"], 
					["literal", "a"]
				]
			], 
			["literal", "a"],
		])[_PARSED], ["a"],
	]
));
echo(_unit_test(
	"positive_lookahead",
	[
	_match_parsed_peg("b", undef, 0, ["positive_lookahead", ["literal", "a"]]), undef,
	_match_parsed_peg("a", undef, 0, ["positive_lookahead", ["literal", "a"]])[_PARSED], []
	]
));

echo(_unit_test(
	"choice",
	[
	_match_parsed_peg("a", undef, 0, ["choice", ["literal", "a"], ["literal", "b"]])[_PARSED], ["a"],
	_match_parsed_peg("b", undef, 0, ["choice", ["literal", "a"], ["literal", "b"]])[_PARSED], ["b"],
	_match_parsed_peg("c", undef, 0, ["choice", ["literal", "a"], ["literal", "b"]]), undef,
	_match_parsed_peg("a", undef, 0, ["choice", ["literal", "a"], ["literal", "b"], ["literal", "c"]])[_PARSED], ["a"],
	_match_parsed_peg("b", undef, 0, ["choice", ["literal", "a"], ["literal", "b"], ["literal", "c"]])[_PARSED], ["b"],
	_match_parsed_peg("c", undef, 0, ["choice", ["literal", "a"], ["literal", "b"], ["literal", "c"]])[_PARSED], ["c"],
	_match_parsed_peg("d", undef, 0, ["choice", ["literal", "a"], ["literal", "b"], ["literal", "c"]]), undef,
	_match_parsed_peg("ab", undef, 0, ["choice", ["literal", "a"], ["literal", "ab"]])[_PARSED], ["a"],
	_match_parsed_peg("ab", undef, 0, ["choice", ["literal", "ab"], ["literal", "a"]])[_PARSED], ["ab"]
	]
));
echo(_unit_test(
	"sequence",
	[
	_match_parsed_peg("ab", undef, 0, ["sequence", ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("ab", undef, 0, ["sequence", ["literal", "a"], ["literal", "b"]])[_PARSED], ["ab"],
	_match_parsed_peg("abc", undef, 0, ["sequence", ["literal", "a"], ["literal", "b"], ["literal", "c"]])[_PARSED], ["abc"],
	_match_parsed_peg("abc", undef, 0, ["sequence", ["literal", "ab"], ["literal", "c"]])[_PARSED], ["abc"],
	_match_parsed_peg("a", undef, 0, ["sequence", ["literal", "a"], ["literal", "b"]]), undef,
	_match_parsed_peg("b", undef, 0, ["sequence", ["literal", "a"], ["literal", "b"]]), undef,
	_match_parsed_peg("c", undef, 0, ["sequence", ["literal", "a"], ["literal", "b"]]), undef,
	_match_parsed_peg("^abcdcdab$", undef, 0, 
		["sequence", 
			["literal", "^"],
			["zero_to_many",
				["choice", 
					["sequence",
						["literal", "a"],
						["literal", "b"]
					],
					["sequence",
						["literal", "c"],
						["literal", "d"]
					]
				],
			],
			["literal", "$"]
		])[_PARSED], ["^abcdcdab$"]
	]
));



echo(_unit_test(
	"zero_to_many",
	[
	_match_parsed_peg("", undef, 0, ["zero_to_many", ["literal", "a"]])[_PARSED], [],
	_match_parsed_peg("b", undef, 0, ["zero_to_many", ["literal", "a"]])[_PARSED], [],
	_match_parsed_peg("a", undef, 0, ["zero_to_many", ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("aaa", undef, 0, ["zero_to_many", ["literal", "a"]])[_PARSED], ["aaa"]
	]
));
echo(_unit_test(
	"one_to_many",
	[
	_match_parsed_peg("", undef, 0, ["one_to_many", ["literal", "a"]]), undef,
	_match_parsed_peg("b", undef, 0, ["one_to_many", ["literal", "a"]]), undef,
	_match_parsed_peg("a", undef, 0, ["one_to_many", ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("aaa", undef, 0, ["one_to_many", ["literal", "a"]])[_PARSED], ["aaa"]
	]
));
echo(_unit_test(
	"zero_to_one",
	[
	_match_parsed_peg("a", undef, 0, ["zero_to_one", ["literal", "a"]])[_PARSED], ["a"],
	_match_parsed_peg("b", undef, 0, ["zero_to_one", ["literal", "a"]])[_PARSED], []
	]
));
echo(_unit_test(
	"many_to_many",
	[
	_match_parsed_peg("", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], undef,
	_match_parsed_peg("a", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], undef,
	_match_parsed_peg("aa", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], ["aa"],
	_match_parsed_peg("aaa", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], ["aaa"],
	_match_parsed_peg("aaaa", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], ["aaaa"],
	_match_parsed_peg("aaaaa", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], ["aaaaa"],
	_match_parsed_peg("aaaaaa", undef, 0, ["many_to_many", ["literal", "a"], "25"])[_PARSED], ["aaaaa"],
	_match_parsed_peg("", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], undef,
	_match_parsed_peg("a", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], undef,
	_match_parsed_peg("aa", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], ["aa"],
	_match_parsed_peg("aaa", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], ["aaa"],
	_match_parsed_peg("aaaa", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], ["aaaa"],
	_match_parsed_peg("aaaaa", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], ["aaaaa"],
	_match_parsed_peg("aaaaaa", undef, 0, ["many_to_many", ["literal", "a"], [2, 5]])[_PARSED], ["aaaaa"],
	_match_parsed_peg("", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], undef,
	_match_parsed_peg("a", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], undef,
	_match_parsed_peg("aa", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], ["aa"],
	_match_parsed_peg("aaa", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], ["aaa"],
	_match_parsed_peg("aaaa", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], ["aaaa"],
	_match_parsed_peg("aaaaa", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], ["aaaaa"],
	_match_parsed_peg("aaaaaa", undef, 0, ["many_to_many", ["literal", "a"], "2"])[_PARSED], ["aaaaaa"],
	]
));

echo(_unit_test(
	"ref",
	[
	_match_parsed_peg("a", [["rule", "A", ["literal", "a"]]], 0, ["ref", 0])[_PARSED], [["A", "a"]],
	_match_parsed_peg("ab", 
		[
			["rule", "A", 
				["sequence",
					["literal", "a"],
					["ref", 1]
				]
			],
			["rule", "B", ["literal", "b"]]
		],
		0, ["ref", 0])[_PARSED], [["A", "a", ["B", "b"]]],
	_match_parsed_peg("a", [["private_rule", "A", ["literal", "a"]]], 0, ["ref", 0])[_PARSED], ["a"],
	_match_parsed_peg("ab", 
		[
			["private_rule", "A", 
				["sequence",
					["literal", "a"],
					["ref", 1]
				]
			],
			["rule", "B", ["literal", "b"]]
		],
		0, ["ref", 0])[_PARSED], ["a", ["B", "b"]],
	_match_parsed_peg("ab", 
		[
			["rule", "A", 
				["sequence",
					["literal", "a"],
					["ref", 1]
				]
			],
			["private_rule", "B", ["literal", "b"]]
		],
		0, ["ref", 0])[_PARSED], [["A", "ab"]],
	_match_parsed_peg("ab",
		[
			["sequence", 
				["ref", 1],
				["ref", 2],
			],
			["rule", "A",
				["literal", "a"]
			],
			["rule", "B", 
				["literal", "b"]
			]
		],
		0, ["ref", 0])[_PARSED], [["A", "a"], ["B", "b"]]
	]
));

