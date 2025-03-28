include <strings.scad>

footest = "foo  (1, bar2)";
regex_test = "foooobazfoobarbaz";

ts  = "this is a test"; // test string
ts2 = "this  is  a  test"; // test string with wider delimiters
pt  = "   paddedtext   ";
ptt = "   pad ded text   ";
pttt= "    pad ded text    ";

nullString = "";

lastTS = len(ts)-1;
lenTS = len(ts);


function _match(string, pattern, pos ) = 
    starts_with(string, pattern, pos ) ? 
        pos+len(pattern) 
    : 
        undef
    ;
    

echo( ts=ts );
echo( "testing _match" );
echo( m=_match( ts, "", 0 ) );          // 0 - starts with ""
echo( m=_match( ts, " ", 0 ) );         // undef
echo( m=_match( "    ", " ", 0 ) );     // 1 - starts with " "
echo( m=_match( ts, " ", 4 ) );         // 5 - blank after "this"
echo( m=_match( ts2, "  ", 4 ) );       // 6 - "  " after "this"
echo( m=_match( ts2, "this  ", 0 ) );   // 6  - starts with "this  "
echo( m=_match( "testing", "t", 20 ) ); // undef - pos past end of string

echo( "testing _match_set" );
echo( ms=_match_set( ts, "", 0 ) );     // 0 - starts with ""
echo( ms=_match_set( ts, "x", 0 ) );    // 0 - does not begin with " "
echo( ms=_match_set( "    ", " ", 0 ) ); // 1 - starts with " "
echo( ms=_match_set( ts, "  ", 4 ) );   // 5 - " " after "test"
echo( ms=_match_set( ts2, "  ", 4 ) );  // 6 - "  " after "test"
echo( ms=_match_set( ts2, "this  ", 0 ) ); // 6  - starts with "this  "
echo( ms=_match_set( "testing", "test", 0 ) ); // 4 - starts with "test"


echo( ts=ts );
echo( ts2=ts2 );
echo( index1 = _index_of_first( ts, " " ) );
echo( index1 = _index_of_first( ts2, " " ) );
echo( index1 = _index_of_first( ts, "  " ) );
echo( index1 = _index_of_first( ts2, "  " ) );
echo( pt = pt);
echo( index1 = _index_of_first( pt, " ") );
echo( ptt=ptt );
echo( ptt = _index_of_first( ptt, " ") ); // [0,3]
echo( ptt = _index_of_first( ptt, "  ") ); // [0,3]
echo( pttt = _index_of_first( pttt, "  ") ); // [0,4]

echo( indexr = _index_of_recurse( ts, " ", _index_of_first(ts, " " ), pos=0 ) );
echo( ts2 = ts2 );
echo( indexr2 = _index_of_recurse( ts2, " ", _index_of_first(ts2, " " ), pos=0 ) );
echo( indexr = _index_of_recurse( ts, "  ", _index_of_first(ts, "  " ), pos=0 ) );
echo( indexr2 = _index_of_recurse( ts2, "  ", _index_of_first(ts2, "  " ), pos=0 ) );

echo( ind = _index_of( ts, " ") );
echo( ind2 = _index_of( ts2, " ") );
echo( indd = _index_of( ts, "  ") );
echo( ind2d = _index_of( ts2, "  ") );
echo( pt = pt);
echo( ptt = ptt);
echo( pttt = pttt);
echo( pind2 = _index_of( pt, " ") );
echo( pindd = _index_of( ptt, " ") );
echo( pindd = _index_of( pttt, " ") );
echo( pindd = _index_of( ptt, "  ") );
echo( pindd = _index_of( pttt, "  ") );


echo( ss  = _strSplit( ts, [] ) );
echo( ss  = _strSplit( ts, _index_of( ts, " " )  ) );
echo( ss2 = _strSplit( ts2, [] ) );
echo( ss2 = _strSplit( ts2, _index_of( ts2, "  " )  ) );

echo( ssplit = strSplit( ts, separator=" " ) );
echo( ssplit = strSplit( ts2, separator="  " ) );
echo( ssplit = strSplit( pt, separator=" " ) );
echo( ssplit = strSplit( ptt, separator=" " ) );
echo( ssplit = strSplit( pttt, separator=" " ) );
echo( ssplit = strSplit( pttt, separator="  " ) );

echo( siv  = strIndexVector( ts, " " ) );
echo( siv2 = strIndexVector( ts2, " " ) );
echo( siv  = strIndexVector( ts, "  " ) );
echo( siv2 = strIndexVector( ts2, "  " ) );
echo( pt = pt);
echo( siv2 = strIndexVector( pt, " " ) );
echo( ptt = ptt);
echo( siv  = strIndexVector( ptt, "  " ) );
echo( pttt = pttt);
echo( siv  = strIndexVector( pttt, "  " ) );

echo( "testing done" );