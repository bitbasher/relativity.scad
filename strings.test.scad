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


echo( "testing ascii_code" );
legalCodes = ts;
illegalCodes = "\u20AC 10 \u263A"; // UNICODE for 10 euro and a smilie;

//echo( "legal codes ", legalCodes, ascii_code(legalCodes) );
//echo( "illegal codes ", illegalCodes, ascii_code(illegalCodes) );

// legalCodes
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
assert( ! str_is_allspaces( "" ) );
assert( str_is_allspaces( "  " ) );
assert( ! str_is_allspaces( "abcd" ) );
assert( ! str_is_allspaces( " a b c d " ) );
assert( is_undef( str_is_allspaces( [] ) ) );
assert( is_undef( str_is_allspaces( ["  "] ) ) );


echo( "testing before()" );
assert( before(ts, -1) == nullString );
assert( before(ts, 0) == nullString );
assert( before(ts, 1) == ts[0] );
assert( before(ts, 2) == str(ts[0],ts[1]) );
assert( before(ts, tsEnd) == "this is a tes" );
assert( before(ts, tsQty) == ts );
assert( before(ts, undef) == undef );
   

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

echo( "testing lower()" );
//echo( lt=lower( notString ) );
//echo( lt=lower( "" ) );
//echo( lt=lower( "  " ) );
//echo( lt=lower( 32 ) );
assert( is_undef( lower( notString ) ) );
assert( lower( "" ) == "" );
assert( lower( "  " ) == "  " );
assert( is_undef( lower( 32 ) ) );
assert( lower("!@#$1234FOOBAR!@#$1234") == "!@#$1234foobar!@#$1234");


echo( "testing upper()" );
//echo( ut=upper( notString ) );
//echo( ut=upper( "" ) );
//echo( ut=upper( "  " ) );
//echo( ut=upper( 32 ) );
assert( is_undef( upper( notString ) ) );
assert( upper( "" ) == "" );
assert( upper( "  " ) == "  " );
assert( is_undef( upper( 32 ) ) );
assert( upper("!@#$1234foobar!@#$1234") == "!@#$1234FOOBAR!@#$1234");


echo( "testing title()" );
//echo( lt=title( notString ) );
//echo( lt=title( "" ) );
//echo( lt=title( "  " ) );
//echo( lt=title( 32 ) );
assert( is_undef( title( notString ) ) );
assert( title( "" ) == "" );
assert( title( "  " ) == "  " );
assert( is_undef( title( 32 ) ) );
assert( title("!@#$1234FOOBAR!@#$1234") == "!@#$1234foobar!@#$1234");
assert( title( ts  ) == "this is a test" );
assert( title( pts  ) == " this is a test " );
assert( title( mts ) == "This Is a Test" );

echo("testing equals:" );
assert( ! equals(ts, "foobar" ) );
assert( equals(ts, ts) );
assert( equals(nullString, nullString) );
assert( equals(ts, mts, ignore_case=true) );

echo(	"testing starts_with:" ); 
assert( starts_with( ts, "this") );
assert( ! starts_with( ts, "THIS") );   // default to NOT ignore case
assert( starts_with( ts, "") );         // always match to null string
assert( ! starts_with( "xxx", "test") );
assert( ! starts_with( "", "test") );

assert( starts_with( mts, "IS", 5 ) );
assert( ! starts_with( mts, "is", 5 ) );
//echo( null30= starts_with( mts, "IS", 30 ) );
assert( ! starts_with( mts, "IS", 30 ) );
//echo( null4= starts_with( mts, "IS", 4 ) );
assert( starts_with( mts, "", 5 ) );
assert( starts_with( mts, " ", 4 ) );
//echo( null5= starts_with( "xxx", "x", 5 ) );
assert( ! starts_with( "xxx", "x", 5 ) );
assert( starts_with( "xxx", "x", 2 ) );
assert( ! starts_with( "", "test", -1 ) );
assert( ! starts_with( "test", "test", -6 ) );
assert( starts_with( ts, "his", 1) );

assert( starts_with( ts, "IS", 5, true ) );
assert( starts_with( mts, "IS", 5, true ) );
//echo( null30= starts_with( mts, "IS", 30, true ) );
assert( ! starts_with( mts, "IS", 30, true ) );
assert( starts_with( mts, "", 5, true ) );
assert( starts_with( mts, " ", 4, true ) );
//echo( null5= starts_with( "xxx", "x", 5, true ) );
assert( ! starts_with( "xxx", "x", 5, true ) );
assert( ! starts_with( "", "test", -1, true ) );
assert( starts_with( ts, "his", 1, true ) );

echo( "testing ends_with with case" );
assert( ends_with( ts, "test") );
assert( ! ends_with( mts, "test") );
assert( ends_with( ts, "") );
assert( ! ends_with( "xxx", "test") );
assert( ends_with( "xxx", "x") );
assert( ! ends_with( "", "test" ) );

echo( "testing ends_with no case" ); 
assert( ends_with( mts, " a test", true ) );
assert( ends_with( mts, " a tESt", true ) );
assert( ends_with( mts, ""), true  );
assert( ends_with( "xxx", "X", true ) );
assert( ! ends_with( "", "TEST", true  ) );


echo( "testing is_in_range()" );
assert( is_undef( is_in_range( notStr ) ) );
// echo( ans=is_in_range( 1, 1 ) );
assert( is_undef( is_in_range( 1, 1 ) ) );
assert( is_undef( is_in_range( "str", 1, 2 ) ) );
assert( is_in_range( 2, 0, 12) );

echo( "testing _is_in_range:" );
// echo( ans= _is_in_range( notSTR, 0, 12) );
assert( ! _is_in_range( notSTR, 0, 12) );
assert( ! _is_in_range( 2, 12, 20) );
assert( _is_in_range( 2, 0, 12) );
assert( ! _is_in_range( 2, 20, 12) );

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


echo ( "all done" );
