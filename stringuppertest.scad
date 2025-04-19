include <strings.scad>

ts = "this is a test"; // test string
//echo( "ascii code test string ", ascii_code( ts ) );

pts = str( " " , ts , " " );
mts = "This IS a tESt"; // test string with capitals

nullString = "";

tsEnd = len(ts)-1;
tsQty = len(ts);

digits = "0123456789";
code_digits = str_to_ascii(digits);
numbers = "some 123 numb 15.5 ers, a-23nd pun5556; tations99";

foobar = "!@#$1234foobar@#$1234";
FOOBAR = "!@#$1234 FOOBAR !@#$1234";

_TEST_ENABLED_ = false;

echo( first_cap( "word" ) );
echo( first_cap( "a" ) );
echo( first_cap( "A" ) );
echo( first_cap( "two word" ) );
echo( first_cap( " spaces are nice " ) );
echo( first_cap( "19023" ) );

function _cap( word ) = 
    str( upper(word[0]), after(word, 0));

echo( _cap( "word" ) );
echo( _cap( "a" ) );
echo( _cap( " b" ) );
echo( _cap( "two word" ) );
echo( _cap( " spaces are nice " ) );
echo( _cap( "19023" ) );



echo( "testing title()" );
assert( is_undef( title( 43 ) ) );
threeBlanks = "   ";
assert( title( threeBlanks ) == threeBlanks);
assert( is_undef( title( 32 ) ) ); 

testCorrect = "This Is A Test";
echo( ts  = title( ts   ) );
echo( pts = title( pts  ) );
echo( mts = title( mts  ) ); 

assert( title( ts  )  == testCorrect );
assert( title( pts  ) == str( " ", testCorrect, " " ) );
assert( title( mts )  == testCorrect );

echo( foobarlist = new_split( lower(foobar) ) );
echo( foo = title( foobar ) );

assert( title( foobar ) == foobar );
assert( title( FOOBAR ) == "!@#$1234 Foobar !@#$1234");
 
