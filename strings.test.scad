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
