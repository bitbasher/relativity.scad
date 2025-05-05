function str_index( string, delim=" " ) =
	search( delim, string, 0 )[0];


echo( str_index( " ", delim="  " ) );
echo( str_index( "this  is a test", delim=" " ) );

// test bed for word_split
function word_split( str, del=" " ) = 
	let( d=str_index( str, del ) )
    len(d)<=0 ?
        (len(str) > 0 ? [str] : [] )
    : len(d) == 1 ? (
        d[0]==0 ?
            [chr([for(i=[d[0]+1:len(str)-1]) ord(str[i]) ] )]
        : ( d[0]==len(str)-1 ?
            [chr([for(i=[0:d[0]-1]) ord(str[i]) ] )]
            : [
            chr([for(i=[0:d[0]-1]) ord(str[i]) ] ),
            chr([for(i=[d[0]+1:len(str)-1]) ord(str[i]) ] )
            ]
          )
        )
    :[for(
        si=0, st= d[0]<=0 ? undef: 0, en=d[0]-1;
        si<=len(d);
			st= si<len(d)? d[si]+1 : undef,
			si=si+1,
			en= si<len(d) ? d[si]-1 : len(str)-1 
        )
		if( ! is_undef(st) && st <= en )
            //echo( n=si, st, en, d )
            chr([for(i=[st:en]) ord(str[i]) ] )
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