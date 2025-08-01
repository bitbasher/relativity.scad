
$spec = "special global";

module show(){
    let( temp = $spec );
    echo( str( "spec1: ", $spec ) );
    $spec = temp + 2;
    echo( str( "spec2: ", $spec ) );
    }

for ( $spec = [5:8] ){
    echo( str( "echo: ", $spec ) );
    }

for ( $spec = [5:8] ){
    show();
    }
    