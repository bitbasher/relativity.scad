_ASCII_CONVERT  = 97-65;

_ASCII_SPACE 	= 32;
_ASCII_0 		= 48;
_ASCII_9 		= _ASCII_0 + 9;
_ASCII_UPPER_A 	= 65;
_ASCII_UPPER_Z 	= _ASCII_UPPER_A + 25;
_ASCII_LOWER_A 	= 97;
_ASCII_LOWER_Z 	= _ASCII_LOWER_A + 25;
_ASCII_UNDER    = chr( "_" );


echo( ac=_ASCII_CONVERT);
function ascii_code( string ) = 
	!is_string(string)?
		undef
    : [for( c=string ) ord(c) <= _ASCII_LOWER_Z+4 ? ord(c) : undef ]
	;


function join( arrayOfStrings, delimeter="") = 
	is_undef( arrayOfStrings ) || ! is_list( arrayOfStrings ) ?
		undef
	: arrayOfStrings == []?
		""
	: _join(arrayOfStrings, len(arrayOfStrings)-1, delimeter);

function _join( arrayOfStrings, index, delimeter) = 
	index==0 ? 
		arrayOfStrings[index] 
	: str( _join( arrayOfStrings, index-1, delimeter), 
			delimeter,
			arrayOfStrings[index]
			) ;
	
    
function l(string) = 
	let(code = ascii_code(string), lastInd=len(code)-1)
    join( [for (c = code)
			c >= _ASCII_UPPER_A && c <= _ASCII_UPPER_Z?
                chr(c+_ASCII_CONVERT)
            :
                chr(c)
    ] )
    ;
echo( c=l( "XXXfGdFG" ) );
    