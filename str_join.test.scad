ts = ["this","is","a","test"];
echo(str_join( ts ));
echo(str_join( ts,delimiter="--" ));
echo(str_join( [3,4,5] ));

function str_join( strvec, delimiter="" ) =
	let( str=chr( 
    [ for(w=strvec) [ 
        [for( c=w ) is_num(c) ? str(c): ord(c) 
        ], 
        [for(d=delimiter) ord(d) ] ] ] ) 
    )
	delimiter == "" ? str : before( str, len(str)-len(delimiter) )
	;

echo( xx([3,4,5]) );
function xx(vec,i=undef) =
    is_undef(i) ?
        xx( vec, len(vec)-1 )
    : i==0 ?
        vec[0]
    : str( xx( vec, i-1), vec[i] )
    ;


function before(string, upto=0) = 
	upto > len(string)-1?
		string
	: upto < 1?
		""
	: _sub_by_index( string, 0, upto-1 ) ;

function _sub_by_index( string, start, end ) =
	str_join( [for ( i=[start:end]) string[i]] );
