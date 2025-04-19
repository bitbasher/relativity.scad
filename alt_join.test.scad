ts = ["this","is","a","test"];
echo(alt_join( ts ));
echo(alt_join( ts,delimiter="--" ));
v=[3,4,5];
t=[23,[4,5],"str"];
echo( v = alt_join( v ) );
echo( t = alt_join( t ) );
echo( r = chr( [97],[98], [for(s=[99,100]) s] ));
echo( r = alt_join( [32,97,[98,99]], "," ));

function alt_join( strvec, delimiter="" ) =
    let( str=chr( [ for(w=strvec)[
        is_num(w) ? [for( s=str(w) ) ord(s)]
        : is_list(w) ? _alt_join(w, delimiter=delimiter)
        : is_string(w) ? [for( c=w )ord(c)]
        : ["x"]
        , [for(d=delimiter)ord(d)]
        ] ]
        ) )
    delimiter == "" ? str : before(str,len(str)-len(delimiter))
    ;

function _alt_join( strvec, delimiter="" ) =
    let( part=[ for(w=strvec) [
        is_num(w) ? [for( s=str(w) ) ord(s)]
        : is_list(w) ? _alt_join( w, delimiter=delimiter )
        : is_string(w) ? [for( c=w )ord(c)]
        : ["x"]
        , [for(d=delimiter)ord(d)]
        ]] )
    delimiter == "" ? part : before( part, len(part)-len(delimiter) 
    );

//echo( xx([3,4,5]) );
function xx(vec,i=undef) =
    is_undef(i) ?
        xx( vec, len(vec)-1 )
    : i==0 ?
        vec[0]
    : str( xx( vec, i-1), vec[i] )
    ;