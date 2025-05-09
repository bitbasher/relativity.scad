_pegs_version = 
	[2025, 02, 28];
function pegs_version() =
	_pegs_version;
function pegs_version_num() =
	_pegs_version.x * 10000 + _pegs_version.y * 100 + _pegs_version.z;

include <strings.scad>

// PUBLIC FACING PEG
// unused function
// return xxx from applying the "string" to the given grammar, as encoded into peg format
function peg(string, grammar) = _match_parsed_peg(string, _index_peg_refs(grammar));


// unused function
// return a rule from the peg given the reference ( ref )
function _get_rule(peg, ref) = 
	[for (rule = peg) if(rule[1] == ref) rule ] [0];



// PEG ENGINE
// definitions for use with _match_parsed_peg
_PARSED = 0; // the first item in the returned vector is the parsed regex specification
_POS = 1;    // the 1-st item is ???

// return
// given the input string, and the position in that string to start parsing at
//  string_code : the input string as a vactor of ascii codes
//  the PEG definition
//  the PEG opcode of the item
//  and wether to ignore case of the letters in string
//
// return the rule that matches the opcode currently in process
function _match_parsed_peg( string, peg, string_pos=0, peg_op=undef,  ignore_case=false, string_code=undef ) =
	let(
		opcode = peg_op[0],
		operands = _slice(peg_op, 1)
	)

	string == undef?
		undef
    : string_pos > len(string)?
        undef

    : peg != undef && peg_op == undef?
    	_match_parsed_peg(	string, peg, string_pos, peg[1], 
    						 ignore_case=ignore_case, string_code=string_code )
    						 
    : string_code == undef?
    	_match_parsed_peg( string, peg, string_pos, peg_op, ignore_case=ignore_case, string_code=ascii_code(string) )
    
    : opcode == "grammar"?
    	_match_parsed_peg(	string, peg_op, string_pos, peg_op[1],
							 ignore_case=ignore_case, string_code=string_code )[_PARSED][0]
	: opcode == "rule"?
		let(result = _match_parsed_peg(	string, peg, string_pos, operands[1],  
										ignore_case=ignore_case, string_code=string_code ))
		result != undef?
			[[concat( [operands[0]], result[_PARSED] )], result[_POS]]
		: 
			undef
	: opcode == "private_rule"?
		let(result = _match_parsed_peg(	string, peg, string_pos, operands[1],  
										ignore_case=ignore_case, string_code=string_code ))
		result != undef?
			result
		: 
			undef
	: opcode == "ref"?
		len(peg) > operands[0]?
			_match_parsed_peg(string, peg, string_pos, peg[operands[0]], ignore_case=ignore_case, string_code=string_code )
		:
			["ERROR: unrecognized ref id, '"+operands[0]+"'"]

	// BINARY
	: opcode == "choice"?
		let( option = _match_parsed_peg(string, peg, string_pos, operands[0], ignore_case=ignore_case, string_code=string_code ) )
		option != undef?
			option
		: len(operands) < 2?
			undef
		: 
			_match_parsed_peg(string, peg, string_pos, concat(opcode, _slice(operands, 1)), ignore_case=ignore_case, string_code=string_code )
	: opcode == "sequence"?
		let( first = _match_parsed_peg(string, peg, string_pos, operands[0], ignore_case=ignore_case, string_code=string_code ) )
		first == undef?
			undef
		: len(operands) == 1?
			first
		: 
			let( rest = _match_parsed_peg(string, peg, first[_POS], concat(opcode, _slice(operands, 1)), ignore_case = ignore_case) )
			rest == undef?
				undef
			: is_string(first[_PARSED][0]) && is_string(rest[_PARSED][0])?
				[[str(first[_PARSED][0], rest[_PARSED][0])], rest[_POS]]
			: 
				[concat(first[_PARSED], rest[_PARSED]), rest[_POS]]

	// PREFIX
	: opcode == "positive_lookahead"?
		_match_parsed_peg(string, peg, string_pos, operands[0], ignore_case=ignore_case, string_code=string_code ) != undef?
			[[], string_pos]
		: 
			undef
	: opcode == "negative_lookahead"?
		_match_parsed_peg(string, peg, string_pos, operands[0], ignore_case=ignore_case, string_code=string_code ) == undef?
			[[], string_pos]
		: 
			undef

	// POSTFIX
	: opcode == "one_to_many"?
		_match_parsed_peg(string, peg, string_pos, 
			["sequence", operands[0], ["zero_to_many", operands[0]]	], 
			ignore_case=ignore_case, string_code=string_code 
			)
	: opcode == "zero_to_many"?
		_match_parsed_peg(string, peg, string_pos, 
			["choice", 
				["sequence", operands[0], ["zero_to_many", operands[0]] ], 
				["empty_string"]
			], 
			ignore_case=ignore_case, string_code=string_code 
			)
	: opcode == "many_to_many"?
		let(min = operands[1][0],
			max = operands[1][1])
		let(min = is_string(min)? parse_int(min) : min,
			max = 
				max == undef? 
					undef 
				: is_string(max)? 
					parse_int(max)
				:
					max
			)
		min == undef?
			undef
		: max == undef?
			_match_parsed_peg(string, peg, string_pos,
				concat(["sequence"], 
						[for (i = [0:min-1])
							operands[0]
						],
						[["zero_to_many", operands[0]]]
					),
				ignore_case=ignore_case, string_code=string_code
				)	
		: max < 0 || min > max?
			undef
		:
			_match_parsed_peg(string, peg, string_pos,
				concat(["sequence"], 
						[for (i = [0:min-1])
							operands[0]
						],
						[for (i = [min:max-1])
							["zero_to_one", operands[0]]
						]
					),
				ignore_case=ignore_case, string_code=string_code
				)
	: opcode == "zero_to_one"?
		_match_parsed_peg(string, peg, string_pos, 
			["choice",
				operands[0],
				["empty_string"]
			], 
			ignore_case=ignore_case, string_code=string_code 
			)
			
			
	// PRIMITIVES
	: opcode == "literal"?
		!starts_with(string, operands[0], string_pos, ignore_case=ignore_case) ?
			undef
		:
			[ 
				[between(string, string_pos, string_pos+len(operands[0]))], 
				string_pos+len(operands[0]) 
			]
	: opcode == "positive_character_set"?
		let(matches		= 
			[ for (arg = operands)
				arg == str(arg)?
					equals(string[string_pos], arg, ignore_case=ignore_case)
				:
					_match_parsed_peg(string, peg, string_pos, arg, ignore_case=ignore_case, string_code=string_code ) != undef
			])
		
		!any(matches)?
			undef
		:
			[ [string[string_pos]], string_pos+1 ]
	: opcode == "negative_character_set"?
		let(matches	= 
			[ for (arg = operands)
				arg == str(arg)?
					equals(string[string_pos], arg, ignore_case=ignore_case)
				:
					_match_parsed_peg(string, peg, string_pos, arg, ignore_case=ignore_case, string_code=string_code ) != undef
			]
			)
		any(matches)?
			undef
		:
			[ [string[string_pos]], string_pos+1 ]
	: opcode == "character_range"?
		!_is_in_range(string_code[string_pos], ascii_code(operands[0][0])[0], ascii_code(operands[0][1])[0])?
			undef
		:
			[ [string[string_pos]], string_pos+1 ]
	: opcode == "character_literal"?
		!equals(string[string_pos], operands[0], ignore_case=ignore_case)?
			undef
		:
			[ [string[string_pos]], string_pos+1 ]
	: opcode == "character_set_shorthand"?
		operands[0] == "s" && !_is_in_range(string_code[string_pos], 0, _ASCII_SPACE)? //whitespace
			undef
		: operands[0] == "S" && _is_in_range(string_code[string_pos], 0, _ASCII_SPACE)? //nonwhitespace
			undef
		
		: operands[0] == "d" && !_is_in_range(string_code[string_pos], _ASCII_0, _ASCII_9)? //digit
			undef
		: operands[0] == "D" && _is_in_range(string_code[string_pos], _ASCII_0, _ASCII_9)? //nondigit
			undef
		
		: operands[0] == "w" && !_is_variable_safe(string_code[string_pos])? // word character
			undef
		: operands[0] == "W" && _is_variable_safe(string_code[string_pos])? //non word character
			undef

		: !is_in(operands[0], "sSdDwW") && !equals(string[string_pos], operands[0], ignore_case=ignore_case)? // literal
			undef

		: [ [string[string_pos]], string_pos+1 ]

	: opcode == "wildcard"?
		string[string_pos] == undef?
			undef
		: [ [string[string_pos]], string_pos+1 ]

	: opcode == "start"?
		string_pos == 0?
			[[], string_pos]
		: undef

	: opcode == "end"?
		string_pos == len(string)?
			[[], string_pos]
		:
			undef
	: opcode == "private"?
		let( result = _match_parsed_peg(string, peg, string_pos, operands[0], ignore_case=ignore_case, string_code=string_code))
		result == undef?
			undef
		: [[], result[_POS]]

	: opcode == "empty_string"?
		[[], string_pos]
    : 
        ["ERROR: unrecognized opcode, '"+opcode+"'"]
	;
	
// PEG SYMBOL LINKER

function _get_rule_index(rule, indexer) = 
	[for (i = [0:len(indexer)-1]) 
		if(indexer[i] == rule) i+1
	] [0];


// this function returns either
//   the root peg operand
// or
//   a "ref" opcode with its rules
// or
//   <for all other opcodes>
//   opcode with its operands by recursion
function _index_peg_op_refs(peg_op, indexer) = 
	let(
			opcode = peg_op[0],
			operands = _slice(peg_op, 1)
		)
	peg_op == str(peg_op)?
		peg_op
	: opcode == "ref"?
		["ref", _get_rule_index(operands[0], indexer)]
	:
		concat(opcode, [for (operand = operands) _index_peg_op_refs(operand, indexer)])
    ;

// return an index to the ref items in the "peg"
function _index_peg_refs(peg) = 
	// first form a vector of all of the rules in the peg
	let ( rules = [for (rule = _slice(peg, 1)) rule[1] ] )

	_index_peg_op_refs(peg, rules);




// create the constant "peg" that holds the definition of the grammar language used to encode regex's 
_rx_peg = 
_index_peg_refs
(
	["grammar",
		["private_rule", "operation",
			["sequence",
				["choice",
					["ref", "choice"],
					["ref", "sequence"],
					["ref", "postfix"],
				],
				// ["negative_lookahead", ["wildcard"]],
			]
		],
		["private_rule", "postfix",
			["choice",
				["ref", "many_to_many"],
				["ref", "one_to_many"],
				["ref", "zero_to_many"],
				["ref", "zero_to_one"],
				["ref", "primitive"]
			],
		],

		//BINARY OPERATIONS
		["rule", "choice",
			["sequence",
				["choice", 
					["ref", "sequence"],
					["ref", "postfix"]
				],
				["one_to_many",
					["sequence",
						["private", ["literal", "|"]],
						["choice", 
							["ref", "sequence"],
							["ref", "postfix"]
						],
					]
				]
			]
		],
		["rule", "sequence",
			["sequence",
				["ref", "postfix"],
				["one_to_many",
					["ref", "postfix"],
				 ]
			]
		],

		["rule", "positive_lookahead",
			["sequence",
				["private", ["literal", "(?="]],
				["ref", "operation"],
				["private", ["literal", ")"]],
			]
		],
		["rule", "negative_lookahead",
			["sequence",
				["private", ["literal", "(?!"]],
				["ref", "operation"],
				["private", ["literal", ")"]],
			]
		],

		//UNARY POSTFIX OPERATIONS
		["rule", "one_to_many",
			["sequence",
				["ref", "primitive"],
				["private", ["literal", "+"]]
			]
		],
		["rule", "zero_to_many",
			["sequence",
				["ref", "primitive"],
				["private", ["literal", "*"]]
			]
		],
		["rule", "zero_to_one",
			["sequence",
				["ref", "primitive"],
				["private", ["literal", "?"]]
			]
		],
		["rule", "many_to_many",
			["sequence",
				["ref", "primitive"],
				["private", ["literal", "{"]],
				["character_set_shorthand", "d"],
				["zero_to_one",
					["sequence",
						["private", ["literal", ","]],
						["character_set_shorthand", "d"],
					],
				],
				["private", ["literal", "}"]],
			]
		],

		//PRIMITIVES
		["private_rule", "primitive",
			["choice",
				["ref", "start"],
				["ref", "end"],
				["ref", "wildcard"],
				["ref", "character_set_shorthand"],
				["ref", "negative_character_set"],
				["ref", "positive_character_set"],
				["ref", "negative_lookahead"],
				["ref", "positive_lookahead"],
				["sequence",
					["private", ["literal", "("]],
					["ref", "operation"],
					["private", ["literal", ")"]],
				],
				["ref", "literal"],
			],
		],

		["rule", "start",
			["private", ["literal", "^"]],
		],
		["rule", "end",
			["private", ["literal", "$"]],
		],
		["rule", "wildcard",
			["private", ["literal", "."]],
		],
		["rule", "literal", 
			["negative_character_set", 
				"{","}","[","]","(",")", 
				"|","*","+","?",".","\\",".",
				"^","$",
			],
		],
		["rule", "positive_character_set",
			["sequence",
				["private", ["literal", "["]],
				["one_to_many",
					["choice",
						["ref", "character_range"],
						["ref", "character_set_shorthand"],
						["ref", "character_literal"]
					]
				],
				["private", ["literal", "]"]],
			]
		],
		["rule", "negative_character_set",
			["sequence",
				["private", ["literal", "[^"]],
				["one_to_many",
					["choice",
						["ref", "character_range"],
						["ref", "character_set_shorthand"],
						["ref", "character_literal"]
					]
				],
				["private", ["literal", "]"]],
			]
		],
		["rule", "character_literal",
			["negative_character_set", "]"]
		],
		["rule", "character_range",
			["sequence",
				["character_set_shorthand", "w"],
				["private", ["literal", "-"]],
				["character_set_shorthand", "w"],
			],
		],
		["rule", "character_set_shorthand",
			["sequence", 
				["private", ["literal", "\\"]],
				["positive_character_set",
					"s","S","d","D","w","W", "\\", "]", "(", ")"
				]
			]
		],
	]
);


// return a vector, the first element of the _PARSED (0-th) element of the peg constant 
// selected by the given ( rx ) 
// using the _rx_peg grammar definition constant as the
//  language specification
function _parse_rx(rx) = 
	_match_parsed_peg(rx, _rx_peg)[_PARSED][0];


// unused function - at least .. only used in function _match_regex() 
// return a the _POS ( 1-st )element of the vector returned from _match_parsed_peg()
//  given the regex definition vector and the starting position in the string
function _match_parsed_rx(string, regex, string_pos=0, ignore_case=false) = 
	_match_parsed_peg(string, 
		undef, 
		string_pos=string_pos, 
		peg_op=regex, 
		ignore_case=ignore_case)[_POS];


// unused function
// return a number ?? 
function _match_regex(string, pattern, pos=0, ignore_case=false) =
	_match_parsed_rx(
		string,
		regex=_parse_rx(pattern),
		string_pos=pos,
		ignore_case=ignore_case
	);





//returns a list representing the tokenization of an input string
//echo(tokenize("not(foo)"));
//echo(tokenize("foo bar baz  "));

_token_regex_ignore_space = _parse_rx("\\w+|\\S");
_token_regex = _parse_rx("\\w+|\\S|\\s+");


function _grep(string, indices) = 
    [for (index = indices)
        between(string, index.x, index.y)
    ];


function tokenize(string, ignore_space=true) = 
    _tokenize(string, ignore_space? _token_regex_ignore_space : _token_regex);

function _tokenize(string, pattern) = 
    _grep(string, _index_of(string, pattern, regex=true));

function grep(string, pattern, ignore_case=false) =
    _grep(string, _index_of(string, _parse_rx(pattern), regex=true, ignore_case=ignore_case));


function replace(string, replaced, replacement, ignore_case=false, regex=false) = 
	_replace(string, replacement, index_of(string, replaced, ignore_case=ignore_case, regex=regex));
    
function _replace(string, replacement, indices, i=0) = 
    i >= len(indices)?
        after(string, indices[len(indices)-1].y-1)
    : i == 0?
        str( before(string, indices[0].x), replacement, _replace(string, replacement, indices, i+1) )
    :
        str( between(string, indices[i-1].y, indices[i].x), replacement, _replace(string, replacement, indices, i+1) )
    ;


function split(string, separator=" ", ignore_case = false) =
	string == undef ?
		undef
	: str_is_empty(string) ?
		[]
	: _split(string, index_of(string, separator, ignore_case=ignore_case), i=0);
    
function _split(string, indices, i=0) = 
    ! is_list ( indices ) ?
		[string]
	: len(indices) == 0?
        [string]
    : i >= len(indices)?
        _coalesce_on(after(string, indices[len(indices)-1].y-1), "", [])
    : i == 0?
        concat( _coalesce_on(before(string, indices[0].x), "", []), _split(string, indices, i+1) )
    :
        concat( between(string, indices[i-1].y, indices[i].x), _split(string, indices, i+1) )
    ;

function contains(string, substring, ignore_case=false, regex=false) = 
	regex?
        _index_of_first(string, _parse_rx(substring), pos=0, ignore_case=ignore_case, regex=regex ) != undef
	:
		_index_of_first(string, substring, pos=0, ignore_case=ignore_case, regex=regex ) != undef
	; 


// return a vector of the parts of string that match the pattern, or regex specification
//  pattern is a vector that contains either:
//    a simple pattern to match
//   or
//    a regular expression specification
//  ignore_case - true to match without considering case of alphabetic characters
//  regex - true to treat pattern as a regex specification, else as a simple pattern
//
function index_of(string, pattern, ignore_case=false, regex=false) =
	// make pattern into a regex definition if required
	let( regexSpec = regex ? _parse_rx(pattern) : pattern )

	_index_of(
		string, 
        regexSpec,
		pos = 0,
        ignore_case=ignore_case,
		regex=regex
		);

// return a vector of the parts of string that match the pattern, or regex specification
// 
function _index_of(string, pattern, pos=0, ignore_case=false, regex=false ) =
	pos == undef?
        undef
	: pos >= len(string)?
		[] // we are done
	:
        _index_of_recurse(
			string,
			pattern, 
            _index_of_first( string, pattern, pos=pos, ignore_case=ignore_case, regex=regex),
            pos,
			ignore_case,
			regex
			)
	;

function _index_of_recurse(string, pattern, index_of_first, pos, ignore_case, regex ) = 
    index_of_first == undef?
        []
    : concat(
        [index_of_first],
        _coalesce_on(
            _index_of(
				string,
				pattern, 
                pos = index_of_first.y,
                ignore_case=ignore_case,
				regex=regex
				),
            undef,
            []
			)
   	 	);

function _index_of_first(string, pattern, pos=0, ignore_case=false, regex=false) =
	pos == undef?
        undef
    : pos >= len(string)?
		undef
	: _coalesce_on(
		[pos, _match(string, pattern, pos, ignore_case=ignore_case, regex=regex)], 
		[pos, undef],
		_index_of_first(string, pattern, pos+1, ignore_case=ignore_case, regex=regex )
		)
    ;

 function _match(string, pattern, pos, ignore_case=false, regex=false ) = 
    regex?
    	_match_parsed_peg(string, undef, pos, peg_op=pattern, ignore_case=ignore_case)[_POS]

    : starts_with(string, pattern, pos, ignore_case=ignore_case)? 
        pos+len(pattern) 
    : 
        undef
    ;
    




function _null_coalesce(string, replacement) = 
	string == undef?
		replacement
	:
		string
	;
function _coalesce_on(value, error, fallback) = 
	value == error?
		fallback
	: 
		value
	;
	
