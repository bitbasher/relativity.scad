_numbers_version = 
	[2025, 05, 08];
function numbers_version() = _numbers_version;
function _numbers_version_str() =
	let(n=_numbers_version)
	str( n.x, n.y, n.z, ".", n[3] );

/// Numeric operations and related functions

_NUMTEST_ENABLED = false;

/**
	constants for evaluating the results of
	floating point calculations.
 */
Min_Normal = 2 ^ -1022;
MAX_VALUE = (2-2 ^ -52) * 2 ^ 1023 ; 

if( _NUMTEST_ENABLED ) {
	echo( "testing numbers version ", _numbers_version_str() );
	echo( str( "max ", MAX_VALUE, " min.normal ", Min_Normal ) );
	}

/**
	returns true when the input is undefined
	or is not a number.
 */
function is_not_num( num ) =
	is_undef( num ) || ! is_num( num );

if( _NUMTEST_ENABLED ) {
	echo( "\tis_not_num" );
	echo( is_not_num(undef) );
	echo( is_not_num(42) );
	echo( is_not_num("42") );
	echo( is_not_num([42]) );
	}
assert( ! is_not_num( 42 ) );
assert( ! is_not_num( -2.222 ) );
assert( is_not_num( "string" ) );
assert( is_not_num( [] ) );


/**
	return the sum of the values in a vector
 */
function sum_vec(vec, from = 0, to = undef ) =
	let( end = is_undef( to ) ? len(vec)-1 : to )
	( from == end ? vec[end] : vec[end] + sum_vec(vec, from, end-1 ) );
 
if( _NUMTEST_ENABLED ) {
	echo( "\ttesting sum_vec()" );
	vec=[ 10, 20, 30, 40 ];
	echo("sum vec=", sum_vec( vec, 1, 2 )); // calculates 20+30=50
	echo("sum vec=", sum_vec( vec )); // 100
	}
assert( sum_vec( [ 10, 20, 30, 40 ], 1, 2 ) == 50 ); // 20+30=50
assert( sum_vec( [ 10, 20, 30, 40 ] ) == 100 );
 
/**
	Cumulative sum of values in vector valid
 */
function cumsum_vec(v) =
	let( lenv = len(v) )
    [for(a = v[0], i = 1; i < lenv; 
		a = a+v[i], i = i+1) if(i==lenv-1) a+v[i]
	][0];

if(_NUMTEST_ENABLED) {
echo( "\ttesting cumsum_vec()" );
	csv = [1,3,7,1];
	vec=[ 10, 20, 30, 40 ];
	echo( cs=cumsum_vec( csv ));
	echo( cs=cumsum_vec( vec ));
	}
assert( cumsum_vec( [1,3,7,1] ) == 12 );
assert( cumsum_vec( [10, 20, 30, 40] ) == 100 );

/**
 	return the average of the values in a vector.
	The from and to inputs, if given, are used to
	include only a sub-range of the vector's
	elements in the sum.
	The local qty is conditionally calculated to
	be correct when limits are given.
 */
function avg_vec(vec, from = 0, to=undef ) =
	let( end = is_undef( to ) ? len(vec)-1 : to,
		qty = min( end-from+1, len(vec) )
		)
	// echo( avg=from, end, qty )
	sum_vec( vec, from, end ) / qty ;

if( _NUMTEST_ENABLED ) {
	echo( "\ttesting avg_vec()" );
	vec=[ 10, 20, 30, 40 ];
	echo("avg vec=", avg_vec( vec, 1, 2 )); // (20+30)/2 = 25
	echo("avg vec=", avg_vec( vec )); // also == 25
	}

assert( avg_vec( [ 10, 20, 30, 40 ], 1, 2 ) == 25 );
assert( avg_vec( [ 10, 20, 30, 40 ] ) == 25 );

/**
	return true when the given number's value lies in
	the range of the other two parameters.
	All three parameters must be defined numbers.
	The min and max values are sorted into numeric
	order so values calculated in place as this 
	functions inputs do not need to be ordered.
 */
function num_in_range(num, min_num, max_num) = 
	is_not_num( num ) || is_not_num( min_num ) || is_not_num( max_num ) ?
		undef
	: min([min_num,max_num]) <= num && num <= max([min_num,max_num])
	;

if( _NUMTEST_ENABLED ) {
	echo( "\ttesting _num_in_range()" );
	echo( nir= num_in_range( undef ) );
	echo( nir= num_in_range( 1, 1 ) );
	echo( nir= num_in_range( 2, 0, 12) ); // first correct use - true
	echo( nir= num_in_range( 2, 12, 20) ); // false
	echo( nir= num_in_range( 15, 20, 12) ); // false
	}

assert( is_undef( num_in_range( undef ) ) );
assert( is_undef( num_in_range( 1, 1  ) ) );
assert( num_in_range( 2, 0, 12) ); // first correct use - true
assert( ! num_in_range(  2, 12, 20) ); // false
assert(   num_in_range( 15, 20, 12) ); // false
/**
	returns true when two floating point values are
	within epsilons value of each other.
 */
function _nearly_equal( a, b, epsilon=0.00001 ) =
    abs(( a - b )/ b ) < epsilon 
    ;

/**
	returns true when two floating point values are
	within epsilons value of each other.
	This form of comparison takes account of the
	limitations of representing floating point values
	as binary encoded values. The Min_Normal value
	is derived from the 64 bit values used in
	OpenSCAD.
 */
function nearly_equal( a, b, epsilon=0.00001 ) =
	let(absA = abs(a),
		absB = abs(b),
		diff = abs(a - b)
		)
	a == b ? 
		true // shortcut, handles infinities
	: a == 0 || b == 0 || (absA + absB < Min_Normal ) ?
		// when a or b are zero or both are extremely close to it
		// relative error is less meaningful here
		diff < (epsilon * Min_Normal)
	: diff / min((absA + absB), MAX_VALUE) < epsilon
	;

if( _NUMTEST_ENABLED ) { // BUG _NUMTEST_ENABLED
	echo( "testing _nearly_equal()" );
	echo( _neq= _nearly_equal( 0.01000000000001, 0.01000000000001) );
	echo( _neq= _nearly_equal( 0.01000000000009, 0.01000000000001) );
	echo( _neq1= _nearly_equal( 0.010001,         0.010001) );
	echo( _neq3= _nearly_equal( 0.010003,         0.010001) );
	echo( _neq9= _nearly_equal( 0.010009,         0.010001) );

	echo( "testing nearly_equal()" );
	echo( neq=  nearly_equal( 0.01000001, 0.01000001 ) );
	echo( neq=  nearly_equal( 0.0100001,  0.01000001 ) );
	echo( neq=  nearly_equal( 0.010001,   0.01000001 ) );
	}

assert(   _nearly_equal( 0.01000000000000001,  0.01000000000000001) );
assert(   _nearly_equal( 0.010001,         0.010001) );
assert( ! _nearly_equal( 0.010003,         0.010001) );
assert( ! _nearly_equal( 0.010009,         0.010001) );

assert(    nearly_equal( 0.01000000000000001,  0.01000000000000001) );
assert(    nearly_equal( 0.0100001,  0.01000001 ) );
assert( !  nearly_equal( 0.010001,   0.01000001 ) );

/** example code for using MIN_NORMAL and MAX.VALUE to
   correctly evaluate the difference between two floating
   point values that have a very small difference, or are
   themselves very small.
   Two FP values that should have the same value but are
   calculated in different ways may have small differences
   in their encodings when their differences are close to,
   or less than, the Min.Normal value derived from the
   numerical representation.
   the epsilon value may be set to a value of difference
   acceptable to the application using nearlyEqual() 
   when accuracy is relaxed from the theoretical best 
   values of MIN_NORMAL and MAX.VALUE

public static boolean nearlyEqual(float a, float b, float epsilon) {
	final float absA = Math.abs(a);
	final float absB = Math.abs(b);
	final float diff = Math.abs(a - b);

	if (a == b) { // shortcut, handles infinities
			return true;
    } else if (a == 0 || b == 0 || (absA + absB < Float.MIN_NORMAL)) {
		// a or b is zero or both are extremely close to it
		// relative error is less meaningful here
		return diff < (epsilon * Float.MIN_NORMAL);
		} else { // use relative error
			return diff / Math.min((absA + absB), Float.MAX_VALUE) < epsilon;
		}
	}
 */