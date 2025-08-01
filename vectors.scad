_vectors_version = [2025, 05, 08, 1];
function vectors_version_vec() =
	_vectors_version;
function vectors_version_str() =
  let( vv=_vectors_version )
	str( vv.x, vv.y, vv.z, ".", vv[3] );
    
include <numbers.scad>

/// Vector operations

/**
  return true if the given input is NOT a 
  defined item of type "list". Note that
  in OpenSCAD "list" is also known as a vector.

  The intended use is to check inputs to functions
  that should be lists in the form of a tertiary
  "?" operator, like:
    is_not_list(input) ? undef : do_good_stuff(input);
  */
function is_not_list( input ) =
	is_undef( input ) || ! is_list( input );


/**
  return true if the given input is a valid
  list, which decision is deferred to is_not_list().
  This means it must be a defined item that is
  in fact a list.

  The intended use is to check inputs to functions
  that should be lists in the form of a tertiary
  "?" operator, like:
    is_not_vector(input) ? undef : do_good_stuff(input);
*/ 
function is_not_vector(input) = 
	is_not_list( input ) ;


/**
  return true if the given vector is exactly a 
  defined item of list type with no elements.
 */
function vec_is_empty(input) = 
	is_not_list( input ) ? undef : input == [] ;


/**
lastindex()

Returns the index of the last element of an array
(AKA list or vector)
following the rules for the "end" parameter of slice().
The array is not known in the function but is assumed to
be an list in the OpenSCAD language, which means its first
index is zero.

INPUTS
  lenArray - a whole number value giving the quantity of
    elements in an array.
  end - a whole number index value to be checked against
    the last element of an array.

Returns
  index of the last element to be included in the slice
  taken from an array

LOGIC
  if end is positive it represents the last index in 
  an array to be taken for the slice
    if end is greater than the length of the array
      reduce it to lenArray-1 .. the last legal index value
    else
      return end // unchanged
  else 
    // end is negative
    "end" is a distance .. the last element to be
    extracted is "end" indecies from the last index of
    the array.
    example: for lenArray = 8 the last legal index is 7.
     so end = -1 means count 1 element back from the end
     of the array, in this example returning 6 
     and:
        end=-6 means extract to [1]
        end=-lastInd means to count back to the first
        array element .. return zero as its index, and
        also for any value of more negative input.

LOCAL VALUES
    lastInd = length of array - 1
 
    inputs are not checked so they must be defined 
     numbers.
 */
function lastindex( lenArray, end ) =
    let( lastInd = lenArray-1 )
    end >= 0 ?
        // end is positive
        min(lastInd, end)
    :   // end is negative
        max( 0,lastInd+end )
    ;

/**
  startindex()

Returns the index of the first element of an array
(AKA list or vector)
following the rules for the "start" parameter of slice().
The array is not known in the function but is assumed to
be an list in the OpenSCAD language, which means its first
index is zero.

INPUTS
  lenArray - a whole number value giving the quantity of
    elements in an array.
  start - a whole number index value to be checked against
    the first element of an array.

Returns
  index of the first element to be included in the slice
  taken from an array

LOGIC
  if start is positive it represents the first index in 
  an array to be taken for the slice
    if start is less than zero 
      reduce it to zero, the first possible index
    else
      return start unchanged
  else // start is negative
    take "start" as the "distance" from the end of 
    the array to use as the first index of the slice.
 
  EXAMPLES
    with lenArray=8 the last index is 7 so
    start=-3 means extract starting at [4]
    start=-lastInd start with the 0-th element

LOCAL VALUES
    lastInd = length of array - 1
 
    inputs are not checked so they must be defined 
    numbers.
 */
function startindex( lenArray, start ) =
    let( lastInd = lenArray-1 )
    start >= 0 ?
        // start is positive
        min(lastInd, start)
    :   // start is negative
        max( 0,lastInd+start )
    ;


/* 
SLICE
Returns a section of the given array (list) from the index
"start" to the index "end", with variations.

function slice(array, start=0, end=-1) =
    _slice(array, start=start, end=end);

  return a vector extracted from "array" by taking elements
   from positions "start" to "end"
  UNLESS
   start is negative - "start" is theindex of the element to start
    the extraction from, counting from the END of the array.
    "end" is the index of the last element to extract. 
  OR 
    end is negative - extract from index "start" to "end" elements
    from the end of the vector. the default of -1 is to use the -ve
    "end" case to return from "start" to the last element of the
    array, namely index=len(array)-1.

    Special case: if "end" is past the end of array it adjusted
    to indicate the last element of the array, using lastindex()

 checks:
   return undef if array does not exist, or is not a vector (list)
   return an empty vector ( [] ) if "array" is an empty vector
   return undef if start is not defined
   return an empty vector ( [] ) if "start" is past the end
   return undef if end is not defined
 */
function _slice( array, start=0, end="x" ) =
    
	is_not_list( array ) ?
		undef
	: array == [] ?
		[]
	: is_undef( start ) || is_undef( end ) ?
		undef
	: start >= len(array)?
		[] // return a null vector as we are off the end of the "array"
    :
        let( endNum = end == "x" ? len(array)-1 : end )
        _slice_exec( array, start, endNum )
	;

function _slice_exec( array, start, end ) =
    let(
        lenArray=len(array),
        inend = lastindex( lenArray, end ),
        instart = startindex( lenArray, start )
        )
    instart <= inend ?
        _slice_deep( array, instart, inend )
    :
        _slice_deep( array, inend, instart )
        ;

function _slice_deep( array, start, end ) =
    [for (i=[start:end]) array[i]]
	;



/**
	quicksort()

	arr : a vector of numeric values
	output : the same vector of numbers, but sorted
		from smallest to largest

	taken from the example in the OpenSCAD language
	documentation.
 */
function quicksort(arr) =
    vec_is_empty( arr ) ?
        [] 
    : let(
        pivot   = arr[floor(len(arr)/2)],
        lesser  = [ for (y = arr) if (y  < pivot) y ],
        equal   = [ for (y = arr) if (y == pivot) y ],
        greater = [ for (y = arr) if (y  > pivot) y ]
        ) 
      concat( quicksort(lesser), equal, quicksort(greater) )
    ;
