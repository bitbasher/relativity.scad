// testing PEG functions (that used to be in strings.scad)

footest = "foo  (1, bar2)";
regex_test = "foooobazfoobarbaz";




echo(  "testing contains:" );
assert( contains("foo bar baz", "ba[rz]", regex=true) == true );
assert( contains("foo bar baz", "spam",   regex=true) == false );
assert( contains("foo bar baz", "BA[RZ]", ignore_case=true, regex=true ) == true );
assert( contains("foo bar baz", "SPAM", ignore_case=true , regex=true) == false );

echo( "testing index_of:" );
//echo( index_of( ts, "t") );
assert( index_of( ts, "t") ==  [[0, 1], [10, 11], [13, 14]] );
assert( index_of("foobar foobar", "oo") == [[1,3], [8,10]] );
assert( index_of( mts, "fooBAR") == [] );
//echo( index_of( mts, "test", ignore_case=true) );
assert( index_of( mts, "test", ignore_case=true) == [[10,14]] );
assert( index_of("foo bar baz", "ba[rz]", regex=true) == [[4,7], [8,11]] );
assert( index_of("foo bar baz", "BA[RZ]", regex=true, ignore_case=true) == [[4,7], [8,11]] );
assert( index_of("", "x") == [] );


echo( "testing grep:" );
assert( grep("foo bar baz", "ba[rz]") == ["bar", "baz"] );
assert( grep("foo bar baz", "BA[RZ]") == [] );
assert( grep("foo 867-5309 baz", "\\d\\d\\d-?\\d\\d\\d\\d") == ["867-5309"] );
assert( grep("foo bar baz", "BA[RZ]", ignore_case=true) == ["bar", "baz"] );


echo( "testing replace:" );
assert( replace( "foobar", "oo", "ee") == "feebar" );
assert( replace( "foobar foobar", "oo", "ee") == "feebar feebar" );
assert( replace( "foobar", "OO", "ee", ignore_case=true) == "feebar" );
assert( replace( "foobar foobar", "OO", "ee", ignore_case=true) == "feebar feebar" );
assert( replace( "foo bar baz", "ba[rz]", "boo", regex=true) == "foo boo boo" );
assert( replace( "foo bar baz", "BA[RZ]", "spam", regex=true, ignore_case=true) == "foo spam spam" );

echo( "testing split:" );

//echo( split( "" ) );
assert( split("") == [] );

//echo( "index ", index_of( ts, " ", true ) );
//echo( "index ", index_of( ts, " ", false ) );


//echo( "split ts ", split(ts, " ") );
assert( split(ts, " ") );

cts = ",a string, with, commas,";
//echo( str( "with commas ", cts ) );
//echo( split(cts) );
assert( split(cts) == split(cts, " " ) );
assert( split(cts) == [ ",a", "string,", "with,", "commas," ]);
//echo( split(cts, "," ) );
assert( split(cts, ",") == [ "a string", " with", " commas" ] );

//assert( split(regex_test, "fo+", regex=true) );
//assert( split("bazfoobar", "fo+", regex=true) );
//assert( split("", "fo+", regex=true)  );
//assert( split("", "fo+", regex=true)  );
//assert( split(regex_test, "FO+", regex=true, ignore_case=true) == ["baz", "barbaz"] );

echo ( "all done" );
