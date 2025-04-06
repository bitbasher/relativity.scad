include <strings.scad>

null  = "";

one   = "oneword";
two   = "two words";
start = " start";
end   = "end ";
both  = " both ";
all   = " all all ";
test  = "this is a test";
multi = "  mul  ti  ";
mul3  = "mul   ti   ple   ";
abcd = " a b c d ";

fnull  = _index_of_first( null );
fone   = _index_of_first( one );
ftwo   = _index_of_first( two );
fstart = _index_of_first( start );
fend   = _index_of_first( end );
fboth  = _index_of_first( both );
fall   = _index_of_first( all );
ftest  = _index_of_first( test );
fabcd  = _index_of_first( abcd );
fmulti = _index_of_first( multi );
fmul2  = _index_of_first( multi, "  " );
fmul3  = _index_of_first( mul3 );
fmul33 = _index_of_first( mul3, "   " );

echo( fnull );
echo( fone  );
echo( ftwo  );
echo( fstart);
echo( fend  );
echo( fboth );
echo( fall  );
echo( ftest );
echo( fmulti);
echo( fmul2 );
echo( fmul3 );
echo( fmul33 );

rnull  = _index_of_recurse( null,  " ",fnull,  0 );
rone   = _index_of_recurse( one,   " ",fone,   0 );
rtwo   = _index_of_recurse( two,   " ",ftwo,   0 );
rstart = _index_of_recurse( start, " ",fstart, 0 );
rend   = _index_of_recurse( end,   " ",fend,   0 );
rboth  = _index_of_recurse( both,  " ",fboth,  0 );
rall   = _index_of_recurse( all,   " ",fall,   0 );
rtest  = _index_of_recurse( test,  " ",ftest,  0 );
rabcd  = _index_of_recurse( abcd,  " ", fabcd, 0 );
rmulti = _index_of_recurse( multi, " ", fmulti,0 );
rmul2  = _index_of_recurse( multi, "  ", fmul2,0 );
rmul3  = _index_of_recurse( mul3,  " ", fmul3, 0 );
rmul33 = _index_of_recurse( mul3,  "   ", fmul33, 0 );

echo( rnull == rnull  );
echo( rone   = rone   );
echo( rtwo   = rtwo   );
echo( rstart = rstart );
echo( rend   = rend   ); 
echo( rabcd  = rabcd  );
echo( rboth  = rboth  );
echo( rall   = rall   );
echo( rtest  = rtest  );
echo( rmulti = rmulti );
echo( rmul2  = rmul2  );
echo( rmul3  = rmul3  );
echo( rmul33  = rmul33  );

echo( sone   = _new_split( one, rone )   );
echo( stwo   = _new_split( two, rtwo )   );
echo( sstart = _new_split( start, rstart ) );
echo( send   = _new_split( end,  rend) );
echo( sabcd  = _new_split( abcd, rabcd ) );
echo( sboth  = _new_split( both, rboth ) );
echo( sall   = _new_split( all,  rall ) ); 
echo( stest  = _new_split( test, rtest ) );
echo( smulti = _new_split( multi, rmulti ) );
echo( smul2  = _new_split( multi, rmul2 ) );
echo( smul3  = _new_split( mul3, rmul3 ) );
echo( smul33 = _new_split( mul3, rmul33 ) );

