result=search( 3, [3,5,42] );
echo(result);
res2 = [for( r=result ) if(r!=[]) r];
echo(res2);

result2=search( 3, [4,5,42] );
echo(result2);
res3 = [for( r=result2 ) if(r!=[]) r];
echo(res3);

result4=search( [3,7], [4,5,42] );
echo(result4);
res5 = [for( r=result4 ) if(r!=[]) r];
echo(res5);

result6=search( [42,4], [4,5,42] );
echo(result6);
res7 = [for( r=result6 ) if(r!=[]) r];
echo(res7);