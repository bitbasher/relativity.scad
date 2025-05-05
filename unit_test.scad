// return a string of test results OR "passed"
//  given the name of the test and 
//  a vector of  testfunction(), testresult element pairs
//
function _unit_test(name, tests) = 
	let(results = 
		[for(i=[0:len(tests)/2]) // run all the tests
			let(test = tests[i*2], 
				result=tests[i*2+1])
			test==result
		])
	!all(results)?
		concat([name],
			[for(i=[0:len(tests)/2]) 
				let(test = tests[i*2], 
					result=tests[i*2+1])
				[test, result]
			]
		)
	:
		str(name, ":\tpassed")
    ;
