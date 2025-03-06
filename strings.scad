_strings_version = 
	[2022, 11, 5];
function strings_version() =
	_strings_version;
function strings_version_num() =
	_strings_version.x * 10000 + _strings_version.y * 100 + _strings_version.z;

include <vectors.scad>
include <logic.scad>



_ASCII_SPACE 	= 32;
_ASCII_0 		= 48;
_ASCII_9 		= _ASCII_0 + 9;
_ASCII_UPPER_A 	= 65;
_ASCII_UPPER_Z 	= _ASCII_UPPER_A + 25;
_ASCII_LOWER_A 	= 97;
_ASCII_CONVERT  = 97-65;
_ASCII_LOWER_Z 	= _ASCII_LOWER_A + 25;
_ASCII_UNDER    = chr( "_" );

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


// return "true" if the characters of "string" starting from the 
//  the given position, "pos", match the
//  given reference string, "refString"
//  ignore_case has the usual function
//
function starts_with(string, refString, pos=0, ignore_case=false ) =
	! is_string( string ) || !is_string( refString ) ?
		undef
	: pos >= len( string ) || pos < 0 || len( refString ) > len(string) ?
		false
	: refString == "" ?
		true
	: equals(	
		substring(string, pos, len(refString)), 
		refString, 
		ignore_case=ignore_case
		)
	;

// return "true" if the characters at the end of "string" 
//  match the given reference string, "refString"
//  ignore_case has the usual function
// obviously if the refString is longer than the given
//  string there can be no match
//  or if the refString is a null string
//
function ends_with( string, refString, ignore_case=false ) =
	! is_string( string ) || ! is_string( refString ) ?
		undef
	: len( refString ) > len(string) ?
		false
	: refString == "" ?
		true
	: equals(
		after(string, len(string)-len(refString)-1), 
		refString,
		ignore_case=ignore_case
		)
	;


function str_is_empty(string) = 
	! is_string( string ) ?
		undef
	: string == "";


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
		false
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


// return a string with leading and trailing whitespace removed
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


function is_in_range(code, min_code, max_code) = 
	is_undef( code ) || ! is_num( code ) ?
		undef
	: is_undef( min_code ) || is_undef( max_code ) ?
		undef
	: ! is_num( min_code ) || ! is_num( max_code ) ?
		undef
	: _is_in_range(code, min_code, max_code);

// function with no checking
function _is_in_range(code, min_code, max_code) =
	code >= min_code && code <= max_code;

function _is_variable_safe(code) = 
	code == undef || ! is_num( code ) ?
		undef
	: _is_in_range(code, _ASCII_0, _ASCII_9) ||
	  _is_in_range(code, _ASCII_UPPER_A, _ASCII_UPPER_Z) ||
	  _is_in_range(code, _ASCII_LOWER_A, _ASCII_LOWER_Z) ||
	  code == _ASCII_UNDER;

function equals(this, that, ignore_case=false) = 
	ignore_case?
		lower(this) == lower(that)
	:
		this==that
	;



// set all letters to "UPPER CASE"
function upper(string) = 
	is_undef( string ) ?
		undef
	: ! is_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	: _upper( string )
	;

function _upper(string) = 
	let(code = ascii_code(string))
	join([for (c = code)
			c >= _ASCII_LOWER_A && c <= _ASCII_LOWER_Z ?
                chr(c-_ASCII_CONVERT)
            :
                chr(c)
    	]);

// set all letters to "lower case"
function lower(string) = 
	is_undef( string ) ?
		undef
	: ! is_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	: _lower( string )
	;

function _lower(string) = 
	let(code = ascii_code(string), lastInd=len(code)-1)
    join( [for (c = code)
			c >= _ASCII_UPPER_A && c <= _ASCII_UPPER_Z?
                chr(c+_ASCII_CONVERT)
            :
                chr(c)
    	] )
		;

// set all letters to "Title Case"
function title(string) =
	is_undef( string ) ?
		undef
	: ! is_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	: _title( string )
	;

function _title(string) =
    let( lower_case_string = lower(string) )
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


// return a vector of the indexes of the instances of the delimiter
//  string in the given string. The delimiter instances are returned
//  from the resursion functions as [delim[0],follow[0]] meaning
//  that the first element is the first character of the instance,
//  and the second is the first character of the given string _following_
//  this delimiter instance.
// INPUTS
//  are checked for existance
//  if the delimiter string is longer than the one given it cannot
//  possibly match
function strIndexVector( string, delim ) =
	is_undef( string ) || is_undef(delim) ?
        undef
	: len( delim ) > len( string ) ?
		undef // cant possibly split
	:
		_index_of( string, delim ) // start with pos = 0
	;

// return a vector of the parts of string that are separated by the
//  delimitier string
// This is a recursive function that advances along the given string
//  until it is called with position at the end of the string
function _index_of( string, delim, pos=0  ) =
	pos >= len(string)?
		[] // we are done
	:
        _index_of_recurse( string, delim, _index_of_first( string, delim, pos=pos ), pos )
	;

// return a vector of the parts of a string separated by the delimiter string
//  it uses the delimiter vector returned by _index_of_first(), which comes to this
//  function in the index_of_first parameter.
//  if i_o_f is undefined it means there is no instance of the delimiter after the
//  given position.
function _index_of_recurse(string, delim, index_of_first, pos ) = 
    is_undef( index_of_first ) ?
        [] // the recursion to find the next delimiter instance failed
    : concat(
        [index_of_first], // i_o_f is [x,y] - [start of delimiter, rest of string]
        _coalesce_on(
				// recurse into the rest of the string, thus after i_o_f.y
            _index_of( string, delim, pos = index_of_first.y ),
            undef,
            [] 	// if _index_of returns undef then force i_o_r to return []
			)
   	 	);

// return a vector of first instance of the delimiter string
//  starting at the given position
// The delimiter instance is returned as [delim[0],follow[0]] meaning
//  that the first element is the first character of the instance,
//  and the second is the first character of the given string _following_
//  this delimiter instance.
function _index_of_first(string, delim, pos=0 ) =
	pos >= len(string)?
		undef // we have recursed to the end of the string
	: _coalesce_on(
			// we have recursed along the string to pos
			// so IF the index returned by _match is NOT undef
			//  we return it
		[pos, _match(string, delim, pos )], 
		[pos, undef],
			// ELSE the string at this position does not match the
			//  delimiter so we must recurse deeper to find the next
			//  delimiter instance, which will be a valid [del0,str0]
			//  vector
		_index_of_first(string, delim, pos+1 )
		)
    ;

// return a vector of the words in the given string
//  the default is to separate on space characters, but any
//  string can be used to separate blocks of text in the input
function strSplit( string, separator=" " ) =
	string == undef ?
		undef
	: str_is_empty(string) ?
		[]
	: _strSplit( string, _index_of( string, separator ) );

// INPUTS
//  the given string that we will extract words from
//  the list of delimeter instances
//  the index into the delimiter list that we are to consider
function _strSplit(string, indices, i=0) = 
    ! is_list ( indices ) ?
		[string]
	: len(indices) == 0?
        [string]
    : i >= len(indices)? // are we working on the last delimiter instance?
		let( lastIndex = len(indices)-1)
			// return the rest of the string, taking the index of the
			//  following word in the last delimiter instance as the 
			//  start of the .. that is the .y
			// IF after() returns the null string there is nothing
			//  after so we return the null list
        _coalesce_on(after(string, indices[lastIndex].y-1), "", [])
    : i == 0? // we are working on the first delimiter instance
			// IF there is a word before the first delimeter make that the first
			//  element of the list we will be returning
			// AND THEN recurse to the next instance ( i+1 )
        concat( _coalesce_on(before(string, indices[0].x), "", []), _strSplit(string, indices, i+1) )
    :
			// otherwise we are processing a delimiter instance between the first and last
			//  we extract the word from the string starting with the .y index of the PREVIOUS
			//  instance up to the beginning of the current delimiter instance, .x
			// AND THEN recurse further
        concat( between(string, indices[i-1].y, indices[i].x), _strSplit(string, indices, i+1) )
    ;




function join( arrayOfStrings, delimeter="") = 
	is_undef( arrayOfStrings ) || ! is_list( arrayOfStrings ) ?
		undef
	: arrayOfStrings == []?
		""
	: _join(arrayOfStrings, len(arrayOfStrings)-1, delimeter);

function _join( arrayOfStrings, index, delimeter) = 
	index==0 ? 
		arrayOfStrings[index] 
	: str( _join( arrayOfStrings, index-1, delimeter), 
			delimeter,
			arrayOfStrings[index]
			) ;
	
// return string if it is valid, else use the replacement
// this is using recursion to assemble a result list, or string,
// as we iterate along an given list or string, processing each
// element in some way
function _null_coalesce(string, replacement) = 
	is_undef( string ) ? replacement : string ;

// return value IFF it is valid, else use the fallback
// this is using recursion to assemble a result list, or string,
// as we iterate along an given list or string, processing each
// element in some way
function _coalesce_on( value, error, fallback ) = 
	value == error? fallback : value;
	
