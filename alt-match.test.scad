include <strings.scad>

_TEST_ENABLED_ = false;

// echo( _strings_version, strings_version_str() );

ts = "this is a test"; // test string
wts = "this  is  a  test";
lents = len(ts);
pts = str( " " , ts , " " );
mts = "This IS a tESt"; // test string with capitals

//echo( chr( [for(c=[4:5]) ord(ts[c])] ) );

function mid( string, st, end) = 
    chr( [for(c=[st:end]) ord(string[c])] )
    ;
//echo( mid( ts, 0, seps[0]) );
//echo( mid( ts, seps[0]+1, seps[1]) );
//echo( mid( ts, seps[1]+1, seps[2]) );
//echo( mid( ts, seps[2]+1, len(ts)-1 ) );

function split( string ) =
    let( seps=search( " ",string,0 )[0] )
    [for( s=[0:len(seps)] )
      let( 
        st = s==0 ? 0: seps[s-1]+1,
        en = s==len(seps) ? len(string)-1 :seps[s]-1
        )
      mid( string, st, en)
      ]
    ;

echo( split( ts, seps ));

// return index of the character in the given string that is
//  any character of the given set, starting from the given position
function matchsetrev(string, set, pos) = 
	pos <= 0?
		0
	: _is_in_set(string[pos-1], set) ?
		_match_set_reverse(string, set, pos-1)
	: 
		pos
	;
