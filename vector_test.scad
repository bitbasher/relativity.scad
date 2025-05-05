// test vector operations 
//
include <vectors.scad>
include <strings.scad>
include <unit_test.scad>

echo( "testing _slice()" );

tv8last = 7;
tv8 = [ for( i=[0:tv8last] ) i ]; // fill a test array
tv8len = len(tv8);
tv8start = 0;


echo( "\tis_not_list" );
assert( ! is_not_list( [1,2,3] ) );
assert( ! is_not_list( ["1","2","3"] ) );
assert( ! is_not_list( [] ) );
assert( is_not_list( "string" ) );
assert( is_not_list( 42 ) );
assert( is_not_list( undefList ) )



echo(	"testing part1: startindex([1,2,3,4])" );
echo( startindex( 4, -50 ));   // 0
echo( startindex( 4, -1 ));    // 2
echo( startindex( 4, 0 ));     // 0
echo( startindex( 4, 1 ));     // 1
echo( startindex( 4, 50 ));    // 3

assert( startindex( tv8len, -50 ) == 0);
assert( startindex( tv8len, -tv8last-1 ) == 0);
assert( startindex( tv8len, -tv8last ) == 0 );
assert( startindex( tv8len, -5 ) == 2 );
assert( startindex( tv8len, -1 ) == 6 );
assert( startindex( tv8len, 0 ) == 0 );
assert( startindex( tv8len, tv8last ) == tv8last );
assert( startindex( tv8len, tv8last+1 ) == tv8last );
assert( startindex( tv8len, 50 ) == tv8last );

echo(	"testing part1: lastindex([1,2,3,4])" );
//echo( lastindex( 4, -50 ));    // 0
//echo( lastindex( 4, -1 ));     // 2
//echo( lastindex( 4, 0 ));      // 0
//echo( lastindex( 4, 1 ));      // 1
//echo( lastindex( 4, 50 ));     // 3

assert( lastindex( tv8len, -50 ) == 0);
assert( lastindex( tv8len, -tv8last-1 ) == 0);
assert( lastindex( tv8len, -tv8last ) == 0 );
assert( lastindex( tv8len, -5 ) == 2 );
assert( lastindex( tv8len, -1 ) == 6 );
assert( lastindex( tv8len, 0 ) == 0 );
assert( lastindex( tv8len, tv8last ) == tv8last );
assert( lastindex( tv8len, tv8last+1 ) == tv8last );
assert( lastindex( tv8len, 50 ) == tv8last );

testvec = [ 1, 2, 3, "four", [5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15]];
// testvec with first element removed
tv1 = [ 2, 3, "four", [5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15]];

echo(	"testing part 2: undef detected" );
//echo( _slice( undefArray ) );				// undef
//echo( _slice( testvec, undefStart ) );		// undef
//echo( _slice( testvec, 0, undefEnd ) );		// undef

assert( is_undef( _slice( undefArray ) ) );
assert( is_undef( _slice( testvec, undefStart ) ) );
assert( is_undef( _slice( testvec, 0, undefEnd ) ) );

echo(	"testing part 3: empty lists detected" );
resultvec = _slice( [] );
assert( is_list( resultvec ) && resultvec == [] );
rv2 = _slice( [], 0 );
assert( is_list( rv2 ) && rv2 == [] );		// []
rv3 = _slice( [], 0, -1 );
assert( is_list( rv3 ) && rv3 == [] );		// []

echo(	"testing part 4: using default inputs" );
//echo( "defs ", _slice( testvec ) );		// the testvec is returned
//echo( "0 def", _slice( testvec, 0 ) );	// the testvec is returned
//echo( "0 50 ", _slice( testvec, 0, 50 ) );	// the testvec is returned

assert( _slice( testvec ) == testvec ); // both start n end undef then return whole vector
assert( _slice( testvec, 0 ) == testvec  ); // end undef, return whole vector
assert( _slice( testvec, 0, len(testvec)-1 ) == testvec );		// testvec is returned
assert( _slice( testvec, 0, 50) == testvec );

echo(	"testing part 5: positive start and end" );
//echo( "1    ", _slice( testvec, 1 ) );		// [2, 3, "four" etc]
//echo( "1 -1 ", _slice( testvec, 1, -1 ) );	// ditto
//echo( "1 1  ", _slice( testvec, 1, 1 ) );	// [2]
//echo( "1 2  ", _slice( testvec, 1, 2 ) );	// [2,3]
//echo( "1 3  ", _slice( testvec, 1, 3 ) );	// [2,3,"four"]
//echo( "1 4  ", _slice( testvec, 1, 4 ) );	// [2,3,"four"]
//echo( "1 5  ", _slice( testvec, 1, 5 ) );	// [2,3,"four"]
//echo( "1 6  ", _slice( testvec, 1, 6 ) );	// [2,3, .., 11]
//echo( "1 20 ", _slice( testvec, 1, 20 ) );	// undef ** error

assert( _slice( testvec, 1 ) == tv1 );		// from 1-st to end of array
assert( _slice( testvec, 1, -1 ) );	// ditto
assert( _slice( testvec, 1, 1 ) == [2] );	// [2]
assert( _slice( testvec, 1, 2 ) == [2,3]);	// [2,3]
assert( _slice( testvec, 1, 3 ) == [2,3,"four"] );	// [2,3,"four"]
assert( _slice( testvec, 1, 4 ) == [2,3,"four",[5,6] ] );
assert( _slice( testvec, 1, 5 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10] ] );
assert( _slice( testvec, 1, 6 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( _slice( testvec, 1, 20 ) == tv1 );	// from 1 to 20, reduced to end of array

//echo( "2 2  ", _slice( testvec, 2, 2 ) );	// [3]
assert( _slice( testvec, 2, 2 ) == [3]);	// [3]

//echo( "3 3  ", _slice( testvec, 3, 3 ) );	// ["four"]
//echo( "3 6  ", _slice( testvec, 3, 6 ) );	// ["four" .. 11]
assert( _slice( testvec, 3, 3  ) == ["four"] );	// ["four"]
assert( _slice( testvec, 3, 6  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( _slice( testvec, 3, 7  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );
assert( _slice( testvec, 3, 20 ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );

echo(	"testing part 6: swapping indecies" );
//echo( "3 6  ", _slice( testvec, 3, 6 ) );	// test swapping indecies
//echo( "6 3 swap", _slice( testvec, 6, 3 ) );
assert( _slice( testvec, 6, 3 ) == [ "four", [5,6], ["seven", "eight", 9, 10], 11 ] );

echo(	"testing part 7: negative indecies - start" );
//echo( " tv8 ref", tv8 );
//echo( "-20 def", _slice( tv8, -20 ) );
//echo( "-20 6  ", _slice( tv8, -20, 6 ) );
//echo( "-tv8len 6", _slice( tv8, -tv8len,  6 ) );
//echo( "-tv8last def", _slice( tv8, -tv8last ) );
//echo( "-5 def", _slice( tv8, -5 ) );
//echo( "-1 tv8last", _slice( tv8, -1, tv8last ) );

assert(  tv8 );
assert(  _slice( tv8, -20 ) == tv8 );
tv6 = [ for( i=[0:6] ) i ];
assert(  _slice( tv8, -20, 6 ) == tv6 );
assert(  _slice( tv8, -tv8len,  6 ) == tv6 );
assert(  _slice( tv8, -tv8last ) == tv8 );
assert(  _slice( tv8, -5 ) == [ for( i=[2:tv8last] ) i ] );
assert(  _slice( tv8, -1, tv8last ) == [6,7] );


echo(	"testing part 7: negative indecies - end" );
//echo( "2 -20 invert", _slice( tv8, 2, -20 ) );
//echo( "0  -6       ", _slice( tv8, 0,  -6 ) );
//echo( "0  -1       ", _slice( tv8, 0,  -1 ) );
//echo( "def  -1     ", _slice( tv8, end=-1 ) );
//echo( "def -tv8last", _slice( tv8, end=-tv8last ) );
//echo( "0 -tv8len   ", _slice( tv8, 0, -tv8len ) );

assert(  _slice( tv8, 2, -20 ) == [0,1,2]);
assert(  _slice( tv8, 0,  -6 ) == [0,1]);
assert(  _slice( tv8, 0,  -1 ) == tv6 );
assert(  _slice( tv8, end=-1 ) == tv6 );
assert(  _slice( tv8, end=-tv8last ) == [0] );
assert(  _slice( tv8, 0, -tv8len )   == [0] );


echo("testing vec_equals:" );
assert( is_undef( vec_equals( digits, [] ) ) );
assert( is_undef( vec_equals( [], digits ) ) );
// echo( cd = code_digits );
assert( vec_equals( code_digits,  [48, 49, 50, 51, 52, 53, 54, 55, 56, 57] ) );
assert( vec_equals( [], [] ) );
assert( ! vec_equals( [0,1,2], [0]) );

