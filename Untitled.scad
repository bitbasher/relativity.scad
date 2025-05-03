function str_index( string, delim=" " ) =
	search( delim, string, 0 )[0]
	;

seps = str_index( "oneword" );
echo( seps=seps, seps[0], len(seps), len("oneword") );

function x( str, seps) = 
    [for( si=[0:len(seps)] )
		echo( si=si )
    	is_undef(seps[si]) ? 
			len(str)!=0 ? str : []
		: [for(ci=[0:seps[si]-1] ) each str[ci] ]
	];
    
echo( x=x( "oneword", seps ));

echo( y=[for( si=[1:len(seps)] ) si] );