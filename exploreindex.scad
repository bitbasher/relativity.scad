include <logic.scad>
include <numbers.scad>
include <vectors.scad>
include <recursion.scad>


_INDEXTEST_ENABLED_ = false;

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

footest = "foo  (1, bar2)";
regex_test = "foooobazfoobarbaz";

ts = "this is a test"; // test string
//echo( "ascii code test string ", ascii_code( ts ) );

pts = str( " " , ts , " " );
mts = "This IS a tESt"; // test string with capitals

nullString = "";

tsEnd = len(ts)-1;
tsQty = len(ts);

digits = "0123456789";
//code_digits = ascii_code(digits);
numbers = "some 123 numb 15.5 ers, a-23nd pun5556; tations99";

foobar = "!@#$1234foobar@#$1234";
FOOBAR = "!@#$1234 FOOBAR !@#$1234";

tsBlanks = [[4, 5, " "], [7, 8, " "], [9, 10, " "]];
manyBlanksString = "  test  with blanks  ";
manyBlanks = [[0, 1, " "], [1, 2, " "], [6, 7, " "], [7, 8 , " "],
     [12, 13, " "], [19, 20, " "], [20, 21, " "]];
dubleBlanks = [[0, 2, "  "], [6, 8, "  "], [19, 21, "  "]];
threeTees = [[0, 1, "t"], [10, 11, "t"], [13, 14, "t"]];
notFound = [];


function _match_pat(string, pattern, pos, ignore_case=false ) = 
    let( result = starts_with(string, pattern, pos, ignore_case=ignore_case) )
	is_undef( result ) || ! result ?
		undef
    : pos+len(pattern) ;

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
 
 function _str_equals(this, that, ignore_case=false) = 
	ignore_case ?
		_lower(this) == _lower(that) : this==that ;

echo( starts_with("oneword",    " ",0) );   // false
echo( starts_with(" start", " ",0) );       // true
echo( starts_with("end ",   " ",0) );       // false
echo( starts_with("two words"," ",0) );     // false

echo( _match_pat("one"," ",0) );
echo( _match_pat("start "," ",0) );
echo( _match_pat("end "," ",0) );
echo( _match_pat("two words"," ",0) );




function is_not_string( string ) =
	is_undef( string ) || ! is_string( string );


// return true if the given string is empty
//  but it must exist or we return undef
function str_is_empty(string) = 
	is_not_string( string ) ? undef : string == "" ;

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

function _sub_by_index( string, start, end ) =
	str_vector_join( [for ( i=[start:end]) string[i]] );

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




null  = "";

one   = "oneword";
two   = "two words";
start = " start";
end   = "end ";
both  = " both ";
all   = " all all ";
test  = "this is a test";
abcd  = " a b c d ";
multi = "  mul  ti  ";
mul3  = "mul   ti   ple   ";


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
	: let( lastind=len(string)-1,
		ion = _index_of_next( string, delim, 0 )
		)
	  is_undef( ion ) ?
        [0,lastind,str_from_to( string, 0, lastind)]
	:
		_index_vector( string, delim, 0, ion )
	;


echo( "testing _index_of_next( string, delim=, 0 )" );
echo( iof = _index_of_next( one,  " ", 0 ) );
echo( iof = _index_of_next( two,  " ", 0 ) );
echo( iof = _index_of_next( start," ", 0 ) );
echo( iof = _index_of_next( end,  " ", 0 ) );
echo( iof = _index_of_next( both, " ", 0 ) );
echo( iof = _index_of_next( abcd, " ", 0 ) );
echo( iof = _index_of_next( all,  " ", 0 ) );
echo( iof = _index_of_next( test, " ", 0 ) );
echo( iof = _index_of_next( multi," ", 0 ) );
echo( iof = _index_of_next( multi,"  ", 0 ) );
echo( iof = _index_of_next( mul3, " ", 0 ) );
echo( iof = _index_of_next( mul3, "   ", 0 ) );

echo( "testing strIndexVector( string, delim= )" );
echo( vec = strIndexVector( one, " " ) );
echo( vec = strIndexVector( start, " " ) );
echo( vec = strIndexVector( end, " " ) );
echo( vec = strIndexVector( two, " " ) );
echo( vec = strIndexVector( both, " " ) );
echo( vec = strIndexVector( abcd, " " ) );
echo( vec = strIndexVector( all, " " ) );
echo( vec = strIndexVector( test, " " ) );
echo( vec = strIndexVector( multi, " " ) );
echo( vec = strIndexVector( multi, "  " ) );
echo( vec = strIndexVector( mul3, " " ) );
echo( vec = strIndexVector( mul3, "   " ) );

function _index_vector( string, delim, pos, ion ) =
	let( lastind = len(string)-1 )
	is_undef( ion ) ?
		_coalesce_true( pos <= lastind,
			[[ pos, lastind, str_from_to( string, pos, lastind) ]],
			[]
			)

    : ion.x == pos ?
        concat(
        	[ion],
       		_index_vector( string, delim=delim, ion.y,
            	_index_of_next( string, delim=delim, pos=ion.y )
				)
			)

    : concat( [[pos, ion.x-1, str_from_to( string, pos, ion.x-1) ]],
		_index_vector( string, delim=delim, ion.x, ion )
		)
    ;

echo(  _index_of_next(abcd, delim=" ", pos=0 )  );
echo(  _index_of_next(abcd, delim=" ", pos=3 )  );
echo(  _index_of_next(abcd, delim=" ", pos=5 )  );

// step along string 1 char at a time looking for a match
//  to delim, which can be multi-character
function _index_of_next(string, delim=" ", pos=0 ) =
	pos >= len( string ) ?
		undef // we are off the end of the string
	: _coalesce_on(
		[pos, _match_pat( string, delim, pos ), delim], 
		[pos, undef, delim],
		_index_of_next(string, delim, pos+1 )
		)
    ;
