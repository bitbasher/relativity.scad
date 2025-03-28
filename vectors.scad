_vectors_version = 
	[25, 02, 28, 1];
function vectors_version_vec() =
	_vectors_version;
function vectors_version_str() =
	str( 
    _vectors_version[0], "-",
    _vectors_version[1], "-",
    _vectors_version[2], ".",
    _vectors_version[3]
    );
    

// Vector operations

function is_not_list( list ) =
	is_undef( list ) || ! is_list( list );


// return true if the given vector undef or
//  not a list/vector 
function is_not_vector(vector) = 
	is_not_list( vector ) ;


// return true if the given vector is empty
//  but it must exist or we return undef
function vec_is_empty(vector) = 
	is_not_list( vector ) ? undef : vector == [] ;


function maxOf( first,second) = 
    is_undef(first) || is_undef(second) ?
        undef
    : ! is_num(first) && ! is_num(second) ?
        undef
    : first > second ?
        first
    : second
    ;

function minOf( first,second) = 
    is_undef(first) || is_undef(second) ?
        undef
    : ! is_num(first) && ! is_num(second) ?
        undef
    : first < second ?
        first
    : second
    ;

/* 
LASTINDEX
Returns the index of the last element of an array (list)
following the rules for the "end" parameter of slice().
The array is not known in the function but is assumed to
be an list in the OpenSCAD language.

INPUTS
  lenArray - a whole number value for the number of
    elements in an array.
  end - a whole number code to be processed to calculate
    the last element to be "sliced" from the array.

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
 
     inputs are not checked so they must be defined and 
     be numbers.
 */
function lastindex( lenArray, end ) =
    let( lastInd = lenArray-1 )
    end >= 0 ?
        // end is positive
        minOf(lastInd, end)
    :   // end is negative
        maxOf( 0,lastInd+end )
    ;

//  inputs are not checked
//
function startindex( lenArray, start ) =
    let( lastInd = lenArray-1 )
    start >= 0 ?
        // start is positive
        minOf(lastInd, start)
    :   // start is negative
        maxOf( 0,lastInd+start )
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
    
	is_undef( array ) || ! is_list( array ) ?
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