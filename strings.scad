_strings_version = 
	[2022, 11, 5];
function strings_version() =
	_strings_version;
function strings_version_num() =
	_strings_version.x * 10000 + _strings_version.y * 100 + _strings_version.z;






_ASCII_SPACE 	= 32;
_ASCII_0 		= 48;
_ASCII_9 		= _ASCII_0 + 9;
_ASCII_UPPER_A 	= 65;
_ASCII_UPPER_Z 	= _ASCII_UPPER_A + 25;
_ASCII_LOWER_A 	= 97;
_ASCII_LOWER_Z 	= _ASCII_LOWER_A + 25;

_CHAR_SPC = " ";	// blank
_CHAR_TAB = "\t";	// tabchar
_CHAR_NL  = "\n";	// new line char
_CHAR_RET = "\r";	// carriage return char

// _ASCII_SPACE must be the first element in the
//  white space string and its derivatives for the
//  is_whitespace function to work correctly
_WHITESPACE = " \t\n\r"; // tab return newline blank

// the double quote (") and backslash (\) are escaped by a backslash
_ASCII_VISIBLE = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
_ASCII = str( _WHITESPACE, _ASCII_VISIBLE );

_ASCII_OLD = " \t\n\r!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";

_ASCII_HACK = "\""; // only here to work around syntax highlighter deficiencies in certain text editors
// likewise ...

openParen = "(";
closParen = ")";
openBrace = "{";
closBrace = "}";
openBrack = "[";
closBrack = "]";


// return a vector with the ASCII code values for each character in the string
// simpler version doing same function
function ascii_code( string ) = 
	!is_string(string)?
		undef
    : [for( c=string ) ord(c) <= _ASCII_LOWER_Z+4 ? ord(c) : undef ]
	;




function _grep(string, indices) = 
    [for (index = indices)
        between(string, index.x, index.y)
    ];


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
    

// return "true" if the characters of "string" starting from the 
//  the given position, "pos", match the
//  given reference string, "start"
//  ignore_case has the usual function
//
function starts_with(string, start, pos=0, ignore_case=false ) = 
	equals(	
		substring(string, pos, len(start)), 
		start, 
		ignore_case=ignore_case
		)
	;

function ends_with(string, end, ignore_case=false) =
	equals(
		after(string, len(string)-len(end)-1), 
		end,
		ignore_case=ignore_case
		)
	;


/*
this functions will be removed in a future update
in OpenSCAD language there is no way to update container,
or any element of a container, after it has a value
assigned.
This means that there is no way to update a container
as needed for push and pop statments.
OS functions can only return a single item so returning
the updated stack container along with an element beginning
popped off of it is not possible.
returning a vector that has its length in its 0-th element
and the stack in the following elements can be done, but
every push and pop will create a new vector and the program
will not know .. cannot know .. which one is current.
When Objects are available in a future release it may be
possible to hold a stack as an object member that can 
be changed in lenght and have elements added and deleted,
but till then a stack implementation is not possible

function _pop(stack, n=1) = 
	n <= 1?
		len(stack) <=0? [] : stack[1]
	:
		_pop(_pop(stack), n-1)
	;

function _push(stack, char) = 
	[char, stack];

 */

/*
// implement a stack in a vector
//  also not actually going to work
globalStack[] = 0; // create an empty stack
globalStackLen = 0;
function orig_pop() = 
	len( globalStack ) > 0 ?
		let( return = globalStack[0],
			globalStackLen = globalStackLen - 1,
			globalStack = [ for( i=1:globalStackLen) globalStack[i] ]
			)
		globalStack[0]
	:
		[]
	;

function _push( item ) =
	let( globalStack = [ item, globalStack ],
		globalStackLen = globalStackLen + 1
	)
	globalStackLen
	;
 */


// no need to override the OpenSCAD is_string 
//function is_string(x) = 
//	x == str(x);

// return true if the given string exists and has no characters in it
//  return undef if the input is undefined
function str_is_empty(string) = 
	! is_string( string ) ?
		undef
	: 
		string == ""
	;

// return true if any of the characters in the given string is
//  NOT a space character ( " " )
//  Check this by making a string of all the non-whitespace characters
//  in the string. If the length of the created string is 0 (or less) 
//  then the input is all spaces.
// NOTE that this is not testing for ALL whitespace characters in
//  _WHITESPACE, only for _CHAR_SPC ( " " )
function str_is_allspaces(string) = 
	! is_string( string ) ?
		undef
	: len( string ) <= 0 ?
		""
	: len([for (char=string)
			if(char != _CHAR_SPC ) char]
		) < 1
	;

// unused function
function str_is_null_or_empty(string) = 
	is_undef(string) || string == "";


// unused function
function str_is_null_or_allspaces(string) = 
	str_is_null_or_empty(string) || str_is_allspaces( string );


// return a string with all whitespace characters removed
//  from the start and end of the given string
function trim(string) = 
	is_undef( string ) ?
		undef 
	: ! is_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	:
		_null_coalesce(
			between(string, 
				_match_set(string, _WHITESPACE, 0), 
				_match_set_reverse(string, _WHITESPACE, len(string))
				),
			""
			)
	;

// return index of a character in set that matches string
//  starting from the beginning of the string
function _match_set(string, set, pos) = 
	pos >= len(string)?
		len(string) // we have recursed off the end of the string - return
	: is_in(string[pos], set )?
		_match_set(string, set, pos+1)
	: 
		pos
	;

// return index of a character in set that matches string
//  starting from the end of the string
function _match_set_reverse(string, set, pos) = 
	pos <= 0?
		0
	: is_in(string[pos-1], set)?
		_match_set_reverse(string, set, pos-1)
	: 
		pos
	;


function is_in( char, list, ignore_case=false) = 
	is_undef( char ) ?
		false
    : ! is_string(  char ) ?
		false
    : any([ 
		for (i = [0:len(list)-1]) 
			equals( char, list[i], ignore_case=ignore_case )
		])
	;


function _is_in_range(code, min_char, max_char) = 
	code == undef ?
		undef
	: code >= min_char && code <= max_char;

function _is_variable_safe(code) = 
	code == undef ?
		undef
	: _is_in_range(code, _ASCII_0, _ASCII_9) ||
	  _is_in_range(code, _ASCII_UPPER_A, _ASCII_UPPER_Z) ||
	  _is_in_range(code, _ASCII_LOWER_A, _ASCII_LOWER_Z) ||
	  chr(code) == "_";

function equals(this, that, ignore_case=false) = 
	ignore_case?
		lower(this) == lower(that)
	:
		this==that
	;



// set all letters to "UPPER CASE"
function upper(string) = 
	let(code = ascii_code(string))
	join([for (i = [0:len(string)-1])
			code[i] >= _ASCII_LOWER_A && code[i] <= _ASCII_LOWER_Z?
                chr(code[i] - _ASCII_LOWER_A + _ASCII_UPPER_A)
            :
                string[i]
		]);

// set all letters to "lower case"
function lower(string) = 
	let(code = ascii_code(string))
	join([for (i = [0:len(string)-1])
			code[i] >= _ASCII_UPPER_A && code[i] <= _ASCII_UPPER_Z?
                chr(code[i] + _ASCII_LOWER_A - _ASCII_UPPER_A )
            :
                string[i]
		]);

// set all letters to "Title Case"
function title(string) =
    let(lower_case_string = lower(string))
    join([
		for (word = split(lower_case_string))
        	join( [upper(word[0]), lower(after(word, 0))], "")
    	], " ");
   

function reverse(string) = 
	string == undef?
		undef
	: ! is_string( string ) ?
		undef
	: len(string) <= 0?
		""
	: 
        join([for (i = [0:len(string)-1]) string[len(string)-1-i]])
    ;

//returns a string starting at the "start" index taking the
// next "length" characters
// if length is not given then the rest of the string after
// "start" is taken
function substring(string, start, length=undef) = 
	string == undef || start == undef?
		undef
	: start > len(string) ?
		undef
	: length == undef? 
		after(string, start-1 )  
	: length <=0?
		""
	:	between(string, start, start + length)
	;

//note: start is inclusive, end is exclusive
function between(string, start, end) = 
	string == undef || start == undef ||
	end == undef    || end <0 ||
	start > end ?
		undef
	: start > len(string)?
		undef
	: start < 0?
		before(string, end)
	: end > len(string)?
		after(string, start-1)
	: start == end ? 
		"" 
	: 
        join([for (i=[start:end-1]) string[i]])
	;

function before(string, index=0) = 
	string == undef?
		undef
	: index == undef?
		undef
	: index > len(string)?
		string
	: index <= 0?
		""
	: 
        join([for (i=[0:index-1]) string[i]])
	;

// returns the string after index, so specifically not
// including the index character
function after(string, index=0) =
	string == undef || index == undef?
		undef
	: index < 0?
		string
	: index >= len(string)-1?
		""
	:
        join([for (i=[index+1:len(string)-1]) string[i]])
	;
	

	

function parse_int(string, base=10) = 
	string[0] == "-" ? 
		-1*_parse_int(string, base, 1) 
	: 
		_parse_int(string, base);

function _parse_int(string, base, i=0, sum=0) = 
	i == len(string) ? 
		sum
	: 
		sum + _parse_int(string, base, i+1, 
				search(string[i],"0123456789ABCDEF")[0]*pow(base,len(string)-i-1));

function parse_float(string) = 
	string[0] == "-" ? 
		-1*parse_float(after(string,0))
	: 
		_parse_float(split(string, "."));

function _parse_float(sections)=
    len(sections) == 2?
        _parse_int(sections[0], 10) + _parse_int(sections[1], 10)/pow(10,len(sections[1]))
    :
        _parse_int(sections[0], 10) 
    ;


function join(strings, delimeter="") = 
	strings == undef?
		undef
	: strings == []?
		""
	: _join(strings, len(strings)-1, delimeter);

function _join(strings, index, delimeter) = 
	index==0 ? 
		strings[index] 
	: str(_join(strings, index-1, delimeter), delimeter, strings[index]) ;
	

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
	
