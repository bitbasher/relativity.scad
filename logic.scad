/// logic operations

include <vectors.scad>

/// enable testing global variable
_TEST_ENABLED_ = true; // _TEST_ENABLED_


/// returns true if the given input is of type string
function is_not_string( unknown ) =
	is_undef( unknown ) || ! is_string( unknown );

/// returns true if the given input is of type list
function is_not_list( input ) =
	is_undef( input ) || ! is_list( input );

/**
	return true if the given string is empty
	but it must exist or we return undef
 */
function str_is_empty(string) =
	is_not_string( string ) ? undef :  string == "" ;


/**
	return true when given string is undefined, OR
	is empty, meaning the null string ( "" )
	or undef if the input is not a string
 */
function str_is_undef_or_empty(string) =
	is_not_string( string ) ?
		undef
	: is_undef(string) || string == "" ;

/**
	return true when given a null string ( "" ) or
	a string that has only space characters ( " " )
	other types of whitespace are counted as non-space
	characters
 */
function str_is_null_or_allspaces(string) =
	len( search( " ", string, 0 )[0] ) == len( string );

/**
Empty items of any type count as false so all of these
evaluate as false:
	false, 0, -0, "", [], and undef

Non-empty items of all types evaluate as true, so all of
these
	* "false" is a string
	* [0], [ [] ], and [false]
	* the operation of 0/0

All arithmetic, logical, and relational operations
involving undef values evaluate as undef.
An exception is the relational operation undef==undef,
which is true. Other relational operators like < and >
return false when passed illegal arguments.

Note that numeric operations may also return 'nan'
(not-a-number) to indicate an illegal argument.
To illustrate, 0/false is undef, but 0/0 is 'nan'.

Although undef is a language value, 'nan' is not.
The value nan is the only OpenSCAD value that is not
equal to any other value, including itself.
Although you can test if a variable 'x' has the
undefined value using 'x == undef', you can't use
'x == 0/0' to test if x is Not A Number.

Instead, you must use 'x != x' to test if x is nan.
 */

/*
	return true when any of the elements of the
	given vector are true.
	The elements of the vector will be evaluated
	as boolean values according to the rules for
	the different types of the language.
 */
function any(booleans, index=0) =
    vec_is_empty( booleans) ?
        undef
    : index > len(booleans)?
        false
    : booleans[index]? true :
        any(booleans, index+1)
    ;

/*
	return true when all of the elements of the
	given vector evaluate as true.
	The elements of the vector will be evaluated
	as boolean values according to the rules for
	the different types of the lanuage.
 */
function all(booleans, index=0) =
	vec_is_empty( booleans ) ?
        undef
	: index >= len(booleans) ?
		true
	: ! booleans[index]?
		false
	: all(booleans, index+1)
	;

$logic_all=false;
function all_special(booleans, index=0) =
	vec_is_empty( booleans ) ?
        undef
	: index >= len(booleans) ?
		true
	: for(b=booleans)
		$logic_all = $logic_all && b
	;


if( _TEST_ENABLED_ ) {
echo( "\n\ttesting logic" );

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
}
