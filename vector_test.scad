/// Tests of Vector Operations 

include <vectors.scad>
include <strings.scad>

/// Testing Features
_TEST_ENABLED_ = false;

echo( "testing vector functions of relativity library" );
echo( _vectors_version );
echo( _vectors_version = vectors_version_str() );

echo( "\n\tis_not_list" );
assert( ! is_not_list( [1,2,3] ) );
assert( ! is_not_list( ["1","2","3"] ) );
assert( ! is_not_list( [] ) );
assert( is_not_list( "string" ) );
assert( is_not_list( 42 ) );

echo( "\n\ttesting startindex()" );
assert( startindex( 4, -50 ) == 0 );   // 0
assert( startindex( 4, -1  ) == 2 );   // 2
assert( startindex( 4, 0   ) == 0 );   // 0
assert( startindex( 4, 1   ) == 1 );   // 1
assert( startindex( 4, 50  ) == 3 );   // 3

tv8last = 7;
tv8 = [ for( i=[0:tv8last] ) i ]; // fill a test array
tv8len = len(tv8);
tv8start = 0;

assert( startindex( tv8len, -50 ) == 0);
assert( startindex( tv8len, -tv8last-1 ) == 0);
assert( startindex( tv8len, -tv8last ) == 0 );
assert( startindex( tv8len, -5 ) == 2 );
assert( startindex( tv8len, -1 ) == 6 );
assert( startindex( tv8len, 0  ) == 0 );
assert( startindex( tv8len, tv8last ) == tv8last );
assert( startindex( tv8len, tv8last+1 ) == tv8last );
assert( startindex( tv8len, 50 ) == tv8last );

echo(	"\n\ttesting lastindex()" );
assert( lastindex( 4, -50 ) == 0 );  // 0
assert( lastindex( 4, -1  ) == 2 );  // 2
assert( lastindex( 4, 0   ) == 0 );  // 0
assert( lastindex( 4, 1   ) == 1 );  // 1
assert( lastindex( 4, 50  ) == 3 );  // 3

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

echo(	"\n\ttesting _slice and slice" );

echo(	"\ttesting part 1: detecting empty lists" );
resultvec = _slice( [] );
assert( is_list( resultvec ) && resultvec == [] );
rv2 = _slice( [], 0 );
assert( is_list( rv2 ) && rv2 == [] );		// []
rv3 = _slice( [], 0, -1 );
assert( is_list( rv3 ) && rv3 == [] );		// []

echo(	"\ttesting part 2: using default inputs" );
if( _TEST_ENABLED_ ) {
    echo( "defs ", _slice( testvec ) );		   // the testvec is returned
    echo( "0 def", _slice( testvec, 0 ) );	   // the testvec is returned
    echo( "0 50 ", _slice( testvec, 0, 50 ) );   // the testvec is returned
    }
assert( _slice( testvec        ) == testvec ); // both start n end undef then return whole vector
assert( _slice( testvec, 0     ) == testvec ); // end undef, return whole vector
assert( _slice( testvec, 0, len(testvec)-1  ) == testvec );	// testvec is returned
assert( _slice( testvec, 0, 50 ) == testvec );

echo(	"\ttesting part 3: positive start and end" );
if( _TEST_ENABLED_ ) {
    echo( "1    ", _slice( testvec, 1 ) );		// [2, 3, "four" etc]
    echo( "1 -1 ", _slice( testvec, 1, -1 ) );	// ditto
    echo( "1 1  ", _slice( testvec, 1, 1 ) );	// [2]
    echo( "1 2  ", _slice( testvec, 1, 2 ) );	// [2,3]
    echo( "1 3  ", _slice( testvec, 1, 3 ) );	// [2,3,"four"]
    echo( "1 4  ", _slice( testvec, 1, 4 ) );	// [2,3,"four"]
    echo( "1 5  ", _slice( testvec, 1, 5 ) );	// [2,3,"four"]
    echo( "1 6  ", _slice( testvec, 1, 6 ) );	// [2,3, .., 11]
    echo( "1 20 ", _slice( testvec, 1, 20 ) );	// undef ** error
    }

assert( _slice( testvec, 1 ) == tv1 );		// from 1-st to end of array
assert( _slice( testvec, 1, -1 ) );	        // ditto
assert( _slice( testvec, 1, 1 ) == [2] );	// [2]
assert( _slice( testvec, 1, 2 ) == [2,3]);	// [2,3]
assert( _slice( testvec, 1, 3 ) == [2,3,"four"] );	// [2,3,"four"]
assert( _slice( testvec, 1, 4 ) == [2,3,"four",[5,6] ] );
assert( _slice( testvec, 1, 5 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10] ] );
assert( _slice( testvec, 1, 6 ) == [2,3,"four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( _slice( testvec, 1, 20 ) == tv1 );  // from 1 to 20, reduced to end of array

if( _TEST_ENABLED_ ) {
    echo( "2 2  ", _slice( testvec, 2, 2 ) );	// [3]
    }
assert( _slice( testvec, 2, 2 ) == [3]);	// [3]

if( _TEST_ENABLED_ ) {
    echo( "3 3  ", _slice( testvec, 3, 3 ) );	// ["four"]
    echo( "3 6  ", _slice( testvec, 3, 6 ) );	// ["four" .. 11]
    }
assert( _slice( testvec, 3, 3  ) == ["four"] );	// ["four"]
assert( _slice( testvec, 3, 6  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11 ] );
assert( _slice( testvec, 3, 7  ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );
assert( _slice( testvec, 3, 20 ) == ["four",[5,6], ["seven", "eight", 9, 10], 11, ["twelv", 13, 14, 15] ] );

echo(	"\ttesting part 4: swapping indecies" );
if( _TEST_ENABLED_ ) {
    echo( "3 6  ", _slice( testvec, 3, 6 ) );	// test swapping indecies
    echo( "6 3 swap", _slice( testvec, 6, 3 ) );
    }
assert( _slice( testvec, 6, 3 ) == [ "four", [5,6], ["seven", "eight", 9, 10], 11 ] );

echo(	"\ttesting part 5: negative indecies - start" );
if( _TEST_ENABLED_ ) {
    echo( " tv8 ref", tv8 );
    echo( "-20 def", _slice( tv8, -20 ) );
    echo( "-20 6  ", _slice( tv8, -20, 6 ) );
    echo( "-tv8len 6", _slice( tv8, -tv8len,  6 ) );
    echo( "-tv8last def", _slice( tv8, -tv8last ) );
    echo( "-5 def", _slice( tv8, -5 ) );
    echo( "-1 tv8last", _slice( tv8, -1, tv8last ) );
    }

assert(  tv8 );
assert(  _slice( tv8, -20 ) == tv8 );
tv6 = [ for( i=[0:6] ) i ];
assert(  _slice( tv8, -20, 6 ) == tv6 );
assert(  _slice( tv8, -tv8len,  6 ) == tv6 );
assert(  _slice( tv8, -tv8last ) == tv8 );
assert(  _slice( tv8, -5 ) == [ for( i=[2:tv8last] ) i ] );
assert(  _slice( tv8, -1, tv8last ) == [6,7] );


echo(	"\ttesting part 6: negative indecies - end" );
if( _TEST_ENABLED_ ) {
    echo( "2 -20 invert", _slice( tv8, 2, -20 ) );
    echo( "0  -6       ", _slice( tv8, 0,  -6 ) );
    echo( "0  -1       ", _slice( tv8, 0,  -1 ) );
    echo( "def  -1     ", _slice( tv8, end=-1 ) );
    echo( "def -tv8last", _slice( tv8, end=-tv8last ) );
    echo( "0 -tv8len   ", _slice( tv8, 0, -tv8len ) );
    }

assert(  _slice( tv8, 2, -20 ) == [0,1,2]);
assert(  _slice( tv8, 0,  -6 ) == [0,1]);
assert(  _slice( tv8, 0,  -1 ) == tv6 );
assert(  _slice( tv8, end=-1 ) == tv6 );
assert(  _slice( tv8, end=-tv8last ) == [0] );
assert(  _slice( tv8, 0, -tv8len )   == [0] );


echo("\n\ttesting vector comparison" );
//echo( sd = _STRING_DIGITS );
assert( _STRING_DIGITS != [] );
assert( [] != _STRING_DIGITS );
//echo( cd = _ASCII_DIGITS );
assert( _ASCII_DIGITS == [48, 49, 50, 51, 52, 53, 54, 55, 56, 57] );
assert( [] == [] );
assert( [0,1,2] != [0] );
assert( [0,[1,2,3],4] != [0,1,2,3,4] );

echo( "all done" );