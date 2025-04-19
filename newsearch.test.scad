_search_version = 
	[2025, 03, 29, 1];
function search_version() =
	_search_version;
function search_version_num() =
	_search_version.x * 10000 + 
	_search_version.y * 100 +
	_search_version.z +
	_search_version[3] / 10 ;

include <vectors.scad>
include <logic.scad>
include <newsplit.scad>
include <numbers.scad>
include <recursion.scad>

_SEARCH_ENABLED_ = true;

regex_test = "foooobazfoobarbaz";

ts = "this is a test"; // test string
tsEnd = len(ts)-1;
tsQty = len(ts);

pts = str( " " , ts , " " ); // padded string
mts = "This IS a tESt"; // test string with capitals

nullString = "";

numbers = "some 123 numb 15.25 ers, a-23nd pun5556; tations99";

foobar = "!@#$1234foobar@#$1234";
FOOBAR = "!@#$1234 FOOBAR !@#$1234";


_ASCII_NULL		= 0;
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

_DIGITS_STRING = "0123456789";
_LOWER_STRING  = "abcdefghijklmnopqrstuvwxyz";
_UPPER_STRING  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
_NUMERIC_STRING= str( "+,-.", _DIGITS_STRING, "e" );
_NUMPUNC_STRING= str( "+,-.e" );
_MATH_STRING   = "!%&()*+,-/<=>^"; // math & boolean operators
_PUNC_STRING   = "!\"&'(),-./:;<>?@[\\]`{|}~";

_CHAR_OPENPAREN = "(";
_CHAR_CLOSPAren = ")";
_CHAR_OPENBRACE = "{";
_CHAR_CLOSBRACE = "}";
_CHAR_OPENBRACK = "[";
_CHAR_CLOSBRACK = "]";
_CHAR_OPENANGLE = "<";
_CHAR_CLOSANGLE = ">";
_CHAR_UNDER     = "_";

_VARNAME_STRING= str(_DIGITS_STRING,_UPPER_STRING,_CHAR_UNDER,_LOWER_STRING);

// the double quote (") and backslash (\) are escaped by a backslash
_ASCII_VISIBLE = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
_ASCII_TEXT    = str( _CHAR_SPC, "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~" );
_ASCII_LEGAL   = str( _WHITESPACE, _ASCII_VISIBLE );

_ASCII_DIGITS  = str_to_ascii(_DIGITS_STRING);
//echo(_ASCII_DIGITS);

 // no checking version of char_in_set
function _is_in_set( char, set, ignore_case=false ) =
   let(
		ch = ignore_case ? lower(char) : char,
		st = ignore_case ? lower(set)  : set
		) 
	search( ch, st ) != []
	;


echo( inset = _is_in_set( "a", "abcdef" ) );
echo( inset = _is_in_set( "z", "abcdef" ) );
echo( inset = _is_in_set( ":", "abcdef" ) );
echo( inset = _is_in_set( ":", _ASCII_LEGAL ) );

// returns true if the given char is a legal ASCII character
//  that is used in normal text. So TAB, NL etc are not allowed
function is_ascii( char ) = 
    _is_in_set( char, _ASCII_LEGAL );

if( _SEARCH_ENABLED_ ) {
echo( ia= is_ascii( "0" ) );
echo( ia= is_ascii( "a" ) ); 
echo( ia= is_ascii( "\t" ) );
}
function _is_variable_safe(char) = 
	is_not_string( char ) ?
		undef
	: _is_in_set( char, _VARNAME_STRING );

if( _SEARCH_ENABLED_ ) {
echo( var = _is_variable_safe( "a" ) );
echo( var = _is_variable_safe( ":" ) );
echo( var = _is_variable_safe( 42 ) );
}
// return a vector with the ASCII code values for each character in the string
function str_to_ascii( string ) = 
	is_not_string(string) ?
		[]
    : [for( c=string ) _is_in_set( c, _ASCII_LEGAL) ? ord(c) : _ASCII_NULL ]
	;
if( _SEARCH_ENABLED_ ) {
echo( sa= str_to_ascii( "abcd" ) );
echo( sa= str_to_ascii( _DIGITS_STRING ) );
}
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
//  including the character at "start"
// The smallest start position for this function is 1
function after(string, afterThis=0) =
	is_not_string( string ) || is_not_num( afterThis ) ?
		undef
	: afterThis < 0?
		undef 
	: afterThis >= len(string)-1 ? // past the last index
		""
	: let( start=afterThis+1, lastInd=len(string)-1)
		_sub_by_index( string, start, lastInd ) ;
	

function _sub_by_index( string, start, end ) =
	str_join( [for ( i=[start:end]) string[i]] );


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
		str_equals(
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
	: str_equals(
		after(string, len(string)-len(refString)-1), 
		refString,
		ignore_case=ignore_case
		)
	;


// return true if the given string is empty
//  but it must exist or we return undef
function str_is_empty(string) = 
	is_not_string( string ) ? undef : string == "" ;


// return true when given string is undefined, OR
//  is empty, meaning the null string ( "" )
//  or undef if the input is not a string
function str_is_undef_or_empty(string) = 
	is_not_string( string ) ?
		undef
	: is_undef(string) || string == "" ;


// return true when given a null string ( "" ) or
//  a string that has only space characters ( " " )
// other types of whitespace are counted as non-space
//  characters
function str_is_null_or_allspaces(string) = 
	len( search( " ", string, 0 )[0] ) == len( string );


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
	: string == "" ? // handle special case
		false
	: 0 == len( [for (char=string) if(char != _CHAR_SPC ) char] )
	;



function check_allspaces(string) =
    str_is_undef_or_empty(string) ? false :
		len( search( " ", string, 0 )[0] ) == len( string )
    ;


if(_SEARCH_ENABLED_) {
bl4="    ";
echo( all=search( " ", bl4, 0 )[0] );
echo( all=len( search( " ", bl4, 0 )[0] ) );
echo( all=len(bl4) == len( search( " ", bl4, 0 )[0] ) );
echo( all=str_is_allspaces( bl4 ) );
echo( all=str_is_allspaces( "" ) );
echo( all=str_is_allspaces( ts ) );

echo( cl=search( " ", "", 0 )[0] );
echo( cl=len( search( " ", bl4, 0 )[0] ) == len(bl4) );
echo( cl=check_allspaces( bl4 ) );
echo( cl=check_allspaces( "" ) );
echo( cl=check_allspaces( ts ) );
echo( cl=check_allspaces(" sss ") );
echo( cl=check_allspaces("abcd") );
}



ts_split = str_split( ts );
echo( st= ts_split );
echo( st=search( ["this"], ts_split ) );

echo( st=[ts] );
echo( st=search( "this", ts ) );

t2=[ ["cat",1],["b",2],["c",3],["dog",4],["a",5],["b",6],["c",7],["d",8],["e",9],["apple",10],["a",11] ];
s2=["b","zzz","a","c","apple","dog"];
r2=search( s2, t2 );
echo( r2=r2 );
t3=[ ["cat"],["b"],["c"],["dog"],["a"],["b"],["c"],["d"],["e"],["apple"],["a"] ];
s3=["b","zzz","a","c","apple","dog"];
r3=search( s3, t3 );
echo( r3=r3 );
}


// compare the given pattern against the given string at pos
// If it matches return the position in string AFTER the pattern.
// starts_with() does all the checking for correct inputs
//  and will return "false" if pattern=="" or the pattern
//  does not match .. but functions using _match_pat() use
//  the on_coalesce() recursion function so all cases of
//  failure to match are coerced to undef
function _match_pat(string, pattern, pos, ignore_case=false ) = 
    let( result = starts_with(string, pattern, pos, ignore_case=ignore_case) )
	is_undef( result ) || ! result ?
		undef
    : pos+len(pattern) ;


function _scan_for_pat(string, pattern, pos, ignore_case=false ) = 
    let( result = starts_with(string, pattern, pos, ignore_case=ignore_case) )
	is_undef( result ) ?
		undef
    : result ?
        pos+len(pattern)
    : _scan_for_pat(string, pattern, pos+1 )
    ;

if( _SEARCH_ENABLED_ ) {
echo( _scan_for_pat( ts, "is", 0 ) );
echo( search( ["is"], ts, 0 ) );
}

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


if( _SEARCH_ENABLED_ ) {
echo( "testing _match_set" );
// Return the index of the NEXT char in string that does NOT
// 	 match any of the characters in the set.
assert( _match_set( "aaabbbccc", "a", 0 )   == 3 ); // 3
assert( _match_set( "aaabbbccc", "b", 0 )   == 0 ); // 0, input pos when not found
assert( _match_set( "ababbbccc", "ab", 0 )  == 6 ); // 7 
assert( _match_set( "abbbbbccc", "ab", 0 )  == 6 ); // 6
assert( _match_set( "aaabbbccc", "abc", 0 ) == 9 ); // 9
assert( _match_set( "bbbcccaaa", "a", 0 )   == 0 ); // 0, input pos when not found
assert( _match_set( "aaabbbcccaaa", "a", 0 )== 3 ); // 3
assert( _match_set( "aaabbbcccaaa", "ac", 0 )== 3); // 3
assert( _match_set( "bbbcccaaa", "abc", 0 ) == 9 ); // 9
assert( _match_set( "aaabbbcccaaa", "abc", 0 )== 12 );// 12

pos0=0; // using these to highlight they are positional 
pos1=1; 
pos4=4; // indexes and not lengths
pos5=5;
pos6=6;
pos7=7;
pos8=8;
pos9=9;
pos12=12;
pos20=20;

assert( _match_set( "bbbcccaaa",      "a",  pos4 ) == pos4 );//  4, input pos !
assert( _match_set( "bbbcccaaa",      "a",  pos5 ) == pos5 );//  5
assert( _match_set( "bbbcccaaa",      "a",  pos6 ) == pos9 );//  9, correct
assert( _match_set( "aaabbbcccaaa",   "a",  pos7 ) == pos7 );//  7, input pos
assert( _match_set( "aaabbbcccaaa",   "a",  pos20 ) == pos12 );
assert( _match_set( "aaabbbcccaaa",  "ac",  pos6 ) == pos12 );//12 correct
assert( _match_set( "aaabbbcccaaa", "abc",  pos6 ) == pos12 );// 12 correct
}

// input : list of numbers
// output : sorted list of numbers
function quicksort(arr) =
    is_not_list(arr) || len(arr) <= 0 ?
        [] 
    : let(
        pivot   = arr[floor(len(arr)/2)],
        lesser  = [ for (y = arr) if (y  < pivot) y ],
        equal   = [ for (y = arr) if (y == pivot) y ],
        greater = [ for (y = arr) if (y  > pivot) y ]
        ) 
      concat( quicksort(lesser), equal, quicksort(greater) )
    ;

if( _SEARCH_ENABLED_ ) {
ss = search( _DIGITS_STRING, numbers, 0  );
echo( ss=ss );
sz = [for( s=ss ) each if( s!=[]) s];
echo( sz=sz );
qs = quicksort( sz );
echo( qs = qs  );
echo( is9= str( numbers[qs[0]],numbers[qs[0]+1] ));
echo( search( _DIGITS_STRING, numbers[qs[0]] )  );

echo( numbers );
next = next_digit( numbers, qs[0]);
echo( next = next );
}

function next_digit( string, pos) =
    pos >= len(string) ?
        len(string)
    : _is_in_set( string[pos+1], _DIGITS_STRING ) ?
        next_digit( string, pos+1 )
    : pos+1
    ;

// return index of the character in the given string that is
//  any character of the given set, starting from the end
//  of the string
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
//  set must be a string
function _char_in_set( char, set, ignore_case=false ) =
	is_not_string(  char ) || is_not_string(  set ) ?
		false // TODO maybe undef ?
	: str_is_undef_or_empty( set ) ?
		false // TODO maybe undef ?
	: len( char ) != 1 ?
		false // TODO maybe undef ?
	: 
		_is_in_set( char, set )
	;


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

if( _SEARCH_ENABLED_ ) {
echo( str_equals( "this", "that" ) );
echo( str_equals( "this", "this" ) );
echo( str_equals( "this", "THIS" ) );
}

function _upper(string) = 
    str_join(
        [for(c=string) ! _is_in_set(c,_LOWER_STRING) ? c :
            chr(ord(c) - _ASCII_CONVERT)
        ]);

if( _SEARCH_ENABLED_ ) {
echo( upp=str( _upper( ts ) ) );
echo( upp=str( _upper( mts ) ) );
}

function _lower(string) = 
    str_join(
        [for(c=string) ! _is_in_set(c,_UPPER_STRING) ? c :
            chr(ord(c) + _ASCII_CONVERT)
        ]);

if( _SEARCH_ENABLED_ ) {
echo( low=str( _lower( ts ) ) );
echo( low=str( _lower( mts ) ) );
} 


function ascii_lower( code ) = 
	let(lastInd=len(code)-1)
    str_vector_join( [for (c = code)
			c >= _ASCII_UPPER_A && c <= _ASCII_UPPER_Z?
                chr(c+_ASCII_CONVERT)
            :
                chr(c)
    	] )
		;


// set all elements of the given vector of words
//  to Title Case
function to_title_vec(word_vec) =
	is_not_list( word_vec) || len(word_vec) <= 0 ?
		undef
    : str_vector_join(
		[ for(word = word_vec ) first_cap( word ) ] )
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
			//  _match_pat returns the index of the NEXT char in string
			//  that does NOT match any of the characters in the set.
			// SO .. we return the [pos,_match_pat] vector
		[pos, _match_pat( string, delim, pos )], 
			// ELSE
			//  the delim was NOT found, and _match_pat() returned
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



// find the maximum value in a vector
function max_vec(v, m=-999999999999, i=0) = 
    (i == len(v) ) ?
		m 
    : (m > v[i]) ?
	    max_vec(v, m, i+1) 
    :
		max_vec(v, v[i], i+1)
	;

v=[7,3,9,3,5,6];
echo( max = max_vec(v));   // ECHO: "max", 9


// find the minimum value in a vector
function min_vec(v, m=999999999999, i=0) = 
    (i == len(v) ) ?
		m 
    : (m < v[i]) ?
	    min_vec(v, m, i+1) 
    :
		min_vec(v, v[i], i+1)
	;

echo( min = min_vec(v));   // ECHO: "min", 3

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

codes=[for(c=ts) ord(c)];
echo( codes = codes);
echo( chr = chr(codes) ); // chr will convert and concat a vector
	// of single character strings into a string

tswords = new_split( ts );
echo( tsw = tswords ); // delimiters included

sswords = str_split( ts );
echo( ssw = sswords ); // delimiters removed

chars = [ for(w=tswords) for( c=w ) ord(c)];
echo( chars = chars );
echo( chars = chr( chars ) );

function str_join( strvec, delim="" ) =
	let( str=chr( [ for(w=strvec) [ [for( c=w ) ord(c) ], ord(delim) ] ] ) )
	delim == "" ? str : before( str, len(str)-1)
	;

echo( tsj = str_join( tswords ) );
echo( ssj = str_join( sswords ) );

echo( ts=str_join( ts )); // thisjs actually works on a string!

// now with delimiters added
tt = [ for(w=sswords) [ [ for(c=w) ord(c)],_ASCII_SPACE] ];
echo( tt= tt );
echo( tt= chr( tt ) );

xx = [ for(w=sswords) each [ [ for(c=w) ord(c)],_ASCII_SPACE] ];
echo( xx=xx );
echo( xx= chr( xx ) );

yy = [ each for(w=sswords) [ each [ for(c=w) ord(c)],_ASCII_SPACE] ];
echo( yy=yy);
echo( yy= chr( yy ) );

echo( yy= str_join( sswords, " " ) );
echo( yy= str_join( tswords, " " ) );
echo( yy= str_join( tswords, "" ) );
echo( yy= str_join( tswords  ) );
