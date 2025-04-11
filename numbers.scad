_numbers_version = 
	[2022, 11, 5];
function numbers_version() = _numbers_version;
function numbes_version_num() =
	_strings_version.x * 10000 + _strings_version.y * 100 + _strings_version.z;


_NUMTEST_ENABLED =  false;

function is_not_num( num ) =
	is_undef( num ) || ! is_num( num );

if( _NUMTEST_ENABLED ) {
echo( "\tis_not_num" );
echo( is_not_num(undef) );
echo( is_not_num(42) );
echo( is_not_num("42") );
echo( is_not_num([42]) );

assert( ! is_not_num( 42 ) );
assert( ! is_not_num( -2.222 ) );
assert( is_not_num( "string" ) );
assert( is_not_num( [] ) );
}
    
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
}

 
// all three parameters must be defined numbers
function code_in_range(code, min_code, max_code) = 
	is_not_num( code ) || is_not_num( min_code ) || is_not_num( max_code ) ?
		undef
	: _code_in_range(code, min_code, max_code);

// function with no checking
function _code_in_range(code, min_code, max_code) =
	min_code > max_code ?
		code >= max_code && code <= min_code
	:
		code >= min_code && code <= max_code
	;

if( _NUMTEST_ENABLED ) {
echo( "testing code_in_range()" );
assert( is_undef( code_in_range( undef ) ) );
assert( is_undef( code_in_range( 1, 1 ) ) );
assert(   code_in_range( 2, 0, 12) ); // first correct use - true
assert( ! code_in_range( 2, 12, 20) ); // false
assert(   code_in_range( 15, 20, 12) ); // false
}


function _nearly_equal( a, b, epslion=0.00001 ) =
    abs(( a - b )/ b ) < epslion 
    ;


Min_Normal = 2 ^ -1022;
MAX_VALUE = (2-2 ^ -52) * 2 ^ 1023 ; 


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
echo( _nearly_equal( 0.01000000000000001,  0.01000000000000001) );

echo( nearly_equal( 0.01000000000000001,  0.01000000000000001) );

}
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