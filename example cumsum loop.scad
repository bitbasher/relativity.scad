function cumsum(v) = 
    [for(
        a = 0, i = 0;
        i < len(v); 
        a = a+v[i], i = i+1)
    if( i==len(v)-1 ) a+v[i]
    ][0];
    
    echo(cumsum([1, 2, 3, 4]));