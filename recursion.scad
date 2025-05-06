

// return item if it is valid, else the replacement
//  this is used during recursion to process along a
//  list, or string, to return a valid, known item
//  when an attempt at further recursion fails with
//  an undef result.
// This is an alternative to _coalesce_on
function _null_coalesce( item, replacement ) = 
	is_undef( item ) ? replacement : item ;

function _coalesce_true( test, trueaction, falseaction ) = 
	test ? trueaction : falseaction ;

// return value IFF it is valid, else use the fallback
//  this is used during recursion to process along a
//  list, or string, to return a valid, known item
//  when an attempt at further recursion fails with
//  an a predictable, erroneous result.
// This is an alternative to _null_coalesce
function _coalesce_on( value, error, fallback ) = 
	value == error? fallback : value;

/* A more straight forward coalesce function.
 test the given value against the correct value
 and if they are equal then return the good, else the bad
function _coalesce_test( value, correct, good, bad ) =
	value == correct ? good : bad;
	;