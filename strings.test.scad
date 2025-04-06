include <strings.scad>

_TEST_ENABLED_ = false;

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
code_digits = ascii_code(digits);
numbers = "some 123 numb 15.5 ers, a-23nd pun5556; tations99";

foobar = "!@#$1234foobar@#$1234";
FOOBAR = "!@#$1234 FOOBAR !@#$1234";

echo( "testing ascii_code" );
illegalCodes = "\u20AC 10 \u263A"; // UNICODE for 10 euro and a smilie;

/*
echo( legal = ts );
echo( legal = ascii_code(ts) );
echo( padded = pts );
echo( padded = ascii_code(pts) );
echo( mixed = mts );
echo( mixed = ascii_code(mts) );
echo( illegal = illegalCodes );
echo( illegal = ascii_code(illegalCodes) );
 */ 
tsv =  [116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116];
ptsv = [32, 116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32];
mtsv = [84, 104, 105, 115, 32, 73, 83, 32, 97, 32, 116, 69, 83, 116];

// legalCodes
assert( ascii_code( ts  )   == tsv );
assert( ascii_code( pts )   == ptsv );
assert( ascii_code( mts )   == mtsv );
assert( ascii_code( illegalCodes ) == [undef, 32, 49, 48, 32, undef] );
notString = 42;
assert( is_undef( ascii_code( notString ) ) );

//echo( ascii_code( _ASCII_VISIBLE ) );
//echo( ascii_code( _ASCII_ALL ) );

// make a reference string based on _WHITESPACE and _ASCII

codevect = [for(c=_ASCII) ord(c)];
//echo( "code vect", codevect, _CHAR_NL );
//echo( "code asci", ascii_code( _ASCII ), _CHAR_NL );

assert( ascii_code( _ASCII ) == codevect );

echo( MAX_VALUE );

echo( "testing boolean test functions" );
echo( "\ttesting _is_variable_safe" );

foobar_vector = [
        ["!", false], ["@", false], ["#", false], ["$", false], ["1", true], 
        ["2", true],  ["3", true],  ["4", true],  ["f", true],  ["o", true], 
        ["o", true],  ["b", true],  ["a", true],  ["r", true],  ["@", false], 
        ["#", false], ["$", false], ["1", true],  ["2", true],  ["3", true], 
        ["4", true]
        ];
// echo( [for(c=foobar) [c,_is_variable_safe( ord(c) ) ]] );
safe_vector = [for(c=foobar) [c,_is_variable_safe( ord(c) ) ]];
// echo( safe_vector );
assert( safe_vector == foobar_vector );
// echo( _is_variable_safe( ord("_") ) );
assert( _is_variable_safe( ord("_") ) );
assert( is_undef( _is_variable_safe( " " ) ) );

echo( "\tis_not_string" );
assert( ! is_not_string( "xyz" ) );
assert( ! is_not_string( "" ) );
assert( ! is_not_string( "   " ) );
assert( is_not_string( [] ) );
assert( is_not_string( 42 ) );
assert( is_not_string( undefStr ) );



echo( "\tstr_is_empty" );
assert( ! str_is_empty( "  " ) );
assert(   str_is_empty( "" ) );
assert( ! str_is_empty( "xyz" ) );
assert( is_undef( str_is_empty( [] ) ) );


echo( "\tstr_is_undef_or_empty" );

assert( ! str_is_undef_or_empty( "  " ) );
assert(   str_is_undef_or_empty( "" ) );
assert( is_undef( str_is_undef_or_empty( undefStr ) ) );
assert( ! str_is_undef_or_empty( "xyz" ) );
assert( is_undef( str_is_undef_or_empty( [] )  ) );
assert( is_undef( str_is_undef_or_empty( 42 ) ) ); 

echo( "\tstr_is_null_or_allspaces" );
assert(   str_is_null_or_allspaces( "  " ) );
assert( ! str_is_null_or_allspaces( " xyz " ) );
assert(   str_is_null_or_allspaces( "" ) );
assert( ! str_is_null_or_allspaces( "xyz" ) );
assert( ! str_is_null_or_allspaces( [] ) ); // non strings as input give "false"

echo( "\tstr_is_allspaces" );
assert( ! str_is_allspaces( "" ) );
assert( str_is_allspaces( "  " ) );
assert( ! str_is_allspaces( "abcd" ) );
assert( ! str_is_allspaces( " a b c d " ) );
assert( is_undef( str_is_allspaces( [] ) ) );
assert( is_undef( str_is_allspaces( ["  "] ) ) );


echo( "testing _str_vector_join( arrayOfStrings, index, delimeter)" );
// this is the internal function that does NOT check all input
assert( _str_vector_join( ["a","b","c"], 0 ) == "a" );
assert( _str_vector_join( ["a","b","c"], 0, "-" ) == "a" );
assert( _str_vector_join( [3,4,5], 0 ) == "3" );
assert( _str_vector_join( [34,45,56], 0 ) == "34" );
assert( _str_vector_join( [34,45,56], 0,"-" ) == "34" );
assert( _str_vector_join( [34,45,56], 1 ) == "3445" );
assert( _str_vector_join( [34,45,56], 1,"-" ) == "34-45" );

assert( _str_vector_join( ["a","b","c"], 2 ) == "abc" );
assert( _str_vector_join( ["a","b","c"], 2, "-" ) == "a-b-c" );
assert( _str_vector_join( [3,4,5], 2 ) == "345" );
assert( _str_vector_join( [34,45,56], 2 ) == "344556" );
assert( _str_vector_join( [34,45,56], 2,"-" ) == "34-45-56" );


echo( "testing str_vector_join()" );
// this is the external function that DOES check all input
assert( str_vector_join( ["a","b","c"] ) == "abc" );
assert( str_vector_join( [] )  == "" );
assert( str_vector_join( [3,4,5] )  == "345" );
assert( str_vector_join( [34,45,56] ) == "344556" );
assert( str_vector_join( ["a","b","c"], "-" ) == "a-b-c" );
assert( str_vector_join( [], "-" ) == "" );
assert( str_vector_join( [3,4,5], "-" ) == "3-4-5" );
assert( str_vector_join( [34,45,56], "-" ) == "34-45-56" );

echo( "testing _sub_by_index()" );
assert( _sub_by_index( "abc", 0, 2 ) == "abc" );
assert( _sub_by_index( "abc", 1, 2 ) == "bc" );
assert( _sub_by_index( "abc", 2, 2 ) == "c" );

assert( _sub_by_index( "abc", 0, 0 ) == "a" );
assert( _sub_by_index( "abc", 1, 1 ) == "b" );
assert( _sub_by_index( "abc", 2, 2 ) == "c" );
assert( _sub_by_index( "abc", 1, 2 ) == "bc" );

echo( "testing char_to_digit( char, base=10 ) " );
assert( char_to_digit( "0" ) == 0 );
assert( char_to_digit( "1" ) == 1 );
assert( char_to_digit( "9" ) == 9 );

assert( char_to_digit( "0", base=16 ) == 0 );
assert( char_to_digit( "1", base=16 ) == 1 );
assert( char_to_digit( "9", base=16 ) == 9 );
assert( char_to_digit( "A", base=16 ) == 10);
assert( char_to_digit( "E", base=16 ) == 14);
assert( char_to_digit( "F", base=16 ) == 15);
assert( is_undef( char_to_digit( "Z", base=16 ) ) );


echo( "testing _parse_whole( string )" );
assert( _parse_whole( "0", base=10 ) == 0 );
assert( _parse_whole( "1" ) == 1 );
assert( _parse_whole( "9", base=10 ) == 9 );
assert( _parse_whole( "12" ) == 12 );
assert( _parse_whole( "120000" ) == 120000 );

assert( _parse_whole( "0", base=16 ) == 0 );
assert( _parse_whole( "1", base=16 ) == 1 );
assert( _parse_whole( "9", base=16 ) == 9 );
assert( _parse_whole( "A", base=16 ) == 10 );
assert( _parse_whole( "E", base=16 ) == 14 );
assert( _parse_whole( "F", base=16 ) == 15 );

echo( "testing parse_int( string )" );
assert( parse_int( "12" ) == 12 );
assert( parse_int( "-12" ) == -12 );
assert( parse_int( "120000" ) == 120000 );
assert( parse_int( "   120000   " ) == 120000 );


echo( "testing parse_hex( string )" );
assert( parse_hex( "-0" ) == 0 ); 
assert( parse_hex( "000" ) == 0 ); 
assert( parse_hex( "01" ) == 1 );
assert( parse_hex( "010" ) == 16 );
assert( parse_hex( "0100" ) == 256 );
assert( parse_hex( "1000" ) == 4096 );
assert( parse_hex( "00a" ) == 10 );
assert( parse_hex( "0b0" ) == 16*11 );
assert( parse_hex( "c00" ) == 256*12 );
assert( parse_hex( "f000" ) == 4096*15 );

assert( parse_hex( "12" ) == 18 );
assert( parse_hex( "-12" ) == 18 );
assert( parse_hex( "A" ) == 10 ); 
assert( parse_hex( "F" ) == 15); 
assert( parse_hex( "F2" ) == 16*15+2 ); 
assert( parse_hex( "   034ef   " ) == 4096*3 + 256*4 + 16*14 + 15 );


echo( "testing before()" );
assert( before(ts, -1) == nullString );
assert( before(ts, 0) == nullString );
assert( before(ts) == nullString );

assert( before( "short", 0) == "" );
assert( before( "short", 1) == "s" );
assert( before( "short", 2) == "sh" );
assert( before( "short", 3) == "sho" );
assert( before( "short", 4) == "shor" );
assert( before( "short", 5) == "short" );
assert( before( "short", 6) == "short" );
assert( before(ts, tsEnd) == "this is a tes" );
assert( before(ts, tsQty) == ts );
assert( before( "", 3 ) == "" );
assert( before( "   ", 1 ) == " " );
assert( before( "xyz", 20 ) == "xyz" );
assert( before(ts, -3) == nullString );
assert( is_undef( before( ts, undef ) ) );
assert( is_undef( before( 42, 0 ) ) );


echo( "testing starting_from( string, start=0 )" );
assert(	is_undef( starting_from(ts, -1) ) );
assert(  starting_from( "abc", 0 ) == "abc" );
assert(  starting_from( "abc", 1 ) == "bc" );
assert(  starting_from( "abc", 2 ) == "c" );
assert(  starting_from( "abc", 3 ) == "" );
assert(  starting_from( "abc", 4 ) == "" );


echo(	"testing after()" );
assert(	is_undef( after(ts, -1) ) );
assert( after( "abc", 0 ) == "bc" );
assert( after( "abc", 1 ) == "c" );
assert( after( "abc", 2 ) == "" );

assert(	after(ts, 40 ) == nullString );
assert(	after(ts) == "his is a test" );
//echo( after(ts, tsEnd) );
assert(	after(ts, tsEnd) == nullString );
//echo( after(ts, tsQty) );
assert(	after(ts, tsQty) == nullString );
assert(	after(ts, undef) == undef );
assert( after( ts, [] ) == undef );


 
echo( "testing str_from_to(string, start, end)" ); 
assert( is_undef( str_from_to("bar", undef, undef) ) );
assert( is_undef( str_from_to("bar", undef, 1) ) );
assert( is_undef( str_from_to("bar", 1, undef) ) );
// echo( sft=str_from_to( ts, -1,  1) );
assert( is_undef( str_from_to( ts, -1,  1) ) );
assert( is_undef( str_from_to( ts, 0, -1) ) );

assert( str_from_to( "short", 0, 0)  == "s" );
assert( str_from_to( "short", 1, 1)  == "h" );
assert( str_from_to( "short", 2, 2)  == "o" );
assert( str_from_to( "short", 3, 3)  == "r" );
assert( str_from_to( "short", 4, 4)  == "t" );
assert( is_undef( str_from_to( "short", 5, 5) ) );
assert( is_undef( str_from_to( "short", 6, 6) ) );

assert( str_from_to( "short", 0, 0) == "s" );
assert( str_from_to( "short", 0, 1) == "sh" );
assert( str_from_to( "short", 0, 2) == "sho" );
assert( str_from_to( "short", 0, 3) == "shor" );
assert( str_from_to( "short", 0, 4) == "short" );
assert( str_from_to( "short", 0, 5) == "short" );
assert( str_from_to( "short", 0, 6) == "short" );

assert( is_undef( str_from_to( "short", 1, 0) ) ); // undef as start is > end
assert( str_from_to( "short", 1, 1) ==  "h" ); // start == end
assert( str_from_to( "short", 1, 2) ==  "ho" ); 
assert( str_from_to( "short", 1, 3) ==  "hor" ); 
assert( str_from_to( "short", 1, 4) ==  "hort" );
assert( str_from_to( "short", 1, 5) ==  "hort" ); 
assert( str_from_to( "short", 1, 6) ==  "hort" );

assert( is_undef( str_from_to( "short", 2, 0 ) ) ); // undef as start is > end
assert( is_undef( str_from_to( "short", 2, 1 ) ) ); // undef as start is > end

// echo( str_from_to( "short", 2, 2) );
assert( str_from_to( "short", 2, 2) ==  "o" );
assert( str_from_to( "short", 2, 3) ==  "or" );
assert( str_from_to( "short", 2, 4) ==  "ort" );

assert( str_from_to( "short", 4, 4) ==  "t" );
assert( str_from_to( "short", 4, 5) ==  "t" );
assert( str_from_to( "short", 4, 6) ==  "t" );

assert( is_undef( str_from_to( "short",  20, 20 ) ) );
assert( is_undef( str_from_to( "short",  -1, 20 ) ) );
assert( "short" == str_from_to( "short",   0, 20 ) );
//echo(str_from_to( "short", 2, 20 ));
assert( str_from_to( "short", 2, 20 ) == "ort" );
assert( str_from_to( ts,  5, 6 ) == "is" );
assert( is_undef( str_from_to( ts,  6,  5) ) );


echo( "testing str_between_indecies()" ); 
assert( str_between_indecies("bar", undef, undef) == undef );
assert( str_between_indecies("bar", undef, 1) == undef );
assert( str_between_indecies("bar", 1, undef) == undef );
assert( str_between_indecies( ts, -1,  1) == ts[0] );
assert( str_between_indecies( "xyz",  1,  2) == "y" );
assert( str_between_indecies( "this",  1,  3) == "hi" );
assert( str_between_indecies( "this",  0,  2) == "th" );
assert( str_between_indecies( "this",  1,  1) == nullString );
assert( is_undef( str_between_indecies( ts, -1, -1) ) );
assert( str_between_indecies( "short", 0, 0) == "" );
assert( str_between_indecies( "short", 0, 1) == "s" );
assert( str_between_indecies( "short", 0, 2) == "sh" );
assert( str_between_indecies( "short", 0, 3) == "sho" );
assert( str_between_indecies( "short", 0, 4) == "shor" );
assert( str_between_indecies( "short", 0, 5) == "short" );
assert( str_between_indecies( "short", 0, 6) == "short" );

assert( is_undef( str_between_indecies( "short", 1, 0) ) ); // undef as start is > end
assert( str_between_indecies( "short", 1, 1) ==  "" ); // start == end
assert( str_between_indecies( "short", 1, 2) ==  "h" ); // corrent
assert( str_between_indecies( "short", 1, 3) ==  "ho" ); // corrent
assert( str_between_indecies( "short", 1, 4) ==  "hor" ); // corrent
assert( str_between_indecies( "short", 1, 5) ==  "hort" ); // hor
assert( str_between_indecies( "short", 1, 6) ==  "hort" ); // hor

assert( is_undef( str_between_indecies( "short", 2, 0 ) ) ); // undef as start is > end
assert( is_undef( str_between_indecies( "short", 2, 1 ) ) ); // undef as start is > end
assert( str_between_indecies( "short", 2, 2) ==  "" );
assert( str_between_indecies( "short", 2, 3) ==  "o" );
assert( str_between_indecies( "short", 2, 4) ==  "or" );
assert( str_between_indecies( "short", 2, 5) ==  "ort" );

assert( str_between_indecies( "short", 4, 4) ==  "" );
assert( str_between_indecies( "short", 4, 5) ==  "t" );
assert( str_between_indecies( "short", 4, 6) ==  "t" );


assert(  is_undef( str_between_indecies( "short",  20, 20 ) ) );
assert( "short" == str_between_indecies( "short",  -1, 20 ) );
assert( "short" == str_between_indecies( "short",   0, 20 ) );
//echo(str_between_indecies( "short", 2, 20 ));
assert( str_between_indecies( "short", 2, 20 ) == "ort" );
assert( str_between_indecies( ts,  5,  7 ) == "is" );
assert( is_undef( str_between_indecies( ts,  7,  5) ) );



echo( "testing _str_sub_from_for:" );
echo( "\tfrom to last" );
assert( _str_sub_from_for( "short", 0,5 )  == "short" );
assert( _str_sub_from_for( "short", 1,5 )  == "hort" );
assert( _str_sub_from_for( "short", 2,5 )  == "ort" );
assert( _str_sub_from_for( "short", 3,5 )  == "rt" );
assert( _str_sub_from_for( "short", 4,5 )  == "t" );
assert( is_undef( _str_sub_from_for( "short", 5,5 ) ) );
assert( is_undef( _str_sub_from_for( "short", 6,5 ) ) );


echo( "\tfrom for" );
assert( is_undef( _str_sub_from_for( "short", 0, 0 ) ) );
assert( _str_sub_from_for( "short", 0, 1 ) == "s" );
assert( _str_sub_from_for( "short", 0, 2 ) == "sh" );
assert( _str_sub_from_for( "short", 0, 3 ) == "sho" );
assert( _str_sub_from_for( "short", 0, 4 ) == "shor" );
assert( _str_sub_from_for( "short", 0, 5 ) == "short" );
assert( _str_sub_from_for( "short", 0, 6 ) == "short" );

echo( "\tfrom 4 for" );
assert( is_undef( _str_sub_from_for( "short", 10, 2) ) ); 
assert( _str_sub_from_for( "short", 4, 6) == "t" );
assert( _str_sub_from_for( "short", 4, 1) == "t" );
assert( _str_sub_from_for( "short", 4, 3) == "t" );

echo( "\tspecial cases" );
assert( _str_sub_from_for( "short", 2,  2 ) == "or" );
assert( is_undef( _str_sub_from_for( "short", 2, -2 ) ) );
assert( is_undef( _str_sub_from_for( "short", 2, 0  ) ) );

/* 
        str_sub_from_for
 */
echo( "testing str_sub_from_for:" );
assert( is_undef( str_sub_from_for( 42) ) );
assert( is_undef( str_sub_from_for( []) ) );
assert( is_undef( str_sub_from_for( ts, 50, 2) ) );

echo( "\tonly from" );
assert( str_sub_from_for( "short", 0 ) == "short" );
assert( str_sub_from_for( "short", 1 ) == "hort" );
assert( str_sub_from_for( "short", 2 ) == "ort" );
assert( str_sub_from_for( "short", 3 ) == "rt" );
assert( str_sub_from_for( "short", 4 ) == "t" );
assert( is_undef( str_sub_from_for( "short", 5 ) ) );
assert( is_undef( str_sub_from_for( "short", 6 ) ) );

echo( "\tfrom for" );
assert( str_sub_from_for( "short", 0, 0 ) ==  "" );
assert( str_sub_from_for( "short", 0, 1 ) ==  "s" );
assert( str_sub_from_for( "short", 0, 2 ) ==  "sh" );
assert( str_sub_from_for( "short", 0, 3 ) ==  "sho" );
assert( str_sub_from_for( "short", 0, 4 ) ==  "shor" );

assert( str_sub_from_for( "short", 0, 5 ) ==  "short" );
assert( str_sub_from_for( "short", 0, 6 ) ==  "short" );

echo( "\tfrom 4 for" );
assert( is_undef( str_sub_from_for( "short", 10, 2) ) );
assert( str_sub_from_for( "short", 4, 6) == "t" );
assert( str_sub_from_for( "short", 4, 1) == "t" );
assert( str_sub_from_for( "short", 4, 3) == "t" );

echo( "\tspecial cases" );
assert( str_sub_from_for( "short" ) == "short" );
assert( str_sub_from_for( "short", 2, 2 )  == "or" );
assert( str_sub_from_for( "short", 2, -2 ) == nullString );
assert( str_sub_from_for( "short", 2, 0 )  == nullString );


echo( "testing str_vector_join:" );
assert( str_vector_join(["foo", "bar", "baz"], ", ") == "foo, bar, baz" );
assert( str_vector_join(["foo", "bar", "baz"], "") == "foobarbaz" );
assert( str_vector_join(["foo"], ",") == "foo" );
assert( str_vector_join([], "") == "" );
assert( str_vector_join([], " ") == "" );
assert( str_vector_join([], ",") == "" );


echo( "testing _char_in_set:" );
assert(   _char_in_set("t",  ts) );
assert( ! _char_in_set("T",  ts) );
assert( _char_in_set("T",  mts) );
assert( ! _char_in_set("x",  ts) );
assert( ! _char_in_set( 12,  ts) );
assert( ! _char_in_set( ts, "T" ) ); // false
assert(   _char_in_set("T",  ts, true ) );
assert( ! _char_in_set("x",  ts, true) );
assert( ! _char_in_set( 12,  ts, true) );
assert( ! _char_in_set( ts, "T", true ) ); // first param, char, must be a single character

echo( "testing lower()" );
assert( is_undef( lower( notString ) ) );
assert( lower( "" ) == "" );
assert( lower( "  " ) == "  " );
assert( is_undef( lower( 32 ) ) );
assert( lower("!@#$1234FOOBAR!@#$1234") == "!@#$1234foobar!@#$1234");


echo( "testing upper()" );
assert( is_undef( upper( notString ) ) );
assert( upper( "" ) == "" );
assert( upper( "  " ) == "  " );
assert( is_undef( upper( 32 ) ) );
assert( upper("!@#$1234foobar!@#$1234") == "!@#$1234FOOBAR!@#$1234");


echo("testing str_equals:" );
// string must be same length for this function
assert( ! str_equals(digits, "foobar" ) );
assert( str_equals(digits, "0123456789") );
assert( str_equals(nullString, nullString) );
assert( str_equals( ts, mts, ignore_case=true ) );
assert( ! str_equals( "this", "THIS" ) ); // f
assert( str_equals( "this", "THIS", ignore_case=true ) ); // t


echo( "testing starts_with:" );
assert( is_undef( starts_with( 42, "this" ) ) );
assert( is_undef( starts_with( ts, 42 ) ) ); 
assert( ! starts_with( "short", "" ) );
assert( ! starts_with( "short", "", 40 ) ); // pos after end of string
assert( is_undef( starts_with( "this", ts, -1 ) ) );
assert( ! starts_with( ts, "THIS" ) ); // wrong case -> false
assert( starts_with( ts, "THIS", ignore_case=true  ) ); // true
assert( starts_with( "this", "this" ) ); // true
assert( starts_with( "this", "THIS", ignore_case=true ) ); // true


echo(	"\tstarts_with mixed case" );
assert( starts_with( mts, "IS", 5 ) );
assert( ! starts_with( mts, "is", 5 ) );
//echo( null30= starts_with( mts, "IS", 30 ) );
assert( ! starts_with( mts, "IS", 30 ) );
//echo( null4= starts_with( mts, "IS", 4 ) );
assert( ! starts_with( mts, "", 5 ) );
assert( starts_with( mts, " ", 4 ) );
//echo( null5= starts_with( "xxx", "x", 5 ) );
assert( ! starts_with( "xxx", "x", 5 ) );
assert( starts_with( "xxx", "x", 2 ) );
assert( ! starts_with( "", "test", -1 ) );
assert( ! starts_with( "test", "test", -6 ) );
assert( starts_with( ts, "his", 1) );

echo(	"\tstarts_with ignore case" );
assert( starts_with( ts, "IS", 5, true ) ); // should match
assert( starts_with( mts, "IS", 5, true ) );
//echo( null30= starts_with( mts, "IS", 30, true ) );
assert( ! starts_with( mts, "IS", 30, true ) );
assert( ! starts_with( mts, "", 5, true ) );
assert( starts_with( mts, " ", 4, true ) );
//echo( null5= starts_with( "xxx", "x", 5, true ) );
assert( ! starts_with( "xxx", "x", 5, true ) );
assert( ! starts_with( "", "test", -1, true ) );
assert( starts_with( ts, "his", 1, true ) );


echo( "testing _match()" );
assert(   _match( ts, "this", 0 ) == 4 );
assert( ! _match( ts, "THIS", 0 ) );
assert(   _match( mts, "IS", 5 ) == 7 );
assert( ! _match( mts, "is", 5 ) );

assert( ! _match( mts, "", 5 ) );

assert(   _match( ts, "THIS", 0, ignore_case=true ) == 4 );
assert(   _match( ts, "this", 0, ignore_case=true ) == 4 );
assert(   _match( mts, "IS",  5, ignore_case=true ) == 7 );
assert(   _match( mts, "is",  5, ignore_case=true ) == 7 );


echo( "\tends_with with case()" );
assert( ends_with( ts, "test") );
assert( ! ends_with( mts, "test") );
assert( ends_with( ts, "") );
assert( ! ends_with( "xxx", "test") );
assert( ends_with( "xxx", "x") );
assert( ! ends_with( "", "test" ) );

echo( "testing ends_with and case true" ); 
assert( ends_with( mts, " a test", true ) );
assert( ends_with( mts, " a tESt", true ) );
assert( ends_with( mts, ""), true  );
assert( ends_with( "xxx", "X", true ) );
assert( ! ends_with( "", "TEST", true  ) );


echo( "testing trim:" );
assert( trim(pts) == ts );
assert( trim(str(" ",ts)) == ts );
assert( trim(str(ts," ")) == ts );
assert( trim(ts) == ts );
assert( trim("") == "" );
assert( trim(" ") == "" );
assert( trim("  ") == "" );
assert( is_undef( trim( 42 ) ) );
assert( is_undef( trim(undef) ) );
 

echo( "testing reverse:" );
assert( reverse("bar") == "rab" );
assert( reverse("ba") == "ab" );
assert( reverse("") == "" );
assert( is_undef( reverse( notString ) ) );


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

echo( "testing _char_in_set" );
assert( _char_in_set( " ", " " ) );
assert( _char_in_set( " ", "abc " ) );
assert( _char_in_set( " ", " abc " ) );
assert( _char_in_set( "c", "abc " ) );
assert( ! _char_in_set( "z", "abc " ) );

assert( _match_set( ts, " "    ) == pos0 );   // 0 - not found
assert( _match_set( ts, " ", 4 ) == pos5 );   // 5
assert( _match_set( ts, " ", 7 ) == pos8 );   // 8
assert( _match_set( pts, " "   ) == pos1 );   // 1

echo( "testing _match_set_reverse(string, set, pos)" );

assert( _match_set_reverse( "aaabbbccc", "c", 9 )   == 6 ); // 3
assert( _match_set_reverse( "aaabbbccc", "b", 9 )   == 9 ); // 0, input pos when not found
assert( _match_set_reverse( "abcbbbcbc", "bc", 9 )  == 1 ); // 3
assert( _match_set_reverse( "abbbbbccc", "ab", 9 )  == 9 ); // 6
assert( _match_set_reverse( "aaabbbccc", "abc", 9 ) == 0 ); // 0
assert( _match_set_reverse( "bbbcccaaa", "a", 9 )   == 6 ); // 
assert( _match_set_reverse( "aaabbbcccaaa", "a", 12 )== 9 ); // 3
assert( _match_set_reverse( "aaabbbcccaaa", "ac", 12 )== 6); // 3
assert( _match_set_reverse( "bbbcccaaa", "abc", 9 ) == 0 ); // 9
assert( _match_set_reverse( "aaabbbcccaaa", "abc", 12 )== 0 );// 12

assert( _match_set_reverse( "bbbcccaaa",      "a",  pos9 ) == pos6 );//  4, input pos !
assert( _match_set_reverse( "bbbcccaaa",      "a",  pos8 ) == pos6 );//  5
assert( _match_set_reverse( "bbbcccaaa",      "a",  pos7 ) == pos6 );//  9, correct
assert( _match_set_reverse( "aaabbbcccaaa",   "a",  pos5 ) == pos5 );//  7, input pos
assert( _match_set_reverse( "aaabbbcccaaa",   "a",  2 ) == pos0 );// 20, not found, return input pos
assert( _match_set_reverse( "aaabbbcccaaa",  "ac",  pos12 ) == pos6 );//12 correct
assert( _match_set_reverse( "aaabbbcccaaa", "abc",  pos12 ) == 0 );// 12 correct

// echo( tsQty = tsQty );
assert( _match_set_reverse( ts, " ", tsQty ) == tsQty );    // tsQty - not found
assert( _match_set_reverse( ts, " ", tsQty-4 ) == tsQty-5 ); 
assert( _match_set_reverse( ts, " ", tsQty-6 ) == tsQty-7 ); 
assert( _match_set_reverse( pts, " ", len(pts) ) == len(pts)-1 ); 
assert( _match_set_reverse( "     ", " ", 5 ) == 0 );

null  = "";

one   = "oneword";
two   = "two words";
start = " start";
end   = "end ";
both  = " both ";
all   = " all all ";
test  = "this is a test";
multi = "  mul  ti  ";
mul3  = "mul   ti   ple   ";
abcd  = " a b c d ";

echo( "testing _index_of_first()" );

fnull  = _index_of_first( null  );
fone   = _index_of_first( one   );
ftwo   = _index_of_first( two   );
fstart = _index_of_first( start );
fend   = _index_of_first( end   );
fboth  = _index_of_first( both  );
fall   = _index_of_first( all   );
ftest  = _index_of_first( test  );
fabcd  = _index_of_first( abcd  );
fmulti = _index_of_first( multi ); 
fmul2  = _index_of_first( multi, "  " );
fmul3  = _index_of_first( mul3  );
fmul33 = _index_of_first( mul3, "   " );

if( _TEST_ENABLED_ ) {
echo( fnull = fnull );
echo( fone = fone  );
echo( ftwo = ftwo  );
echo( fstart = fstart);
echo( fend = fend  ); 
echo( fabcd = fabcd );
echo( fboth = fboth );
echo( fall = fall  );
echo( ftest = ftest );
echo( fmulti =fmulti); 
echo( fmul2=fmul2  );
echo( fmul3  =fmul3);
echo( fmul33 =fmul33 );
}

assert( is_undef( fnull ) );
assert( is_undef( fone  ) );
assert(  _index_of_first( two   ) == ftwo   );
assert(  _index_of_first( start ) == fstart );
assert(  _index_of_first( end   ) == fend );
assert(  _index_of_first( both  ) == fboth );
assert(  _index_of_first( all   ) == fall );
assert(  _index_of_first( test  ) == ftest );
assert(  _index_of_first( abcd  ) == fabcd );
assert(  _index_of_first( multi ) == fmulti ); 
assert(  _index_of_first( multi, "  " )== fmul2  );
assert(  _index_of_first( mul3  )== fmul3  );
assert(  _index_of_first( mul3, "   " )== fmul33  );


assert( _index_of_first( ts, " ", 0 ) == [4,5] );
assert( _index_of_first( "  test  with blanks  ", " ", 0 ) == [0,1] );
assert( _index_of_first( "  test  with blanks  ", "  ", 0 ) == [0,2] );
assert( _index_of_first( ts, "t", 0 ) == [0,1] );
assert( is_undef( _index_of_first( ts, "z", 0 ) ) );


echo( "testing _index_of_recurse( string, delim, indexes, pos )" );

assert( is_undef( _index_of_recurse( one, " ", undef, 0 ) ) );

tsBlanks = [[4, 5], [7, 8], [9, 10]];
assert( _index_of_recurse( ts, " ", [4,5], 0 ) == tsBlanks );
manyBlanksString = "  test  with blanks  ";
manyBlanks = [[0, 1], [1, 2], [6, 7], [7, 8], [12, 13], [19, 20], [20, 21]];
assert( _index_of_recurse( manyBlanksString, " ", [0,1], 0 ) == manyBlanks );
dubleBlanks = [[0, 2], [6, 8], [19, 21]];
assert( _index_of_recurse( manyBlanksString, "  ", [0,2], 0 ) == dubleBlanks );
threeTees = [[0, 1], [10, 11], [13, 14]];
assert( _index_of_recurse( ts, "t", [0,1], 0 ) == threeTees );
notFound = [];
assert( is_undef( _index_of_recurse( ts, "z", undef, 0 ) ) );
assert( is_undef( _index_of_recurse( ts, "z", [], 0 ) ) );

rnull  = _index_of_recurse( null,  " ",fnull,  0 );
rone   = _index_of_recurse( one,   " ",fone,   0 );
rtwo   = _index_of_recurse( two,   " ",ftwo,   0 );
rstart = _index_of_recurse( start, " ",fstart, 0 );
rend   = _index_of_recurse( end,   " ",fend,   0 );
rboth  = _index_of_recurse( both,  " ",fboth,  0 );
rall   = _index_of_recurse( all,   " ",fall,   0 );
rtest  = _index_of_recurse( test,  " ",ftest,  0 );
rabcd  = _index_of_recurse( abcd,  " ", fabcd, 0 );
rmulti = _index_of_recurse( multi, " ", fmulti,0 );
rmul2  = _index_of_recurse( multi, "  ", fmul2,0 );
rmul3  = _index_of_recurse( mul3,  " ", fmul3, 0 );
rmul33 = _index_of_recurse( mul3, "   ", fmul33, 0 );

if( _TEST_ENABLED_ ) {
echo( rnull  = rnull  );
echo( rone   = rone   );
echo( rtwo   = rtwo   );
echo( rstart = rstart );
echo( rend   = rend   ); 
echo( rabcd  = rabcd  );
echo( rboth  = rboth  );
echo( rall   = rall   );
echo( rtest  = rtest  );
echo( rmulti = rmulti ); 
echo( rmul2  = rmul2  );
echo( rmul3  = rmul3  );
echo( rmul33 = rmul33 );
}

assert( is_undef(  _index_of_recurse( null,  " ",fnull,  0 ) ) );
assert( is_undef(  _index_of_recurse( one,   " ",fone,   0 ) ) );
assert(  _index_of_recurse( two,   " ",ftwo,   0 ) == rtwo );
assert(  _index_of_recurse( start, " ",fstart, 0 ) == rstart );
assert(  _index_of_recurse( end,   " ",fend,   0 ) == rend );
assert(  _index_of_recurse( both,  " ",fboth,  0 ) == rboth );
assert(  _index_of_recurse( all,   " ",fall,   0 ) == rall );
assert(  _index_of_recurse( test,  " ",ftest,  0 ) == rtest );
assert(  _index_of_recurse( abcd,  " ", fabcd, 0 ) == rabcd );
assert(  _index_of_recurse( multi, " ", fmulti,0 ) == rmulti );
assert(  _index_of_recurse( multi, "  ", fmul2,0 ) == rmul2 );
assert(  _index_of_recurse( mul3,  " ", fmul3, 0 ) == rmul3 );
assert(  _index_of_recurse( mul3, "   ", fmul33, 0 ) == rmul33 );

echo( "\n\ttesting  _index_of( string, delim, pos=0 )" );

assert( is_undef( _index_of( ts, " ", 50 ) ) );
assert( _index_of( ts, " ", 0 ) == tsBlanks );

assert( _index_of( manyBlanksString, " ", 0 ) == manyBlanks );
assert( _index_of( manyBlanksString, "  ", 0 ) == dubleBlanks );
assert( _index_of( ts, "t", 0 ) == threeTees );
assert( _index_of( ts, "z", 0 ) == [] );

inull  = _index_of( null,  " ",  0 );
ione   = _index_of( one,   " ",  0 );
itwo   = _index_of( two,   " ",  0 );
istart = _index_of( start, " ",  0 );
iend   = _index_of( end,   " ",  0 );
iboth  = _index_of( both,  " ",  0 );
iall   = _index_of( all,   " ",  0 );
itest  = _index_of( test,  " ",  0 );
iabcd  = _index_of( abcd,  " ",  0 );
imulti = _index_of( multi, " " , 0 );
imul2  = _index_of( multi, "  ", 0 );
imul3  = _index_of( mul3,  " " , 0 );
imul33 = _index_of( mul3, "   ", 0 );

if( _TEST_ENABLED_ ) {
echo( inull  = inull  );
echo( ione   = ione   );
echo( itwo   = itwo   );
echo( istart = istart );
echo( iend   = iend   ); 
echo( iabcd  = iabcd  );
echo( iboth  = iboth  );
echo( iall   = iall   );
echo( itest  = itest  );
echo( imulti = imulti ); 
echo( imul2  = imul2  );
echo( imul3  = imul3  );
echo( imul33 = imul33 );
}
assert( is_undef(  _index_of( null,  " ",  0 ) ) );
assert(  _index_of( one,   " ",  0 ) == [] );
assert(  _index_of( two,   " ",  0 ) == itwo );
assert(  _index_of( start, " ",  0 ) == istart );
assert(  _index_of( end,   " ",  0 ) == iend );
assert(  _index_of( both,  " ",  0 ) == iboth );
assert(  _index_of( all,   " ",  0 ) == iall );
assert(  _index_of( test,  " ",  0 ) == itest );
assert(  _index_of( abcd,  " ",  0 ) == iabcd );
assert(  _index_of( multi, " " , 0 ) == imulti );
assert(  _index_of( multi, "  ", 0 ) == imul2 );
assert(  _index_of( mul3,  " " , 0 ) == imul3 );
assert(  _index_of( mul3, "   ", 0 ) == imul33 );

// return a vector of the words in the given string
//  the default is to separate on space characters, but any
//  string can be used to separate blocks of text in the input

echo( "testing str_split( string, delim )" );

if( _TEST_ENABLED_ ) {
echo( blk1=str_split( manyBlanksString, " " ) ); // == [" ", " ", "test", " ", " ", "with", "blanks", " ", " "] );
echo( blk2=str_split( manyBlanksString, "  " ) ); // == ["  ", "test", "  ", "with blanks", "  "] );

echo( onT =str_split( ts, "t" ) ); // ==  ["his is a ", "es"] );
echo( onZ=str_split( ts, "z" ) ); // undef
}

echo( "\n\ttesting _new_split ( string, delims )" );
snull  = _new_split( one,   inull   );
sone   = _new_split( one,   ione    );
stwo   = _new_split( two,   itwo    );
sstart = _new_split( start, istart  );
send   = _new_split( end,   iend    );
sabcd  = _new_split( abcd,  iabcd   );
sboth  = _new_split( both,  iboth   );
sall   = _new_split( all,   iall    ); 
stest  = _new_split( test,  itest   );
smulti = _new_split( multi, imulti  );
smul2  = _new_split( multi, imul2   );
smul3  = _new_split( mul3,  imul3   );
smul33 = _new_split( mul3,  imul33  );

if( _TEST_ENABLED_ ) {
echo( snull  = snull );
echo( sone   = sone );
echo( stwo   = stwo );
echo( sstart = sstart );
echo( send   = send );
echo( sabcd  = sabcd );
echo( sboth  = sboth );
echo( sall   = sall ); 
echo( stest  = stest );
echo( smulti = smulti );
echo( smul2  = smul2 );
echo( smul3  = smul3 );
echo( smul33 = smul33 );
}

assert( is_undef( _new_split( one,   inull ) ) );
assert(   _new_split( one,   ione    ) == sone );
assert(   _new_split( two,   itwo    ) == stwo );
assert(   _new_split( start, istart  ) == sstart );
assert(   _new_split( end,   iend    ) == send );
assert(   _new_split( abcd,  iabcd   ) == sabcd );
assert(   _new_split( both,  iboth   ) == sboth );
assert(   _new_split( all,   iall    ) == sall ); 
assert(   _new_split( test,  itest   ) == stest );
assert(   _new_split( multi, imulti  ) == smulti );
assert(   _new_split( multi, imul2   ) == smul2 );
assert(   _new_split( mul3,  imul3   ) == smul3 );
assert(   _new_split( mul3,  imul33  ) == smul33 );


echo( "\n\ttesting new_split ( string, separator )" );
if( _TEST_ENABLED_ ) {
echo( blk1=new_split( manyBlanksString, " " ) ); // == [" ", " ", "test", " ", " ", "with", "blanks", " ", " "] );
echo( blk2=new_split( manyBlanksString, "  ") ); // == ["  ", "test", "  ", "with blanks", "  "] );

echo( tst=new_split( ts, "t" ) ); // ==  ["his is a ", "es"] );
echo( tsz=new_split( ts, "z" ) ); // undef
}
assert( new_split( manyBlanksString, " " )  == [" ", " ", "test", " ", " ", "with", " ", "blanks", " ", " "] );
assert( new_split( manyBlanksString, "  ")  == ["  ", "test", "  ", "with blanks", "  "] );

assert( new_split( ts, "t" ) ==  [" ", "his is a ", " ", "es", " "] );
assert( new_split( ts, "z" ) == [ts] );

tsnull = new_split( ts, null  );
tnull  = new_split( null  );
tone   = new_split( one   );
ttwo   = new_split( two   );
tstart = new_split( start );
tend   = new_split( end   );
tabcd  = new_split( abcd  );
tboth  = new_split( both  );
tall   = new_split( all   ); 
ttest  = new_split( test  );
tmulti = new_split( multi );
tmul2  = new_split( multi, "  " );
tmul3  = new_split( mul3  );
tmul33 = new_split( mul3, "   " );

if( _TEST_ENABLED_ ) {
echo( tsnull = tsnull );
echo( tnull  = tnull  );
echo( tone   = tone   );
echo( ttwo   = ttwo   );
echo( tstart = tstart );
echo( tend   = tend   );
echo( tabcd  = tabcd  );
echo( tboth  = tboth  );
echo( tall   = tall   ); 
echo( ttest  = ttest  );
echo( tmulti = tmulti );
echo( tmul2  = tmulti );
echo( tmul3  = tmul3  );
echo( tmul33 = tmul3  );
}

assert(  new_split( ts, null  ) == tsnull );
assert(  new_split( null  )     == tnull );
assert(  new_split( one   ) == tone );
assert(  new_split( two   ) == ttwo );
assert(  new_split( start ) == tstart );
assert(  new_split( end   ) == tend );
assert(  new_split( abcd  ) == tabcd );
assert(  new_split( both  ) == tboth );
assert(  new_split( all   ) == tall ); 
assert(  new_split( test  ) == ttest );
assert(  new_split( multi ) == tmulti );
assert(  new_split( multi, "  " ) == tmul2 );
assert(  new_split( mul3  ) == tmul3 );
assert(  new_split( mul3, "   " ) == tmul33 );

echo( "\n\ttesting _split_only( ... dot ) for floats" );

if( _TEST_ENABLED_ ) {
echo( _index_of( "12",   "." ) );
echo( _index_of( "12.",  "." ) );
echo( _index_of( "12.2", "." ) );
echo( _index_of(   ".2", "." ) );

echo( _split_only( "12",   _index_of( "12",   "." ) ) );
echo( _split_only( "12.",  _index_of( "12.",  "." ) ) );
echo( _split_only( "12.2", _index_of( "12.2", "." ) ) );
echo( _split_only(   ".2", _index_of(   ".2", "." ) ) );

echo( _new_split( "12",   _index_of( "12",   "." ) ) );
echo( _new_split( "12.",  _index_of( "12.",  "." ) ) );
echo( _new_split( "12.2", _index_of( "12.2", "." ) ) );
echo( _new_split(   ".2", _index_of(   ".2", "." ) ) );
}

echo( "testing _parse_float(sections)" );

// echo( ff0 = float_fraction( "1", 0 ) );
assert( float_fraction( "1", 0 ) == 0.1   );

ff1 = float_fraction( "01", 0 );
//echo( is_num( ff1 ) );
//echo( ff1=ff1 );
//echo( str( ff1 ) );
//echo( "should be true ", 0.01 == ff1 );
//echo( "is true ", _nearly_equal( 0.01, ff1 ) );
assert( _nearly_equal( float_fraction( "01", 0 ), 0.01 ) );

ff3 = float_fraction( "001", 0 );
fn3 = 0.001;
//echo( "should be true ", 0.001 == ff3 );
//echo( "should be true ",   fn3 == ff3 );
//echo( "is true ", _nearly_equal( 0.001, ff3 ) );
assert( _nearly_equal( float_fraction( "001", 0 ), 0.001 ) );
assert( _nearly_equal( float_fraction( "001", 0 ), ff3 ) );
assert( _nearly_equal( float_fraction( "001", 0 ), fn3 ) );

ff4 = float_fraction( "123", 0 );
// echo( ff4=ff4);
assert( _nearly_equal( float_fraction( "123", 0 ), 0.123 ) );


assert( is_undef( _split_float("234.234.234", _index_of( "234.234.234", "." ) ) ) );

fl12 = "12";
//echo( "index ", fl12, _index_of( fl12, "." ) );
assert( _split_float(fl12, _index_of( fl12, "." ) ) == 12 );
assert( parse_float(fl12) == 12 );


fl12dot = "12.";
//echo( "index ", fl12dot, _index_of( fl12dot, "." ) );
assert( _split_float(fl12, _index_of( fl12dot, "." ) ) == 12 );
assert( parse_float(fl12dot) == 12 );

fl122 = "12.2";
//echo( "index ", fl122, _index_of( fl122, "." ) );
assert( _split_float(fl122, _index_of( fl122, "." ) ) == 12.2 );
assert( parse_float(fl122) == 12.2 );

fldot2 = ".2";
//echo( "index ", fldot2, _index_of( fldot2, "." ) );
//echo( _split_float(fldot2, _index_of( fldot2, "." ) ) == .2 );
assert( parse_float(fldot2) == 0.2 );
 
assert( parse_float( "-12" )     == -12 );
assert( parse_float( "-12.456" ) == -12.456);
assert( parse_float( "-0.456" )  == -0.456);
assert( parse_float( "-.456" )   == -0.456);

echo( "testing title()" );
assert( is_undef( title( notString ) ) );
assert( title( "" ) == nullString );
threeBlanks = "   ";
assert( title( threeBlanks ) == threeBlanks);
assert( is_undef( title( 32 ) ) ); 

testCorrect = "This Is A Test";
//echo( ts  = title( ts   ) );
//echo( pts = title( pts  ) );
//echo( mts = title( mts  ) ); 

assert( title( ts  )  == testCorrect );
assert( title( pts  ) == str( " ", testCorrect, " " ) );
assert( title( mts )  == testCorrect );

//echo( word_list = new_split( lower(foobar) ) );
//echo( foo = title( foobar ) );

assert( title( foobar ) == foobar );
assert( title( FOOBAR ) == "!@#$1234 Foobar !@#$1234");
 

echo ( "all done" );
