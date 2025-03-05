
matrix = 
	[
	["1a","2a","3a","4a"],
	["1b","2b","3b","4b"],
	["1c","2c","3c","4c"],
	["1d","2d","3d","4d"]
	];


//echo( "     ", _slice( matrix ) );
//echo( "0  1 ", _slice( matrix, 0, 1 ) );
//echo( "2  3 ", _slice( matrix, 2, 3 ) );
/*
assert( _slice( matrix ) );
assert( _slice( matrix, 0, 1 ) );
assert( _slice( matrix, 2, 3 ) );
 */

//echo( "1  1 ", _slice( matrix, 1, 1 ) );
//echo( "1    ", _slice( matrix, 1 ) );
//echo( "1 -1 ", _slice( matrix, 1, -1 ) );
//echo( "1  1 ", _slice( matrix, 1, 1 ) );
//echo( "1  2 ", _slice( matrix, 1, 2 ) );
//echo( "1  3 ", _slice( matrix, 1, 3 ) );
//echo( "3  1 ", _slice( matrix, 3, 1 ) );
/*
assert( _slice( matrix, 1, 1 ) );
assert( _slice( matrix, 1 ) );
assert( _slice( matrix, 1, -1 ) );
assert( _slice( matrix, 1, 1 ) );
assert( _slice( matrix, 1, 2 ) );
assert( _slice( matrix, 1, 3 ) );
assert( _slice( matrix, 3, 1 ) );
 */

//echo( "6  8 ", _slice( matrix, 6, 8 ) );
/*
assert( "6  8 ", _slice( matrix, 6, 8 ) );
 */