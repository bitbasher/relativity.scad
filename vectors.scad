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

// return the index to be used as the last element of the
//  extracted array
/* LOGIC
  if end is positive
     if end is greater than the length of the array
      return end = lenArray-1 .. the last legal index value
     else
      return end 
  else // end is negative
     "end" is a distance .. the last element to be
     extracted is "end" indecies from the last index of
     the array. so when end is 7, end=-1 means the last
     index should be 6
     absEnd = -end // take absolute value of "end"
     lastInd = length of array - 1 // 
     if absEnd <= last index 
      return lastInd+end // add a negative = subtraction
       so when lenArray = 8, lastInd = 7
        end=-1 means extract to [6]
        end=-6 means extract to [1]
        end=-lastInd means extract to [0] .. so only
            the first element
     else // absEnd is out past the vector's first element
       end=0 // force last index to zero
 */

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
//  inputs are not checked
//
function lastindex( lenArray, end ) =
    let( 
        lastInd = lenArray-1, 
        absend = end < 0 ? -end : end
        )
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


// will eventually be the interface for the function
function slice(array, start=0, end=-1) =
    _slice(array, start=start, end=end);

//  return a vector extracted from "array" by taking elements
//   from position "start" to (but not including) element "end"
//  UNLESS
//   start is negative - "start" is theindex of the element to start
//    the extraction from, counting from the END of the array.
//    "end" is the index of the last element to extract. 
//  OR 
//    end is negative - extract from index "start" to "end" elements
//    from the end of the vector. the default of -1 is to use the -ve
//    "end" case to return from "start" to the last element of the
//    array, namely index=len(array)-1.
//
//    Special case: if "end" is past the end of array it adjusted
//    to indicate the last element of the array, using lastindex()
//
// checks:
//   return undef if array does not exist, or is not a vector (list)
//   return an empty vector ( [] ) if "array" is an empty vector
//   return undef if start is not defined
//   return an empty vector ( [] ) if "start" is past the end
//   return undef if end is not defined
//
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
    instart <= end ?
        _slice_deep( array, instart, end )
    :
        _slice_deep( array, end, instart )
        ;

function _slice_deep( array, start, end ) =
    [for (i=[start:end]) array[i]]
	;