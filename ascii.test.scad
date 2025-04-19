_WHITESPACE = " \t\n\r";  
_ASCII_VISIBLE = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~";
_ASCII_LEGAL   = str( _WHITESPACE, _ASCII_VISIBLE );


digits = "0123456789";
code_digits = str_to_ascii(digits);
echo(code_digits);

function is_not_string( string ) =
	is_undef( string ) || ! is_string( string );

// no checking version of char_in_set
function _is_in_set( char, set, ignore_case=false ) =
    search( char, set ) != [] 
	;

function is_ascii( char ) = 
	_is_in_set( char, _ASCII_LEGAL );

function str_to_ascii( string ) = 
	is_not_string(string) ?
		[]
    : [for( c=string ) is_ascii(c) ? ord(c) : 0 ]
	;
    
   
 echo( str_to_ascii( "testing" ) );
 
 