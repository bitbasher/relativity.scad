_newSplit_version = 
	[2025, 03, 29, 1];
function newSplit_version() = _newSplit_version;
function numbes_version_num() =
	_newSplit_version.x * 10000 +
    _newSplit_version.y * 100 +
    _newSplit_version.z +
    _newSplit_version[4]/10;


//include <strings.scad>


function _new_split(string, delims, i=0) = 
    is_undef(delims) || is_not_list(delims) ?
        undef
    : delims == [] ?
        [string]
    : let( delim = delims[i] )
      delim.x == 0 ?
        _this_split( string, delims, 0 )
    :
        _last_split( string, delims, 0 )
    ;


function _last_split( string, delims, i ) =
    let( delim = delims[i] )

    i > len( delims ) ?
        []
    : i == 0 ?
        concat( // ["x"],i,delim.y,delim.x,
            before( string, delim.x ),// [delim.y,delim.x],
            [stringBlanks( delim.y-delim.x )],
            _last_split(string, delims, i+1)
            )
    : i == len(delims) ? 
        lastWord( string, delims[i-1] )

    : let( pdelim = delims[i-1])
      pdelim.y == delim.x ? 
        concat( // ["y"],i,delim.y,delim.x,
            stringBlanks( delim.y-delim.x ),
            _last_split( string, delims, i+1 )
            )
    : concat( //["z"],i,delim.y,delim.x,
        str_between_indecies(string, delims[i-1].y, delims[i].x),
        stringBlanks( delim.y-delim.x ),
        _last_split(string, delims, i+1)
        )
    ;
 
function _this_split( string, delims, i ) =
    let( ldelim = delims[i], ndelim = delims[i+1] )
    
    i >= len( delims ) ?
        []
    : ldelim.y == ndelim.x ?
        concat(
            [stringBlanks( ndelim.y-ndelim.x )],
            _this_split(string, delims, i+1)
            )
    : let( endWord = i+1>=len(delims) ? len(string) : delims[i+1].x )
      concat(
        [stringBlanks( ldelim.y-ldelim.x )],
        _coalesce_on( str_between_indecies(string, ldelim.y, endWord), undef, [] ),
        _this_split(string, delims, i+1) 
        )
    ;

function lastWord( string, delim ) =
    delim.y >= len(string) ? [] : after( string, delim.y-1 ) ;


function _split_only(string, delims, i=0) = 
    is_undef(delims) || is_not_list(delims) ?
        undef
    : delims == [] ?
        [string]
    : let( delim = delims[i] )
      delim.x == 0 ?
        _this_split_only( string, delims, 0 )
    :
        _last_split_only( string, delims, 0 )
    ;


function _last_split_only( string, delims, i ) =
    let( delim = delims[i] )

    i > len( delims ) ?
        []
    : i == 0 ?
        concat( // ["x"],i,delim.y,delim.x,
            before( string, delim.x ),// [delim.y,delim.x],
            _last_split_only(string, delims, i+1)
            )
    : i == len(delims) ? 
        lastWord( string, delims[i-1] )

    : let( pdelim = delims[i-1])
      pdelim.y == delim.x ?
            _last_split_only( string, delims, i+1 )

    : concat( //["z"],i,delim.y,delim.x,
        str_between_indecies(string, delims[i-1].y, delims[i].x),
        _last_split_only(string, delims, i+1)
        )
    ;
 
function _this_split_only( string, delims, i ) =
    let( ldelim = delims[i], ndelim = delims[i+1] )
    
    i >= len( delims ) ?
        []
    : ldelim.y == ndelim.x ?
        _this_split_only(string, delims, i+1)

    : let( endWord = i+1>=len(delims) ? len(string) : delims[i+1].x )
      concat(
        _coalesce_on( str_between_indecies(string, ldelim.y, endWord), undef, [] ),
        _this_split_only(string, delims, i+1) 
        )
    ;

