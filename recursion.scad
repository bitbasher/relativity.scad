/*
	Javascript Operators

nullish means the item is null OR undefined

The nullish coalescing (??) operator is a logical
operator that returns its right-hand side operand
when its left-hand side operand is null or undefined,
and otherwise returns its left-hand side operand.
 */

// Return "item" if it is valid, else "replacement"
//  This is used during recursion to process along a
//  list, or string, to return a valid, known item
//  when an attempt at further recursion fails with
//  an undef result.
function _null_coalesce( item, replacement ) =
	is_undef( item ) ? replacement : item ;

function _coalesce_true( test, trueaction, falseaction ) =
	test ? trueaction : falseaction ;



/*
The nullish coalescing assignment (??=) operator,
also known as the logical nullish assignment operator,
only evaluates the right operand and assigns to the
left if the left operand is nullish (null or undefined).

Nullish coalescing assignment short-circuits,
meaning that x ??= y is equivalent to x ?? (x = y),
except that the expression x is only evaluated once.

No assignment is performed if the left-hand side is
not nullish, due to short-circuiting of the nullish
coalescing operator.
 */
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
  */
function _coalesce_test( value, correct, good, bad ) =
	value == correct ? good : bad;
	;
