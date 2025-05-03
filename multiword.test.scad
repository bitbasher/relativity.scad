include <numbers.scad>
include <logic.scad>

function _sub_by_index( string, start, end ) =
	chr( [for(c=[start:end]) ord(string[c])] )
	;
function str_index( string, delim=" " ) =
	search( delim, string, 0 )[0];

function multi_index( string, delim=" " ) =
	let( seps=search( delim, string, 0 ) )
    quicksort( [for( d=seps ) for( c=d ) c ] )
    ;

//echo( str_index( " ", delim="  " ) );
//echo( str_index( "this  is a test", delim=" " ) );
echo( multi_index( "+3var2", "=+" ) );
echo( multi_index( "var1var2+", "=+" ) );
echo( multi_index( "var1=var22", "=+" ) );
echo( multi_index( "+3var2+", "=+" ) );
echo( multi_index( "var1+3=var2+2", "=+" ) );

echo( mws=multiword_split( "", "=+" ) );
echo( mws=multiword_split( "3var2", "=+" ) );
echo( mws=multiword_split( "+3var2", "=+" ) );
echo( mws=multiword_split( "var1var2+", "=+" ) );
echo( mws=multiword_split( "var1=var22", "=+" ) );
echo( mws=multiword_split( "+3var2+", "=+" ) );
echo( mws=multiword_split( "var1+3=var2+2", "=+" ) );


// test bed for word_split
function multiword_split( str, del=" " ) = 
	let( d=multi_index( str, del ), lenS=len(str), lastS=lenS-1 )
    len(d)<=0 ?
        (lenS > 0 ? [str] : [] )
    : len(d) == 1 ? (
        d[0]==0 ?
            [ _sub_by_index( str,d[0]+1,lastS ) ]
        : ( d[0]==lastS ?
            [ _sub_by_index( str,0,d[0]-1 ) ]
            : [
            _sub_by_index( str,0,d[0]-1 ),
            _sub_by_index( str,d[0]+1,lastS )
            ]
          )
        )
    :[for(
        si=0, st= d[0]<=0 ? undef: 0, en=d[0]-1;
        si<=len(d);
			st= si<len(d)? d[si]+1 : undef,
			si=si+1,
			en= si<len(d) ? d[si]-1 : lastS 
        )
		if( ! is_undef(st) && st <= en )
            echo( n=si, st, en, d )
            _sub_by_index( str,st,en )
	];



/*
echo( null=word_split( ""));
echo( one =word_split( "oneword" ));
echo( one =word_split( " start" ));
echo( one =word_split( "end "));
echo( two =word_split( "two words"));
echo( bot =word_split( " both "));
echo( ths =word_split( "this is a test" ));
echo( tht =word_split( "this is a test", "t" ));
echo( thz =word_split( "this is a test", "z" ));
echo( yet =word_split( " yet another test" ));
echo( abc =word_split( " a b C D " ));
echo( yet =word_split( "  multiple  blanks  " ));
*/