/*
    Common elements for testing string functions in the
    relativity library made as an extension for OpenSCAD.

    @_TEST_ENABLED_ is not set in this include file to 
    prevent warnings being emitted if TE is set true in
    test files that include this file of common elements.

_TEST_ENABLED_ = false;

echo( "testing strings functions of relativity library" );
echo( "\tCommon Items for use in *.test files" );
 */

ts = "this is a test"; /// test string
tsLen  = len(ts);
tsLast = tsLen-1;


pts = str( " " , ts , " " ); /// padded test string
ptsLen = tsLen+2;

mts = "This IS a tESt"; /// test string with capitals
mtsLen  = len(mts);
mtsLast = mtsLen-1;

tsascii  = [116, 104, 105, 115,  32, 105, 115,
             32,  97,  32, 116, 101, 115, 116
           ];
ptsascii = [ 32, 116, 104, 105, 115,  32, 105,
            115,  32,  97,  32, 116, 101, 115,
            116,  32
           ];
mtsascii = [ 84, 104, 105, 115,  32,  73,  83,
             32, 97, 32, 116, 69, 83, 116
           ];

numbers = "some 123 numb 15.5 ers, a-23nd pun5556; tations99";

footest = "foo  (1, bar2)";
regex_test = "foooobazfoobarbaz";

foobar = "!@#$1234foobar!@#$1234";
FOOBAR = "!@#$1234FOOBAR!@#$1234";
SPCBAR = "!@#$1234 FOOBAR !@#$1234";
illegalCodes = "\u20AC 10 \u263A"; // UNICODE for the euro symbol, code 10, and a smilie;
