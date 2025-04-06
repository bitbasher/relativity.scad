include <numbers.scad>

end = 1;
echo( abs(end) );
echo( abs(end-1) ); // zero 
echo( abs(end-2) ); // -1


tv8last = 7;
tv8 = [ for( i=[0:tv8last] ) i ]; // fill a test array
echo( tv8 );
tv8len = len(tv8);
tv8start = 0;

echo( tv8last, tv8len );

echo( testAbs(-4) );
echo( testAbs(0) );
echo( testAbs(4) );

function lastindex( lenArray, end ) =
    let( absend = end < 0 ? -end : end )
	end < 0 ?
        absend >= lenArray ?
            0
        : lenArray + end -1
    : end >= lenArray ? 
        lenArray-1 
    : end
    ;

echo( lastindex( tv8len, -50 ) );
echo( lastindex( tv8len, -tv8last-1 ) );
echo( lastindex( tv8len, -tv8last ) );
echo( lastindex( tv8len, -5 ) );
echo( lastindex( tv8len, -1 ) );
echo( lastindex( tv8len, 0 ) );
echo( lastindex( tv8len, 5 ) );
echo( lastindex( tv8len, tv8last+1 ) );
echo( lastindex( tv8len, 50 ) );


function liminmax( lenArray, end ) =
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


echo( liminmax( tv8len, -50 ) );
echo( liminmax( tv8len, -tv8last-1 ) );
echo( liminmax( tv8len, -tv8last ) );
echo( liminmax( tv8len, -5 ) );
echo( liminmax( tv8len, -1 ) );
echo( liminmax( tv8len, 0 ) );
echo( liminmax( tv8len, 5 ) );
echo( liminmax( tv8len, tv8last+1 ) );
echo( liminmax( tv8len, 50 ) );
