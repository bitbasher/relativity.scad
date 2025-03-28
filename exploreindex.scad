include <strings.scad>

//echo( _index_of_first( "oneword" ) );
null  = "";

one   = "oneword";
two   = "two words";
start = " start";
end   = "end ";
both  = " both ";
all   = " all all ";
test  = "this is a test";
multi = "   mul   ti   ";
mul3  = "mul  ti   ple  ";
abcd = " a b c d ";

fone   = _index_of_first( one );
ftwo   = _index_of_first( two );
fstart = _index_of_first( start );
fend   = _index_of_first( end );
fboth  = _index_of_first( both );
fall   = _index_of_first( all );
ftest  = _index_of_first( test );
fmulti = _index_of_first( multi );
fmul3  = _index_of_first( mul3 );
fabcd  = _index_of_first( abcd );
fmul2  = _index_of_first( multi, "  " );
/*
echo( fone  );
echo( ftwo  );
echo( fstart);
echo( fend  );
echo( fboth );
echo( fall  );
echo( ftest );
echo( fmulti);
echo( fmul2 );
 */
rone   = _index_of_recurse( one,   " ",fone,   0 );
rtwo   = _index_of_recurse( two,   " ",ftwo,   0 );
rstart = _index_of_recurse( start, " ",fstart, 0 );
rend   = _index_of_recurse( end,   " ",fend,   0 );
rboth  = _index_of_recurse( both,  " ",fboth,  0 );
rall   = _index_of_recurse( all,   " ",fall,   0 );
rtest  = _index_of_recurse( test,  " ",ftest,  0 );
rabcd  = _index_of_recurse( abcd,  " ", fabcd, 0 );
rmulti = _index_of_recurse( multi, " ", fmulti,0 );
rmul3  = _index_of_recurse( mul3, " ", fmul3,0 );
rmul2  = _index_of_recurse( multi, "  ", fmul2,0 );
/*
echo( rone   = rone   );
echo( rtwo   = rtwo   );
echo( rstart = rstart );
echo( rend   = rend   ); 
echo( rabcd  = rabcd  );
echo( rboth  = rboth  );
echo( rall   = rall   );
echo( rtest  = rtest  );
echo( rmulti = rmulti ); */
echo( rmul2  = rmul2  );
echo( rmul3  = rmul3  );

/*
echo( sone   = _new_split( one, rone )   );
echo( stwo   = _new_split( two, rtwo )   );
echo( sstart = _new_split( start, rstart ) );
echo( send   = _new_split( end,  rend) );
echo( sabcd  = _new_split( abcd, rabcd ) );
echo( sboth  = _new_split( both, rboth ) );
echo( sall   = _new_split( all,  rall ) ); */
echo( stest  = _new_split( test, rtest ) );
echo( smulti = _new_split( multi, rmulti ) );
echo( smul3 = _new_split( mul3, rmul3 ) );
//echo( smul2  = _new_split( multi, "  ", rmul2 ) );
 
function _new_split(string, delims, i=0) = 
    is_undef(delims) || is_not_list(delims) || len(delims) <= 0 ?
        string
    
    : let( delim = delims[i] )
      delim.x == 0 ?
        _this_split( string, delims, 0 )
    :
        _last_split( string, delims, 0 )
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

function _last_split( string, delims, i ) =
    let( delim = delims[i] )

    i > len( delims ) ?
        []
    : i == 0 ?
        concat(
            before( string, delim.x ),
            stringBlanks( delim.y-delim.x ),
            _last_split(string, delims, i+1)
            )
    : i == len(delims) ? 
        lastWord( string, delims[i-1] )

    : let( pdelim = delims[i-1])
      pdelim.y == delim.x ? 
        concat(
            stringBlanks( delim.y-delim.x ),
            _last_split( string, delims, i+1 )
            )
    : concat(
        str_between_indecies(string, delims[i-1].y, delims[i].x),
        stringBlanks( delim.y-delim.x ),
        _last_split(string, delims, i+1)
        )
    ;

function lastWord( string, delim ) =
    delim.y >= len(string) ? 
        []
    :
        after( string, delim.y-1 )
    ;

function stringBlanks( qty, i=1 ) =
    qty == 0 ?
        ""
    : i==qty ? " "
    : str( " ", stringBlanks( qty, i+1 ) ) ;

