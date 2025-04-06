/*
Compiling design (CSG Tree generation)...
ECHO: true
ECHO: ff1 = 0.01
ECHO: "0.01"
ECHO: "should be true ", false
ECHO: true
ECHO: ff3 = 0.001
ECHO: "0.001"
ECHO: ffnum = false
ECHO: ffnum = 0.001
ERROR: Assertion '(float_fraction("001", 0) == fn3)' failed in file float-frac-test.scad, line 29 
TRACE: called by 'assert' in file float-frac-test.scad, line 29 
 */

assert( float_fraction( "1", 0 )   == 0.1   );

ff1 = float_fraction( "01", 0 );
echo( is_num( ff1 ) );
echo( ff1=ff1 );
echo( str( ff1 ) );
echo( "should be true ", 0.01 == ff1 );
echo(  abs(( 0.01 - ff1 )/ ff1 ) < 0.00001  );
assert( nearly_equal( float_fraction( "01", 0 ) , ff1  ) );
assert( nearly_equal( float_fraction( "01", 0 ) , 0.01 ) );

function nearly_equal( a, b, epslion=0.00001 ) =
    abs(( 0.01 - ff1 )/ ff1 ) < epslion 
    ;

ff3 = float_fraction( "001", 0 );
echo( ff001 = is_num( ff3 ) );
echo( ff3 = ff3 );
echo( str( ff3 ) );
// assert( float_fraction( "001", 0 ) == 0.001 );
//echo ( ffnum = float_fraction( "001", 0 ) == 0.001 );
//echo ( ffnum = float_fraction( "001", 0 ) );
assert( nearly_equal( float_fraction( "001", 0 ), ff3 ) );
fn3 = 0.001;
assert( nearly_equal( float_fraction( "001", 0 ), fn3 ) );

function float_fraction( string, start, pow=-1 ) =
    let( laststr = len(string)-1 )
    start > laststr ? 
        0
    : start == laststr ?
        char_to_digit( string[laststr]  ) * 10 ^ pow

    : char_to_digit( string[start] ) * 10 ^ pow +
        float_fraction( string, start+1, pow=pow-1 );
    ;

function char_to_digit( char ) =
    ( ord( char ) - ord("0") ) ;

