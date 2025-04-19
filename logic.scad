// logic operations

// returns true if the given input is of type string
function is_not_string( unknown ) =
	is_undef( unknown ) || ! is_string( unknown );

// returns true if the given input is of type list
function is_not_list( input ) = 
	is_undef( input ) || ! is_list( input );

// return true if the given string is empty
//  but it must exist or we return undef
function str_is_empty(string) = 
	is_not_string( string ) ? undef :  string == "" ;


// return true when given string is undefined, OR
//  is empty, meaning the null string ( "" )
//  or undef if the input is not a string
function str_is_undef_or_empty(string) = 
	is_not_string( string ) ?
		undef
	: is_undef(string) || string == "" ;

// return true when given a null string ( "" ) or
//  a string that has only space characters ( " " )
// other types of whitespace are counted as non-space
//  characters
function str_is_null_or_allspaces(string) = 
	len( search( " ", string, 0 )[0] ) == len( string );


function any(booleans, index=0) = 
    is_not_list( booleans) || booleans == [] ?
        undef
    : index > len(booleans)?
        false
    : booleans[index]?
        true
    :
        any(booleans, index+1)
    ;

function all(booleans, index=0) =
    is_not_list( booleans) || booleans == [] ?
        undef
	: index >= len(booleans) ?
		true
	: ! booleans[index]?
		false
	: 
		all(booleans, index+1)
	;

/*
echo( "testing logic" );
echo( "\tall" );
assert( ! all( [false,false,false] ) );
assert(   all( [true,true,true] ) );
assert( ! all( [true,false,true] ) );
assert( is_undef( all( [] ) ) );

echo( "\tany" );
assert( ! any( [false,false,false] ) );
assert(   any( [true,true,true] ) );
assert(   any( [true,false,true] ) );
assert( is_undef( any( [] ) ) );
 
echo( "\tis_not_string" );
assert( ! is_not_string( "xyz" ) );
assert( ! is_not_string( "" ) );
assert( ! is_not_string( "   " ) );
assert( is_not_string( [] ) );
assert( is_not_string( 42 ) );
assert( is_not_string( undef ) );


echo( "\tstr_is_empty" );
assert( ! str_is_empty( "  " ) );
assert(   str_is_empty( "" ) );
assert( ! str_is_empty( "xyz" ) );
assert( is_undef( str_is_empty( [] ) ) );


echo( "\tstr_is_undef_or_empty" );
assert( ! str_is_undef_or_empty( "  " ) );
assert(   str_is_undef_or_empty( "" ) );
assert( is_undef( str_is_undef_or_empty( undef ) ) );
assert( ! str_is_undef_or_empty( "xyz" ) );
assert( is_undef( str_is_undef_or_empty( [] )  ) );
assert( is_undef( str_is_undef_or_empty( 42 ) ) ); 
 */