_numbers_version = 
	[2025, 04, 16];
function numbers_version() = _numbers_version;
function numbes_version_num() =
	_numbers_version.x * 10000 +
	_numbers_version.y * 100 +
	_numbers_version.z;


_NUMTEST_ENABLED = false;


Min_Normal = 2 ^ -1022;
MAX_VALUE = (2-2 ^ -52) * 2 ^ 1023 ; 

if( _NUMTEST_ENABLED ) {
echo( "testing numbers" );
echo( MAX_VALUE, Min_Normal );
}

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

    
function maxOf( first,second) = 
    is_not_num (first) || is_not_num(second) ?
        undef
    : first > second ? first : second ;

function minOf( first,second) = 
    is_not_num (first) || is_not_num(second) ?
        undef
    : first < second ? first : second ;

if( _NUMTEST_ENABLED ) {
echo( maxOf(2,3) );
echo( maxOf(3,2) )
echo( maxOf("2",3) );
echo( maxOf(2,"3") );
echo( maxOf([2],3) );
echo( maxOf([3],2) );

echo( mx=max(2,3) );
echo( mx=max(3,2) );
}


// return the sum of the values in a vector 
function sum_vec(vec, from = 0, to = undef ) =
	let( end = is_undef( to ) ? len(vec)-1 : to )
	( from == end ? vec[end] : vec[end] + sum_vec(vec, from, end-1 ) );
 
 if( _NUMTEST_ENABLED ) {
 vec=[ 10, 20, 30, 40 ];
 echo("sum vec=", sum_vec( vec, 1, 2 )); // calculates 20+30=50
 echo("sum vec=", sum_vec( vec )); // 100
 }
 
 
// Cumulative sum of values in v
function cumsum_vec(v) =
	let( lenv = len(v) )
    [for(a = v[0], i = 1; i < lenv; a = a+v[i], i = i+1) if(i==lenv-1) a+v[i] ][0] ;

if(_NUMTEST_ENABLED) {
csv = [1,3,7,1];
vec=[ 10, 20, 30, 40 ];
echo( cs=cumsum_vec( csv ));
echo( cs=cumsum_vec( vec ));
}

 // return the average of the values in a vector 
function avg_vec(vec, from = 0, to=undef ) =
	let( end = is_undef( to ) ? len(vec)-1 : to,
		qty = minOf( end-from, len(vec) )
		)
	sum_vec( vec, from, end ) / qty ;

if( _NUMTEST_ENABLED ) {
vec=[ 10, 20, 30, 40 ];
echo("avg vec=", avg_vec( vec, 1, 2 )); // calculates 50/2 = 25
echo("avg vec=", avg_vec( vec ));
}

// all three parameters must be defined numbers
function num_in_range(num, min_num, max_num) = 
	is_not_num( num ) || is_not_num( min_num ) || is_not_num( max_num ) ?
		undef
	: min([min_num,max_num]) <= num && num <= max([min_num,max_num])
	;

if( _NUMTEST_ENABLED ) {
echo( "testing _num_in_range()" );
echo( nir= num_in_range( undef ) );
echo( nir= num_in_range( 1, 1 ) );
echo( nir= num_in_range( 2, 0, 12) ); // first correct use - true
echo( nir= num_in_range( 2, 12, 20) ); // false
echo( nir= num_in_range( 15, 20, 12) ); // false
}


function _nearly_equal( a, b, epslion=0.00001 ) =
    abs(( a - b )/ b ) < epslion 
    ;

function nearly_equal( a, b, epslion=0.00001 ) =
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

if( _NUMTEST_ENABLED ) {
echo( neq= _nearly_equal( 0.01000000000000001,  0.01000000000000001) );

echo( neq=  nearly_equal( 0.01000000000000001,  0.01000000000000001) );
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

/*
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