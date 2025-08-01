include <strings.scad>
include <strings.test-common.scad>

echo( "testing strings functions of relativity library" );
echo( "\tPart 1" );
echo( _strings_version );
echo( strings_version = _strings_version_str() );


_TEST_ENABLED_ = false;

echo( "\ttesting _is_in_set" );
if( _TEST_ENABLED_ ) {
echo( f=_is_in_set( "",  _STRING_LOWER ) );  // f
echo( t=_is_in_set( "a", _STRING_LOWER ) );
echo( f=_is_in_set( "a", _STRING_UPPER ) );  // f

echo( f=_is_in_set( "A", _STRING_LOWER ) );  // f
echo( t=_is_in_set( "A", _STRING_UPPER ) );

echo( f=_is_in_set( 9, _STRING_LOWER )   );  // f
echo( f=_is_in_set( [9], _STRING_LOWER ) );  // f
echo( b=search( [9],   [8,9,42])         );  // [[]] 
echo( b=search( [9],  _STRING_LOWER )    );  // [[]] 
echo( t=_is_in_set( [9], [8,9,42] )      );  // t
echo( f=_is_in_set( [],  [8,9,42] )      );  // f
echo( t=_is_in_set(  9,  [8,9,42] )      );  // t

echo( t=_is_in_set( "ab", _STRING_LOWER ) ); // t
echo( f=_is_in_set( "AB", _STRING_LOWER ) ); // f
echo( t=_is_in_set( "aB", _STRING_LOWER ) ); // t
echo( t=_is_in_set( [7,8], [7,8,9,42]   ) ); // t
echo( f=_is_in_set( [7,8], [42,43,44]   ) ); // f
echo( t=search( [7,8], [7,8,9,42] ) ); // [0,1] 7 at 0th, 8 at 1st
echo( f=search( [7,8], [42,43,44] ) ); // [[],[]] 
echo( f=search( [3],   [8,9,42]) );    // [[]] 
echo( f=search(  3,    [8,9,42]) );    // [] so --> f, correct
echo( f=_is_in_set( 3, [8,9,42] ) );   // f
}

assert( ! _is_in_set( "",  _STRING_LOWER ) );  // f
assert(   _is_in_set( "a", _STRING_LOWER ) );

assert( ! _is_in_set( "A", _STRING_LOWER ) );  // f
assert(   _is_in_set( "A", _STRING_UPPER ) );

assert( ! _is_in_set(  9,  _STRING_LOWER ) );  // f
assert(   _is_in_set( [9], _STRING_LOWER ) );  // t should be f
assert(   _is_in_set( 9, [8,9,42] ) );         // t

assert(   _is_in_set( "ab", _STRING_LOWER ) ); // t
assert( ! _is_in_set( "AB", _STRING_LOWER ) ); // f
assert(   _is_in_set( "aB", _STRING_LOWER ) ); // t
assert(   _is_in_set( [7,8], [7,8,9,42]   ) ); // t
assert(   _is_in_set( [7,8], [42,43,44]   ) ); // t should be f
assert( search( [7,8], [7,8,9,42] ) == [0,1] );// 7 at 0th, 8 at 1st
assert( search( [7,8], [42,43,44] ) == [[],[]] ); // false positive
assert( search( [3],   [8,9,42]   ) == [[]] );    // false positive
assert( search(  3,    [8,9,42]   ) == [] );   // so --> f, correct
assert( ! _is_in_set( 3, [8,9,42] ) );   // f


echo( "\ttesting is_in_set" );
if( _TEST_ENABLED_ ) {
echo( f=is_in_set( "",  _STRING_LOWER ) );  // f
echo( t=is_in_set( "a", _STRING_LOWER ) );
echo( f=is_in_set( "a", _STRING_UPPER ) );  // f

echo( f=is_in_set( "A", _STRING_LOWER ) );  // f
echo( t=is_in_set( "A", _STRING_UPPER ) );

echo( f=is_in_set( 9, _STRING_LOWER )   );  // f
echo( b=search( [9],   [8,9,42])         );  // [[]] 
echo( b=search( [9],  _STRING_LOWER )    );  // [[]]
echo( f=is_in_set( [9], _STRING_LOWER ) );  // f
echo( t=is_in_set( [9], [8,9,42] )      );  // t
echo( f=is_in_set( [],  [8,9,42] )      );  // f
echo( t=is_in_set(  9,  [8,9,42] )      );  // t

echo( t=is_in_set( "ab", _STRING_LOWER ) ); // t
echo( f=is_in_set( "AB", _STRING_LOWER ) ); // f
echo( t=is_in_set( "aB", _STRING_LOWER ) ); // t
echo( t=is_in_set( [7,8], [7,8,9,42]   ) ); // t
echo( f=is_in_set( [7,8], [42,43,44]   ) ); // f
echo( c=search( [7,8], [7,8,9,42] ) ); // [0,1] 7 at 0th, 8 at 1st
echo( c=search( [8,7], [7,8,9,42] ) ); // [1,0] 8 at 1st, 7 at 0th
    // order of match vector is preserved in the result
echo( c=search( [7,8], [42,43,44] ) ); // [[],[]] 
echo( c=search( [3],   [8,9,42]) );    // [[]] 
echo( f=is_in_set( [3], [8,9,42] ) );   // f
echo( c=search( 3, [8,9,42]) );    // [] so --> f, correct
echo( f=is_in_set( 3, [8,9,42] ) );   // f
}

assert( ! is_in_set( "",  _STRING_LOWER ) );  // f
assert(   is_in_set( "a", _STRING_LOWER ) );

assert( ! is_in_set( "A", _STRING_LOWER ) );  // f
assert(   is_in_set( "A", _STRING_UPPER ) );

assert( ! is_in_set(  9,  _STRING_LOWER ) );  // f
assert( ! is_in_set( [9], _STRING_LOWER ) );  // f
assert(   is_in_set( 9, [8,9,42] ) );         // t

assert(   is_in_set( "ab", _STRING_LOWER ) ); // t
assert( ! is_in_set( "AB", _STRING_LOWER ) ); // f
assert(   is_in_set( "aB", _STRING_LOWER ) ); // t
assert(   is_in_set( [7,8], [7,8,9,42]   ) ); // t
assert( ! is_in_set( [7,8], [42,43,44]   ) ); // f
assert( search( [7,8], [7,8,9,42] ) == [0,1] );// 7 at 0th, 8 at 1st
assert( search( [7,8], [42,43,44] ) == [[],[]] ); // false correct
assert( search( [3],   [8,9,42]   ) == [[]] );    // false correct
assert( ! is_in_set( [3], [8,9,42]   ) );
assert( search(  3,    [8,9,42]   ) == [] );   // false correct
assert( ! is_in_set( 3, [8,9,42] ) );   // f


echo( "\ttesting char_in_set" );
if( _TEST_ENABLED_ ) {
echo( char_in_set( "",  _STRING_LOWER ) );  // f
echo( char_in_set( "a", _STRING_LOWER ) );  // t
echo( char_in_set( "a", _STRING_UPPER ) );  // f
echo( char_in_set( "ab", _STRING_LOWER ) ); // t

echo( char_in_set( "A", _STRING_LOWER ) );  // f
echo( char_in_set( "A", _STRING_UPPER ) );  // t
echo( char_in_set( "A", _STRING_LOWER, ignore_case=true ) ); //t

echo( char_in_set( 9, _STRING_LOWER ) );     // f
echo( char_in_set( [9], _STRING_LOWER ) );   // f, need same types
echo( char_in_set( 9, [8,9,42] ) );          // f
}

assert( ! char_in_set( "",  _STRING_UPPER ) );  // f
assert(   char_in_set( "a", _STRING_LOWER ) );  // t
//echo( chr=char_to_lower("a"));
//echo( chr=char_to_lower("A"));
//echo( chr=    lower(_STRING_UPPER));
//echo( chr=str_lower(_STRING_UPPER));
assert( ! char_in_set( "a",  _STRING_UPPER ) );
assert(   char_in_set( "a",  _STRING_UPPER, ignore_case=true ) );

assert( ! char_in_set( "A", _STRING_LOWER ) );  // f
assert(   char_in_set( "A", _STRING_UPPER ) );  // t
assert(   char_in_set( "A", _STRING_LOWER, ignore_case=true ) ); //t

assert( ! char_in_set( 9, _STRING_LOWER ) );     // f
assert( ! char_in_set( [9], _STRING_LOWER ) );   // f cant be list
assert( ! char_in_set( 9, [8,9,42] ) );          // f, inputs are not strings

assert( ! char_in_set( "ab", _STRING_LOWER ) ); // multiple chars blocked
assert( ! char_in_set( "AB", _STRING_LOWER, ignore_case=true ) ); // ditto
assert( ! char_in_set( [7,8], [7,8,9,42]   ) ); // still no lists
assert( ! char_in_set( 3, [8,9,42] ) );   // f


echo( "\ttesting char_in_set even more" );
assert(   char_in_set("t",  ts) );
assert( ! char_in_set("T",  ts) );
assert(   char_in_set("T",  mts) );
assert( ! char_in_set("x",  ts) );
assert( ! char_in_set( 12,  ts) );
assert( ! char_in_set( ts, "T" ) ); // false
assert(   char_in_set("T",  ts, true ) );
assert( ! char_in_set("x",  ts, true) );
assert( ! char_in_set( 12,  ts, true) );
assert( ! char_in_set( ts, "T", true ) ); // first param, char, must be a single character


echo( "\ttesting str_to_ascii" );

if( _TEST_ENABLED_ ) {
echo( legal = ts );
echo( legal = str_to_ascii(ts) );
echo( padded = pts );
echo( padded = str_to_ascii(pts) );
echo( mixed = mts );
echo( mixed = str_to_ascii(mts) );
echo( illegal = illegalCodes );
echo( illegal = str_to_ascii(illegalCodes) );
}
tsv =  [116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116];
ptsv = [32, 116, 104, 105, 115, 32, 105, 115, 32, 97, 32, 116, 101, 115, 116, 32];
mtsv = [84, 104, 105, 115, 32, 73, 83, 32, 97, 32, 116, 69, 83, 116];

// legalCodes
assert( str_to_ascii( ts  )   == tsv );
assert( str_to_ascii( pts )   == ptsv );
assert( str_to_ascii( mts )   == mtsv );
//echo( str_to_ascii( illegalCodes ) );
assert( str_to_ascii( illegalCodes ) == [0, 32, 49, 48, 32, 0] );

assert( len( str_to_ascii( undef ) ) == 0 );

//echo( str_to_ascii( _ASCII_VISIBLE ) );
//echo( str_to_ascii( _ASCII_ALL ) );


echo( "testing boolean functions" );
/* we will not test is_ascii() as it only calls _is_in_set()
   which is very well tested indeed
 */

echo( "\ttesting _is_variable_safe" );

assert(   _is_variable_safe( "a" ) );
assert( ! _is_variable_safe( 42 ) );
assert(   _is_variable_safe( "_" ) );
assert( ! _is_variable_safe( " " ) );

echo( "\ttesting _is_variable_name" );
if( _TEST_ENABLED_ ) {
echo( ivn= _is_variable_name( "a", 0 ) );
echo( ivn= _is_variable_name( "abcd", 3 ) );
echo( ivn= _is_variable_name( "abc!", 3 ) );
echo( ivn= _is_variable_name( "alegalname", len("alegalname")-1 ) );
echo( ivn= _is_variable_name( "notlegal@name", len("notlegal@name")-1  ) );
}

assert(   _is_variable_name( "a", 0 ) );
assert(   _is_variable_name( "abcd", 3 ) );
assert( ! _is_variable_name( "abc!", 3 ) );
assert(   _is_variable_name( "alegalname",    len("alegalname")-1     ) );
assert( ! _is_variable_name( "notlegal@name", len("notlegal@name")-1  ) );

if( _TEST_ENABLED_ ) {
echo( ivn= is_variable_name( 42 ) );
echo( ivn= is_variable_name( "a" ) );
echo( ivn= is_variable_name( "abcd" ) );
echo( ivn= is_variable_name( "abc!" ) );
echo( ivn= is_variable_name( "alegalname" ) );
echo( ivn= is_variable_name( "notlegal@name" ) );
}
assert( is_undef( is_variable_name( 42 ) ) );
assert(   is_variable_name( "a" ) );
assert(   is_variable_name( "abcd" ) );
assert( ! is_variable_name( "abc!" ) );
assert(   is_variable_name( "alegalname" ) );
assert( ! is_variable_name( "notlegal@name" ) );


echo( "\tstr_is_null_or_allspaces" );
assert(   str_is_null_or_allspaces( "  " ) );
assert( ! str_is_null_or_allspaces( " xyz " ) );
assert(   str_is_null_or_allspaces( "" ) );
assert( ! str_is_null_or_allspaces( "xyz" ) );
assert( ! str_is_null_or_allspaces( [] ) ); // non strings as input give "false"

echo( "\tstr_is_allspaces" );
assert( ! str_is_allspaces( "" ) );
assert( str_is_allspaces( "  " ) );
assert( ! str_is_allspaces( "abcd" ) );
assert( ! str_is_allspaces( " a b c d " ) );
assert( is_undef( str_is_allspaces( [] ) ) );
assert( is_undef( str_is_allspaces( ["  "] ) ) );


echo( "testing _str_vector_join( arrayOfStrings, index, delimeter)" );
// this is the internal function that does NOT check all input
//  test to see if the last char to be processed is returned
//  that is the 0-th element of the given vector
assert( _str_vector_join( ["a","b","c"] ) ==  "abc" );

if( _TEST_ENABLED_ ) {
echo( svj1=_str_vector_join( ["a","b","c"], 2, "-" ) );
echo( svj2=_str_vector_join( ["a","b","c"], delimiter="-" ) );
echo( svj3=_str_vector_join( [3,4,5] ) );
echo( svj4=_str_vector_join( [34,45,56] ) );
echo( svj5=_str_vector_join( [34,45,56], 0,"-" ) );

// try joining from the 1-st to the 0-th
echo( _str_vector_join( [34,45,56], 1 ) );
echo( _str_vector_join( [34,45,56], 1,"-" ) );

// starting from last char 
echo( _str_vector_join( ["a","b","c"], 4 ) );
echo( _str_vector_join( ["a","b","c"], 2 ) );
echo( _str_vector_join( ["a","b","c"], 2, "-" ) );
echo( _str_vector_join( [3,4,5], 2 ) );
echo( _str_vector_join( [34,45,56], 2 ) );
echo( _str_vector_join( [34,45,56], 2,"-" ) );

echo( _str_vector_join( ["this","is","a","test"] ) );
echo( _str_vector_join( ["this","is","a","test"], delimiter=" " ) );
}


assert( _str_vector_join( ["a","b","c"], 2, "-" ) ==  "a-b-c" );
assert( _str_vector_join( ["a","b","c"], delimiter="-" ) ==  "a-b-c" );
assert( _str_vector_join( [3,4,5] ) ==  "345" );
assert( _str_vector_join( [34,45,56] ) ==  "344556" );
assert( _str_vector_join( [34,45,56], 0,"-" ) ==  "34" );

// try joining from the 1-st to the 0-th
assert( _str_vector_join( [34,45,56], 1 ) ==  "3445" );
assert( _str_vector_join( [34,45,56], 1,"-" ) ==  "34-45" );

// starting from last char 
assert( _str_vector_join( ["a","b","c"], 2 ) ==  "abc" );
assert( _str_vector_join( ["a","b","c"], 2, "-" ) ==  "a-b-c" );
assert( _str_vector_join( [3,4,5], 2 ) ==  "345" );
assert( _str_vector_join( [34,45,56], 2 ) ==  "344556" );
assert( _str_vector_join( [34,45,56], 2,"-" ) ==  "34-45-56" );

assert( _str_vector_join( ["this","is","a","test"] ) == "thisisatest" );
assert( _str_vector_join( ["this","is","a","test"], delimiter=" " ) == ts );


echo( "testing str_vector_join()" );
// this is the external function that DOES check all input
assert( str_vector_join( ["a","b","c"] ) == "abc" );
assert( str_vector_join( [] )  == "" );
assert( str_vector_join( [3,4,5] )  == "345" );
assert( str_vector_join( [34,45,56] ) == "344556" );
assert( str_vector_join( ["a","b","c"], "-" ) == "a-b-c" );
assert( str_vector_join( [], "-" ) == "" );
assert( str_vector_join( [3,4,5], "-" ) == "3-4-5" );
assert( str_vector_join( [34,45,56], "-" ) == "34-45-56" );

assert( str_vector_join(["foo", "bar", "baz"], ", ") == "foo, bar, baz" );
assert( str_vector_join(["foo", "bar", "baz"], "") == "foobarbaz" );
assert( str_vector_join(["foo"], ",") == "foo" );
assert( str_vector_join([], "") == "" );
assert( str_vector_join([], " ") == "" );
assert( str_vector_join([], ",") == "" );

echo( "\n\ttesting str_join()" );
assert( str_join( ["a","b","c"] ) == "abc" );
assert( str_join( [] )  == "" );
//assert( str_join( [3,4,5] )  == "345" );
//assert( str_join( [34,45,56] ) == "344556" );
//echo( str_join( ["a","b","c"], delimiter="-" ) );
assert( str_join( ["a","b","c"], "-" ) == "a-b-c" );
//assert( str_join( [], "-" ) == "" );
//assert( str_join( [3,4,5], "-" ) == "3-4-5" );
//assert( str_join( [34,45,56], "-" ) == "34-45-56" );

//echo( str_join( ["foo", "bar", "baz"] ) );
assert( str_join(["foo", "bar", "baz"], ", ") == "foo, bar, baz" );
assert( str_join(["foo", "bar", "baz"], "") == "foobarbaz" );
assert( str_join(["foo"], ",") == "foo" );
//assert( str_join([], "") == "" );
//assert( str_join([], " ") == "" );
//assert( str_join([], ",") == "" );
assert( str_join( ["this","is","a","test"] ) == "thisisatest" );
assert( str_join( ["this","is","a","test"], delimiter=" " ) == ts );

echo( "\n\ttesting alt_join()" );
if( _TEST_ENABLED_ ) { // TODO _TEST_ENABLED_ 
echo( alt_join( ["a","b","c"] ));
echo( alt_join( [] ));
echo( alt_join( [3,4,5] ));
echo( alt_join( [34,45,56] ));
echo( alt_join( ["a","b","c"], delimiter="-" ) );
echo( alt_join( ["a","b","c"], "-" ));
echo( alt_join( [], "-" ));
echo( alt_join( [3,4,5], "-" ));
echo( alt_join( [34,45,56], "-" ));

echo( alt_join( ["foo", "bar", "baz"] ) );
echo( alt_join( ["foo", "bar", "baz"], ", "));
echo( alt_join( ["foo", "bar", "baz"], " "));
echo( alt_join( ["foo"], ","));
echo( alt_join( [], ""));
echo( alt_join( [], " "));
echo( alt_join( [], ","));

echo( "\ttesting alt_join( len(delim)>1 )" );
tsvec = ["this","is","a","test"];
echo(alt_join( tsvec ));
echo(alt_join( tsvec, delimiter="--" ));

echo( "\ttesting alt_join( nested vectors )" );
/// BUG
/// to verify that passing a string as a variable
/// works the same as giving it directly as a
/// parameter. There was a development interation
/// where this was not true - revealed a subtlty
/// of the language that i no longer recall.
t=[23,[4,5],"str"];
echo( nestlist=alt_join( t ) );
echo( nestlist=alt_join( [23,[4,5],"str"] ) );

echo( nestlist=alt_join( ["a","b",["c","d"],"e"] ) );
echo( delBlnk =alt_join( ["a","b",["c","d"],"e"], " " ) );
echo( nestlist=alt_join( [98,99,["c","d"],42] ) );
echo( nestlist=alt_join( [98,[42,43],"xxx"] ) );
echo("problem");
echo( joinprob=alt_join( ["a",["c","d"],"e"] ) );
echo( joinprob=alt_join( ["a",["c","d"],67] ) );
echo( joinprob=alt_join( ["a",["c","d"],["test"]] ) );
echo( joinprob=alt_join( ["a",["c",[34,"e"],"d"],"e"] ) );
echo( joinprob=alt_join( ["a",["c","d"],67,[45,"test"],"<<"] ) );
echo( joinprob=alt_join( ["a",["c","d"],[34,33],43] ) );

echo( nestlist=alt_join( [98,99,["c","d"],42] ) );
echo( nestlist=alt_join( ["c", [98,99], "d" ] ) );
echo( nestlist= alt_join( ["foo","bar",["hi","ho"],"baz"], "," ) );
echo( nestlist= alt_join( [32,97,[98,99],97,[98,99],97,[98,99]], "," ));

echo( "\n\ttesting alt_join() even more" );
}

assert( alt_join( ["a","b","c"] ) == "abc" );
assert( alt_join( [] ) == "" );
assert( alt_join( [3,4,5]  )== "345");
assert( alt_join( [34,45,56]  )== "344556");
assert( alt_join( ["a","b","c"], delimiter="-" ) == "a-b-c" );
assert( alt_join( ["a","b","c"], "-"  ) == "a-b-c");
assert( alt_join( [], "-" ) == "" );
assert( alt_join( [3,4,5], "-"  ) == "3-4-5" );
assert( alt_join( [34,45,56], "-"  ) == "34-45-56" );

assert( alt_join( ["foo", "bar", "baz"] )       == "foobarbaz");
assert( alt_join( ["foo", "bar", "baz"], ", " ) == "foo, bar, baz" );
assert( alt_join( ["foo", "bar", "baz"], "" )   == "foobarbaz" );
assert( alt_join( ["foo"], "," ) == "foo" );
assert( alt_join( [], "" )== "" );
assert( alt_join( [], " " ) == "" );
assert( alt_join( [], "," ) == "" );

tsvec = ["this","is","a","test"];
assert( alt_join( tsvec ) == "thisisatest" );
assert( alt_join( tsvec,delimiter="--" ) == "this--is--a--test");

t=[23,[4,5],"str"];
assert( alt_join( t ) == "2345str" );
assert( alt_join( [23,[4,5],"str"] ) == "2345str" );

//echo( abcde=alt_join( ["a","b",["c","d"], "e"] ) );
assert(alt_join( ["a","b",["c","d"], "e"] ) == "abcde" );

tabcde= ["a","b",["c","d"], "e"];
resabcde = alt_join( tabcde, " " );
assert( resabcde == "a b c d e" );
//echo( str_to_ascii( resabcde ) );

space=alt_join( tabcde, " " );
assert(alt_join( ["a","b",["c","d"], "e"], " " ) == "a b c d e" );

//echo( altjoin=alt_join( ["a","b",["c","d"], "e"], " " ) );
assert(alt_join( ["a","b",["c","d"], "e"], " " ) == "a b c d e" );

tmix = [98,99,["c","d"],42];
//echo( altjoin=alt_join( tmix ) );
assert(alt_join( [98,99,["c","d"],42] ) == "9899cd42" );


//echo( altjoin=alt_join( [98,99,["c","d"],42] ) );
assert(alt_join( [98,99,["c","d"],42] ) == "9899cd42" );
//echo( alt_join( [98,99,[42,43],"ccc","ddd"] )  );
assert(alt_join( [98,99,[42,43],"ccc","ddd"] ) == "98994243cccddd" );
//echo( alt_join( [98,99,[42,43],99,[42,43],99,[42,43]] ) );
assert(alt_join( [98,99,[42,43],99,[42,43],99,[42,43]] ) == "98994243994243994243" );

assert( alt_join( ["foo","bar",["hi","ho"], "baz"], "," ) == "foo,bar,hi,ho,baz" );
assert( alt_join( [32,97,[98,99],42], "," ) == "32,97,98,99,42" );


echo( "\n\ttesting _sub_by_index()" );
assert( _sub_by_index( "abc", 0, 2 ) == "abc" );
assert( _sub_by_index( "abc", 1, 2 ) == "bc" );
assert( _sub_by_index( "abc", 2, 2 ) == "c" );

assert( _sub_by_index( "abc", 0, 0 ) == "a" );
assert( _sub_by_index( "abc", 1, 1 ) == "b" );
assert( _sub_by_index( "abc", 2, 2 ) == "c" );
assert( _sub_by_index( "abc", 1, 2 ) == "bc" );

echo( "testing char_to_digit( char, base=10 ) " );
assert( char_to_digit( "0" ) == 0 );
assert( char_to_digit( "1" ) == 1 );
assert( char_to_digit( "9" ) == 9 );

assert( char_to_digit( "0", base=16 ) == 0 );
assert( char_to_digit( "1", base=16 ) == 1 );
assert( char_to_digit( "9", base=16 ) == 9 );
assert( char_to_digit( "A", base=16 ) == 10);
assert( char_to_digit( "E", base=16 ) == 14);
assert( char_to_digit( "F", base=16 ) == 15);
assert( is_undef( char_to_digit( "Z", base=16 ) ) );


echo( "testing _parse_whole( string )" );
assert( _parse_whole( "0", base=10 ) == 0 );
assert( _parse_whole( "1" ) == 1 );
assert( _parse_whole( "9", base=10 ) == 9 );
assert( _parse_whole( "12" ) == 12 );
assert( _parse_whole( "120000" ) == 120000 );

assert( _parse_whole( "0", base=16 ) == 0 );
assert( _parse_whole( "1", base=16 ) == 1 );
assert( _parse_whole( "9", base=16 ) == 9 );
assert( _parse_whole( "A", base=16 ) == 10 );
assert( _parse_whole( "E", base=16 ) == 14 );
assert( _parse_whole( "F", base=16 ) == 15 );

echo( "testing parse_int( string )" );
assert( parse_int( "12" ) == 12 );
assert( parse_int( "-12" ) == -12 );
assert( parse_int( "120000" ) == 120000 );
assert( parse_int( "   120000   " ) == 120000 );


echo( "testing parse_hex( string )" );
assert( parse_hex( "-0" ) == 0 ); 
assert( parse_hex( "000" ) == 0 ); 
assert( parse_hex( "01" ) == 1 );
assert( parse_hex( "010" ) == 16 );
assert( parse_hex( "0100" ) == 256 );
assert( parse_hex( "1000" ) == 4096 );
assert( parse_hex( "00a" ) == 10 );
assert( parse_hex( "0b0" ) == 16*11 );
assert( parse_hex( "c00" ) == 256*12 );
assert( parse_hex( "f000" ) == 4096*15 );

assert( parse_hex( "12" ) == 18 );
assert( parse_hex( "-12" ) == 18 );
assert( parse_hex( "A" ) == 10 ); 
assert( parse_hex( "F" ) == 15); 
assert( parse_hex( "F2" ) == 16*15+2 ); 
assert( parse_hex( "   034ef   " ) == 4096*3 + 256*4 + 16*14 + 15 );


echo( "testing before()" );
assert( before(ts, -1)  == _STRING_NULL );
assert( before(ts, 0)   == _STRING_NULL );
assert( before(ts)      == _STRING_NULL );

assert( before( "short", 0) == "" );
assert( before( "short", 1) == "s" );
assert( before( "short", 2) == "sh" );
assert( before( "short", 3) == "sho" );
assert( before( "short", 4) == "shor" );
assert( before( "short", 5) == "short" );
assert( before( "short", 6) == "short" );
assert( before(ts, tsLast) == "this is a tes" );
assert( before(ts, tsLen) == ts );
assert( before( "", 3 ) == "" );
assert( before( "   ", 1 ) == " " );
assert( before( "xyz", 20 ) == "xyz" );
assert( before(ts, -3) == _STRING_NULL );
assert( is_undef( before( ts, undef ) ) );
assert( is_undef( before( 42, 0 ) ) );


echo( "testing starting_from( string, start=0 )" );
assert(	is_undef( starting_from(ts, -1) ) );
assert(  starting_from( "abc", 0 ) == "abc" );
assert(  starting_from( "abc", 1 ) == "bc" );
assert(  starting_from( "abc", 2 ) == "c" );
assert(  starting_from( "abc", 3 ) == "" );
assert(  starting_from( "abc", 4 ) == "" );


echo(	"testing after()" );
assert(	is_undef( after(ts, -1) ) );
assert( after( "abc", 0 ) == "bc" );
assert( after( "abc", 1 ) == "c" );
assert( after( "abc", 2 ) == "" );

assert(	after(ts, 40 ) == _STRING_NULL );
assert(	after(ts) == "his is a test" );
//echo( after(ts, tsLast) );
assert(	after(ts, tsLast) == _STRING_NULL );
//echo( after(ts, tsLen) );
assert(	after(ts, tsLen) == _STRING_NULL );
assert(	after(ts, undef) == undef );
assert( after( ts, [] ) == undef );


 
echo( "testing str_from_to(string, start, end)" ); 
assert( is_undef( str_from_to("bar", undef, undef) ) );
assert( is_undef( str_from_to("bar", undef, 1) ) );
assert( is_undef( str_from_to("bar", 1, undef) ) );
// echo( sft=str_from_to( ts, -1,  1) );
assert( is_undef( str_from_to( ts, -1,  1) ) );
assert( is_undef( str_from_to( ts, 0, -1) ) );

assert( str_from_to( "short", 0, 0)  == "s" );
assert( str_from_to( "short", 1, 1)  == "h" );
assert( str_from_to( "short", 2, 2)  == "o" );
assert( str_from_to( "short", 3, 3)  == "r" );
assert( str_from_to( "short", 4, 4)  == "t" );
assert( is_undef( str_from_to( "short", 5, 5) ) );
assert( is_undef( str_from_to( "short", 6, 6) ) );

assert( str_from_to( "short", 0, 0) == "s" );
assert( str_from_to( "short", 0, 1) == "sh" );
assert( str_from_to( "short", 0, 2) == "sho" );
assert( str_from_to( "short", 0, 3) == "shor" );
assert( str_from_to( "short", 0, 4) == "short" );
assert( str_from_to( "short", 0, 5) == "short" );
assert( str_from_to( "short", 0, 6) == "short" );

assert( is_undef( str_from_to( "short", 1, 0) ) ); // undef as start is > end
assert( str_from_to( "short", 1, 1) ==  "h" ); // start == end
assert( str_from_to( "short", 1, 2) ==  "ho" ); 
assert( str_from_to( "short", 1, 3) ==  "hor" ); 
assert( str_from_to( "short", 1, 4) ==  "hort" );
assert( str_from_to( "short", 1, 5) ==  "hort" ); 
assert( str_from_to( "short", 1, 6) ==  "hort" );

assert( is_undef( str_from_to( "short", 2, 0 ) ) ); // undef as start is > end
assert( is_undef( str_from_to( "short", 2, 1 ) ) ); // undef as start is > end

// echo( str_from_to( "short", 2, 2) );
assert( str_from_to( "short", 2, 2) ==  "o" );
assert( str_from_to( "short", 2, 3) ==  "or" );
assert( str_from_to( "short", 2, 4) ==  "ort" );

assert( str_from_to( "short", 4, 4) ==  "t" );
assert( str_from_to( "short", 4, 5) ==  "t" );
assert( str_from_to( "short", 4, 6) ==  "t" );

assert( is_undef( str_from_to( "short",  20, 20 ) ) );
assert( is_undef( str_from_to( "short",  -1, 20 ) ) );
assert( "short" == str_from_to( "short",   0, 20 ) );
//echo(str_from_to( "short", 2, 20 ));
assert( str_from_to( "short", 2, 20 ) == "ort" );
assert( str_from_to( ts,  5, 6 ) == "is" );
assert( is_undef( str_from_to( ts,  6,  5) ) );


echo( "testing str_between_indecies()" ); 
assert( str_between_indecies("bar", undef, undef) == undef );
assert( str_between_indecies("bar", undef, 1) == undef );
assert( str_between_indecies("bar", 1, undef) == undef );
assert( str_between_indecies( ts, -1,  1) == ts[0] );
assert( str_between_indecies( "xyz",  1,  2) == "y" );
assert( str_between_indecies( "this",  1,  3) == "hi" );
assert( str_between_indecies( "this",  0,  2) == "th" );
assert( str_between_indecies( "this",  1,  1) == _STRING_NULL );
assert( is_undef( str_between_indecies( ts, -1, -1) ) );
assert( str_between_indecies( "short", 0, 0) == "" );
assert( str_between_indecies( "short", 0, 1) == "s" );
assert( str_between_indecies( "short", 0, 2) == "sh" );
assert( str_between_indecies( "short", 0, 3) == "sho" );
assert( str_between_indecies( "short", 0, 4) == "shor" );
assert( str_between_indecies( "short", 0, 5) == "short" );
assert( str_between_indecies( "short", 0, 6) == "short" );

assert( is_undef( str_between_indecies( "short", 1, 0) ) ); // undef as start is > end
assert( str_between_indecies( "short", 1, 1) ==  "" ); // start == end
assert( str_between_indecies( "short", 1, 2) ==  "h" ); // correct
assert( str_between_indecies( "short", 1, 3) ==  "ho" ); // correct
assert( str_between_indecies( "short", 1, 4) ==  "hor" ); // correct
assert( str_between_indecies( "short", 1, 5) ==  "hort" ); // hor
assert( str_between_indecies( "short", 1, 6) ==  "hort" ); // hor

assert( is_undef( str_between_indecies( "short", 2, 0 ) ) ); // undef as start is > end
assert( is_undef( str_between_indecies( "short", 2, 1 ) ) ); // undef as start is > end
assert( str_between_indecies( "short", 2, 2) ==  "" );
assert( str_between_indecies( "short", 2, 3) ==  "o" );
assert( str_between_indecies( "short", 2, 4) ==  "or" );
assert( str_between_indecies( "short", 2, 5) ==  "ort" );

assert( str_between_indecies( "short", 4, 4) ==  "" );
assert( str_between_indecies( "short", 4, 5) ==  "t" );
assert( str_between_indecies( "short", 4, 6) ==  "t" );


assert(  is_undef( str_between_indecies( "short",  20, 20 ) ) );
assert( "short" == str_between_indecies( "short",  -1, 20 ) );
assert( "short" == str_between_indecies( "short",   0, 20 ) );
//echo(str_between_indecies( "short", 2, 20 ));
assert( str_between_indecies( "short", 2, 20 ) == "ort" );
assert( str_between_indecies( ts,  5,  7 ) == "is" );
assert( is_undef( str_between_indecies( ts,  7,  5) ) );



echo( "testing _str_sub_from_for:" );

echo( "\tfrom to last" );
assert( _str_sub_from_for( "short", 0,5 )  == "short" );
assert( _str_sub_from_for( "short", 1,5 )  == "hort" );
assert( _str_sub_from_for( "short", 2,5 )  == "ort" );
assert( _str_sub_from_for( "short", 3,5 )  == "rt" );
assert( _str_sub_from_for( "short", 4,5 )  == "t" );
assert( is_undef( _str_sub_from_for( "short", 5,5 ) ) );
assert( is_undef( _str_sub_from_for( "short", 6,5 ) ) );


echo( "\tfrom for" );
assert( _str_sub_from_for( "short", 0, 0 ) == "" );
assert( _str_sub_from_for( "short", 0, 1 ) == "s" );
assert( _str_sub_from_for( "short", 0, 2 ) == "sh" );
assert( _str_sub_from_for( "short", 0, 3 ) == "sho" );
assert( _str_sub_from_for( "short", 0, 4 ) == "shor" );
assert( _str_sub_from_for( "short", 0, 5 ) == "short" );
assert( _str_sub_from_for( "short", 0, 6 ) == "short" );

echo( "\tfrom 4 for" );
assert( is_undef( _str_sub_from_for( "short", 10, 2) ) ); 
assert( _str_sub_from_for( "short", 4, 6) == "t" );
assert( _str_sub_from_for( "short", 4, 1) == "t" );
assert( _str_sub_from_for( "short", 4, 3) == "t" );

echo( "\tspecial cases" );
assert( _str_sub_from_for( "short", 2,  2 ) == "or" );
assert( _str_sub_from_for( "short", 2, -2 ) == "" );
assert( _str_sub_from_for( "short", 2, 0  ) == "" );


echo( "testing str_sub_from_for:" );
echo( "\tdefaults" );
assert( str_sub_from_for( "Correct" )      == "Correct" );
assert( str_sub_from_for( "xCorrect", 1 )  == "Correct" );
assert( str_sub_from_for( "xCorrect", 1, 7 )== "Correct" );

echo( "\tdbad inputs" );
assert( is_undef( str_sub_from_for( 42) ) );
assert( is_undef( str_sub_from_for( []) ) );
assert( is_undef( str_sub_from_for( ts, 50, 2) ) );

echo( "\tonly from" );
assert( str_sub_from_for( "short"    ) == "short" );
assert( str_sub_from_for( "short", 0 ) == "short" );
assert( str_sub_from_for( "short", 1 ) == "hort" );
assert( str_sub_from_for( "short", 2 ) == "ort" );
assert( str_sub_from_for( "short", 3 ) == "rt" );
assert( str_sub_from_for( "short", 4 ) == "t" );
assert( is_undef( str_sub_from_for( "short", 5 ) ) );
assert( is_undef( str_sub_from_for( "short", 6 ) ) );

echo( "\tfrom for" );
assert( str_sub_from_for( "short", 0, 0 ) ==  "" );
assert( str_sub_from_for( "short", 0, 1 ) ==  "s" );
assert( str_sub_from_for( "short", 0, 2 ) ==  "sh" );
assert( str_sub_from_for( "short", 0, 3 ) ==  "sho" );
assert( str_sub_from_for( "short", 0, 4 ) ==  "shor" );
assert( str_sub_from_for( "short", 0, 5 ) ==  "short" );
assert( str_sub_from_for( "short", 0, 6 ) ==  "short" );

echo( "\tfrom 4 for" );
assert( is_undef( str_sub_from_for( "short", 10, 2) ) );
assert( str_sub_from_for( "short", 4, 6) == "t" );
assert( str_sub_from_for( "short", 4, 1) == "t" );
assert( str_sub_from_for( "short", 4, 3) == "t" );

echo( "\tspecial cases" );
assert( str_sub_from_for( "short", 2, -2 ) == _STRING_NULL );
assert( str_sub_from_for( "short", 2, 0 )  == _STRING_NULL );



echo( "testing lower()" );
assert( is_undef( lower( 42 ) ) );
assert( lower( "" ) == "" );
assert( lower( "  " ) == "  " );
assert( is_undef( lower( 32 ) ) );
assert( lower( FOOBAR ) == foobar );
assert( lower( "THIS IS A TEST" ) == ts );

echo( "testing str_lower()" );
assert( str_lower( "" ) == "" );
assert( str_lower( "  " ) == "  " );
assert( str_lower( "abc" ) == "abc" );
assert( str_lower( FOOBAR ) == foobar );
assert( str_lower( "THIS IS A TEST" ) == ts );

echo( "testing upper()" );
assert( is_undef( upper( 42 ) ) );
assert( upper( "" ) == "" );
assert( upper( "  " ) == "  " );
assert( is_undef( upper( 32 ) ) );
assert( upper( foobar ) == FOOBAR );
assert( upper( ts ) == "THIS IS A TEST" ) ;


echo( "testing str_upper()" );
assert( str_upper( "" ) == "" );
assert( str_upper( "  " ) == "  " );
assert( str_upper( foobar ) == FOOBAR );
assert( str_upper( ts ) == "THIS IS A TEST" ) ;

echo("testing str_equals()" );
// string must be same length for this function
assert( ! str_equals( _STRING_DIGITS, "foobar" ) );
assert(   str_equals( _STRING_DIGITS, "0123456789") );
assert(   str_equals( _STRING_NULL, _STRING_NULL) );
assert(   str_equals( ts, mts, ignore_case=true ) );
assert( ! str_equals( "this", "THIS" ) ); // f
assert(   str_equals( "this", "THIS", ignore_case=true ) ); // t

echo ( "all done" );
