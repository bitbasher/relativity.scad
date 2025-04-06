_strings_version = 
	[2025, 03, 29, 1];
function strings_version() =
	_strings_version;
function strings_version_num() =
	_strings_version.x * 10000 + 
	_strings_version.y * 100 +
	_strings_version.z +
	_strings_version[3] / 10 ;

include <vectors.scad>
include <logic.scad>
include <newsplit.scad>
include <numbers.scad>
include <recursion.scad>

_ASCII_SPACE 	= 32;
_ASCII_0 		= 48;
_ASCII_9 		= _ASCII_0 + 9;
_ASCII_UPPER_A 	= 65;
_ASCII_UPPER_Z 	= _ASCII_UPPER_A + 25;
_ASCII_LOWER_A 	= 97;
_ASCII_CONVERT  = 97-65;
_ASCII_LOWER_Z 	= _ASCII_LOWER_A + 25;
_ASCII_UNDER    = ord( "_" );

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


// return "true" if the characters of "string", starting from the 
//  the given position, "pos", match the given reference string,
//  "refString".
// "ignore_case" has the usual meaning
//
function starts_with(string, refString, pos=0, ignore_case=false ) =
	is_not_string( string ) || is_not_string( refString ) ?
		undef
	: pos >= len( string ) || pos < 0 ?
		undef
	: refString == "" ?
		false
	: len( refString ) > len(string) || pos+len( refString )-1 > len(string)-1 ?
		undef
	:	// equals handles the case checking
		_str_equals(
			str_sub_from_for(string, pos, len(refString)), 
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
	: _str_equals(
		after(string, len(string)-len(refString)-1), 
		refString,
		ignore_case=ignore_case
		)
	;

function is_not_string( string ) =
	is_undef( string ) || ! is_string( string );


// return true if the given string is empty
//  but it must exist or we return undef
function str_is_empty(string) = 
	is_not_string( string ) ?
		undef
	: 
		string == ""
	;


// return true when given string is undefined, OR
//  is empty, meaning the null string ( "" )
//  or undef if the input is not a string
function str_is_undef_or_empty(string) = 
	! is_string( string ) ?
		undef
	: is_undef(string) || string == "" ;


// unused function
function str_is_null_or_allspaces(string) = 
	str_is_undef_or_empty(string) || str_is_allspaces( string );


// return true if any of the characters in the given string is
//  NOT a space character ( " " )
//  Check this by making a string of all the non-whitespace characters
//  in the string. If the length of the created string is 0 (or less) 
//  then the input is all spaces.
// NOTE that this is not testing for ALL whitespace characters in
//  _WHITESPACE, only for _CHAR_SPC ( " " )
function str_is_allspaces(string) = 
	is_not_string( string ) ?
		undef
	: str_is_empty( string ) ?
		false
	: len([for (char=string)
			if(char != _CHAR_SPC ) char]
		) < 1
	;


// return a string with leading and trailing whitespace removed
function trim(string) = 
	is_not_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	:	// if str_between_indecies returns undef then return empty string
		_null_coalesce(
			str_between_indecies(string, 
				_match_set(string, _WHITESPACE, 0), 
				_match_set_reverse(string, _WHITESPACE, len(string))
				),
			""
			)
	;


// compare the given pattern against the given string at pos
// If it matches return the position in string AFTER the pattern.
// starts_with() does all the checking for correct inputs
//  and will return "false" if pattern=="" or the pattern
//  does not match .. but functions using _match() use
//  the on_coalesce() recursion function so all cases of
//  failure to match are coerced to undef
function _match(string, pattern, pos, ignore_case=false ) = 
    let( result = starts_with(string, pattern, pos, ignore_case=ignore_case) )
	is_undef( result ) || ! result ?
		undef
    : pos+len(pattern) ;
    

/*
	Return the index of the NEXT char in string that does NOT
	 match any of the characters in the set.
	"pos", when given, is the index of the character in string
	 being checked at its level of recursion
	"pos" at its default of 0 tests the character against the set
	 and if it is in the set, recurses to check the pos+1 char
	else return the current position 
	when we enter this function with pos at or past the end of
	 string, then we return the length of the string as that is
	 in theory, the next character after the matched set.
	so, for default pos and no characters matching we return input
	 pos, or zero
	 for pos at endof string we return the length of the string,
	 which is the index just after that of the last character in 
	 the matched set.
 */
function _match_set( string, set, pos=0 ) =
	let( lenStr = len( string ) ) // maybe should be last index?

	pos >= lenStr ? // we are past the last char of string
		lenStr
	: _is_in_set( string[pos], set ) ?
		_match_set( string, set, pos+1 )
	: 
		pos // index of first char NOT in the set at this level of recursion
	;

// return index of any character of "set" that occurs in the
//  given string starting from the end of the string
function _match_set_reverse(string, set, pos) = 
	pos <= 0?
		0
	: _is_in_set(string[pos-1], set) ?
		_match_set_reverse(string, set, pos-1)
	: 
		pos
	;

// return true if the given character is in the given set
//  char must be a string containing a single character
//  set must be a string of valid ASCII characters
function _char_in_set( char, set, ignore_case=false ) =
	is_not_string(  char ) ?
		false // TODO maybe undef ?
	: str_is_undef_or_empty( set ) ?
		false // TODO maybe undef ?
	: len( char ) != 1 ?
		false // TODO maybe undef ?
	: 
		any([ 
			for (i = [0:len(set)-1]) _str_equals( char, set[i], ignore_case=ignore_case )
			])
	;
 
 // no checking version of char in set
function _is_in_set( char, set, ignore_case=false ) =
    any([ 
		for (i = [0:len(set)-1]) _str_equals( char, set[i], ignore_case=ignore_case )
		])
	;

function _is_variable_safe(code) = 
	is_not_num( code ) ?
		undef
	: _code_in_range(code, _ASCII_0, _ASCII_9) ||
	  _code_in_range(code, _ASCII_UPPER_A, _ASCII_UPPER_Z) ||
	  _code_in_range(code, _ASCII_LOWER_A, _ASCII_LOWER_Z) ||
	  code == _ASCII_UNDER;

function str_equals(this, that, ignore_case=false) = 
	is_not_string(this) || is_not_string(that) ?
		undef
	: len(this) != len(that) ?
		false 
	: ignore_case ?
		lower(this) == lower(that)
	:
		this==that
	;

function _str_equals(this, that, ignore_case=false) = 
	ignore_case ?
		_lower(this) == _lower(that)
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
	str_vector_join([for (c = code) 
			_code_in_range( c, _ASCII_LOWER_A, _ASCII_LOWER_Z ) ?
                chr(c-_ASCII_CONVERT)
            :
                chr(c)
    	]);

// set all letters to "lower case"
function lower(string) = 
	is_not_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	: _lower( string )
	;

function _lower(string) = 
	let(code = ascii_code(string), lastInd=len(code)-1)
    str_vector_join( [for (c = code)
			c >= _ASCII_UPPER_A && c <= _ASCII_UPPER_Z?
                chr(c+_ASCII_CONVERT)
            :
                chr(c)
    	] )
		;

// set all words to "Title Case"
// assumes that the given string contains space separated words
function title(string) =
	is_not_string( string ) ?
		undef
	: str_is_empty( string ) ?
		""
	: str_is_allspaces( string ) ?
		string
	:
		_title( string )
	;

function _title(string) =
    let( word_vec = new_split( lower(string) ) )

	is_undef( word_vec) ?
		undef
	: len(word_vec) <= 0 ?
		undef
	: len( word_vec ) == 1 ?
		first_cap( string )
    : str_vector_join(
		[ for(word = word_vec )
        	str( upper(word[0]), after(word, 0) )
    	]
		)
	;

function first_cap( word ) =
	len( word ) == 1 ?
		upper[0]
	:
		str( upper(word[0]), after(word, 0) )
	;

function reverse(string) = 
	is_not_string( string ) ?
		undef
	: len(string) <= 0?
		""
	: 
        str_vector_join([for (i = [0:len(string)-1]) string[len(string)-1-i]])
    ;

//return a segment of the given string from the "start" index 
// for "length" characters
// if start is not given take from the 0-th character
// if length is not given then take from start to the end
//
function str_sub_from_for(string, start=0, length=undef ) =
	is_not_string( string ) || start >= len(string) ?
		undef
	: length == undef ?
	  	starting_from( string, start ) // code for return to the end of string
	: length >= len(string) ?
		starting_from( string, start=start ) 
	: length <=0 ?		// code for return null string
		""
	:
		_str_sub_from_for( string, start, length )
	;

// check the start and length against the string
function _str_sub_from_for(string, start, length ) =
	let( endIndex = start + length-1, lastIndex = len(string)-1 )
	endIndex > lastIndex ?
		// str( "x ", start, " ", endIndex, " ", lastIndex, 
		str_from_to( string, start, lastIndex ) // )
	: 
		//str( "y ", start, " ", endIndex,  " ", lastIndex, 
		str_from_to( string, start, endIndex ) //)
	;



//note: start and end art inclusive
// so for "xyz" start=0 end=1 ==> "xy"
//          and start=2 end =2 ==> "z"
// NB end=0 can be legitimate, if start =0
function str_from_to(string, start, end) =
	is_not_string( string ) ?
		undef
	: is_not_num( start ) || is_not_num( end ) ?
		undef
	 : end < 0 || end < start || start < 0 || start > len(string)-1 ?
		undef
	: start == end ?
		//str( "equal", start, end , " ",
		string[start]  //) // can only be the one character
	: end >= len(string) ? // end is after end of string
		 //str( "endof", start, end , " ", 
		_sub_by_index( string, start, len(string)-1 )  //)
	: 
		//str( "param", start, end , " ", 
		_sub_by_index( string, start, end )// )
	;



//note: start is inclusive, end is exclusive
// so for "xyz" start=0 end=1 ==> "x"
//          and start=2 end =2 ==> "" 
function str_between_indecies(string, start, end) =
	is_not_string( string ) ?
		undef
	: is_not_num( start ) || is_not_num( end ) ?
		undef
	 : end < 0 || end < start || start > len(string)-1 ?
		undef
	: start == end ? // end is exclusive so null result
		"" 
	: start <= 0? // take this to mean start at 0th char
		before(string, end)
	: end >= len(string) ? // end is after end of string
		// str( "after", start, end , " ", )
		_sub_by_index( string, start, len(string)-1 )
	: end == len(string)-1 ? // end is on last index
			// take this to mean take up to, but NOT
			// including the last index 
		// str( "last", start, end )
		_sub_by_index( string, start, len(string)-2 )
	: 	//str( "final", start, end )
		// all the special cases are out of the way
		//  return the section of the string we need
		_sub_by_index( string, start, end-1 )
	;

// return the first part of string up to, but not
//  including the "upto" position
function before(string, upto=0) = 
	is_not_string( string ) || is_not_num( upto ) ?
		undef
	: upto > len(string)-1?
		string
	: upto < 1?
		""
	: _sub_by_index( string, 0, upto-1 ) ;


// returns the string AFTER start, so specifically not
//  including the start character
// THUS wheile the smallest index for a string is zero,
//  the smallest start position for this function is index=1
function after(string, start=0) =
	is_not_string( string ) || is_not_num( start ) ?
		undef
	: start < 0?
		undef 
	: start >= len(string)-1 ? // past the last index
		""
	: 
		_sub_by_index( string, start+1, len(string)-1 ) ;
	

// returns the string STARTING FROM start to end
//  this is an alternative to after() that can include the
//  zeroth char in string
function starting_from( string, start=0 ) =
	is_not_string( string ) || is_not_num( start ) ?
		undef
	: start < 0?
		undef 
	: start > len(string)-1? // past the last index
		"" 
	: 
		_sub_by_index( string, start, len(string)-1 ) ;
	

function _sub_by_index( string, start, end ) =
	str_vector_join( [for ( i=[start:end]) string[i]] );

function parse_int(string) = 
	let( numstr = trim(string) )
	numstr[0] == "-" ? 
		-1 * _parse_whole( after( numstr, 0 ) ) 
	: 
		_parse_whole( numstr );

function _parse_whole( string, base=10, pow=0, pos=undef ) =
	is_undef( pos ) ?
		_parse_whole( string, base=base, pos=len( string )-1 ) 
	: pos == 0 ?
		char_to_digit( string[0], base=base ) * base ^ pow
	:
		char_to_digit( string[pos], base=base ) * base ^ pow + 
			_parse_whole( string, base=base, pow=pow+1, pos=pos-1 ) 
	;

function char_to_digit( char, base=10 ) =
	base == 16 ?
		hexchar_to_digit( char )
	: base <= 10 ?
		( ord( char ) - _ASCII_0 )
	: undef
	;

function hexchar_to_digit( char ) =
	char >= "0" && char <= "9" ?
		ord(char) - ord("0")
	: char >= "A" && char <= "F" ?
		ord(char) - ord("A") + 10
	: undef
	;

function parse_hex( string ) =
	let( numstr = upper( trim(string) ) )
	numstr[0] == "-" ? 
		_parse_whole( after( numstr, 0 ), base=16 ) 
	: 
		_parse_whole( numstr, base=16 );
	;

function parse_float(string) = 
	let( numstr = trim(string) )
	numstr[0] == "-" ? 
		-1 * parse_float(after(numstr,0))
	:
		_split_float( string, _index_of( string, "." ) )
	;


function _split_float( string, delims ) = 
    is_undef(delims) || is_not_list(delims) ?
        undef
    : delims == [] ?
    	_parse_whole( string )
    : let( numdelims = len(delims) )
      numdelims != 1 ?
        undef
    : let( delim = delims[0] )
      delim.x == 0 ?
        // echo( "x", string, delim.y)
		float_fraction( string, delim.y )
    :
        //str( "y ", string, " ", delim.x, " ", before( string, delim.x ))
		_parse_whole( before( string, delim.x ) ) + float_fraction( string, delim.y  )
    ;


function float_fraction( string, start, pow=-1 ) =
    let( laststr = len(string)-1 )
    start > laststr ? 
        0
    : start == laststr ?
        char_to_digit( string[laststr]  ) * 10 ^ pow
    : char_to_digit( string[start] ) * 10 ^ pow +
        float_fraction( string, start+1, pow=pow-1 );
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
function strIndexVector( string, delim=" " ) =
	is_not_string( string ) || is_not_string( delim ) ?
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
function _index_of( string, delim=" ", pos=0  ) =
	pos >= len(string)?
		undef // cant do anything
	:
	  let( iof= _index_of_first( string, delim, pos=pos ) )
	  is_undef( iof ) ?
		[] // there are no instances of the delim in the string
    :
		_index_of_recurse( string, delim, iof, pos )
	;

// return a vector of the parts of a string separated by the delimiter string.
//  it uses the delimiter vector returned by _index_of_first(), which comes to this
//  function in the index_of_first parameter.
//  if i_o_f is undefined it means there is no instance of the delimiter after the
//  given position.
function _index_of_recurse(string, delim=" ", index_of_first, pos ) = 
    is_undef( index_of_first ) || index_of_first == [] ?
        undef // called with no starting point so stop
    : concat(
        [index_of_first], // i_o_f is [x,y] - [start of delimiter, rest of string]
        _coalesce_on(
				// recurse into the rest of the string, thus after i_o_f.y
            _index_of( string, delim, pos = index_of_first.y ),
				// if that returns undef then ...
            undef,
            [] 	//  return null vector
			)
   	 	);

// return a vector of first instance of the delimiter string
//  starting at the given position
// The delimiter instance is returned as [delim[0],follow[0]] meaning
//  that the first element is the first character of the instance,
//  and the second is the first character of the given string _following_
//  this delimiter instance.
// so i_o_f( "abcxxdef", "xx" ) ==> [3,4]
function _index_of_first(string, delim=" ", pos=0 ) =
	pos >= len( string ) ?
		undef // we are off the end of the string
	: _coalesce_on(
			// try to match the delimiter at current pos.
			//  _match returns the index of the NEXT char in string
			//  that does NOT match any of the characters in the set.
			// SO .. we return the [pos,_match] vector
		[pos, _match( string, delim, pos )], 
			// ELSE
			//  the delim was NOT found, and _match() returned
			//  undef as a signal in the .y position
		[pos, undef],
			// and .. given the failure to match the
			//  we recurse deeper to see if there is another
			//  delimiter instance
			//  i_o_f will return a valid [del0,str0] vector
			//  OR will return undef
		_index_of_first(string, delim, pos+1 )
		)
    ;

/*
	return a vector of the words in the given string
	the default is to separate on space characters, but any
	string can be used to separate blocks of text in the input.

	consider: this will return undef  
	str_split( "some text", "z" ) ==> ["some text"]
	as there is no instance of "z" in the string
	and likewise
	str_split( "oneword" ) should return ["oneword"]
 */
function str_split( string, separator=" " ) =
	is_not_string( string ) ?
		undef
	: str_is_empty(string) ?
		[""]
	: _str_split( string, _index_of( string, separator ) );

// INPUTS
//  the given string that we will extract words from
//  the list of delimeter instances
//  the index into the delimiter list that we are to consider
// called from str_split() the pos param will default to 0 NB!
function _str_split(string, indices, i=0) = 
    is_not_list( indices ) || len(indices) == 0?
        undef
    : i >= len(indices)? // we working on the last delimiter instance
		let( lastIndex = len(indices)-1)
			// IF after() returns the null string return the null list
        _coalesce_on(
				after(string, indices[lastIndex].y-1), "",
				[]
				)
    : i == 0? // we are working on i=0, the first delimiter instance
			// If there is a word before the first delimiter instance
			//  concat it and recurse for the rest of the vector.
        concat(
			 _coalesce_on(
					// IF before returns the nullstring there is no word
					//  before the first delim instance .. return [] to
					//  the recursion level above
					before(string, indices[0].x), "", []
					),
			 _str_split(string, indices, i+1) 
			 )
    :
			// otherwise we are processing a delimiter instance between the first and last.
			//  we extract the word from the string starting with the .y index of the PREVIOUS
			//  instance up to the beginning of the current delimiter instance, .x
			// AND THEN recurse further
        concat( str_between_indecies(string, indices[i-1].y, indices[i].x), _str_split(string, indices, i+1) )
    ;




/*
	return a vector of the words in the given string
	the default is to separate on space characters, but any
	string can be used to separate blocks of text in the input.

	consider: this will return undef  
	new_split( "some text", "z" ) ==> ["some text"]
	as there is no instance of "z" in the string
	and likewise
	new_split( "oneword" ) should return ["oneword"] 
 */
function new_split( string, separator=" " ) =
	is_not_string( string ) ?
		undef
	: str_is_empty(string) || str_is_empty(separator) ?
		[]
	: _new_split( string, _index_of( string, separator ) );


function stringBlanks( qty, i=1 ) =
    qty == 0 ? ""
    : i==qty ? " "
    : str( " ", stringBlanks( qty, i+1 ) ) ;


function str_vector_join( arrayOfStrings, delimeter="" ) = 
	is_not_list( arrayOfStrings ) ?
		undef
	: arrayOfStrings == [] ?
		""
	: _str_vector_join(arrayOfStrings, len(arrayOfStrings)-1, delimeter=delimeter );

function _str_vector_join( arrayOfStrings, index, delimeter="") = 
	index==0 ? 
		str( arrayOfStrings[0] ) // finish recursion at start of string
	: str( _str_vector_join( arrayOfStrings, index-1, delimeter ), 
			delimeter,
			arrayOfStrings[index]
			) ;


