Class AOC2022.Day06 Extends AOC2022.Base
{

Parameter InputFile = "d06.txt";

// d ##class(AOC2022.Day06).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",record=recordsArr(1)
	if verbose write !,record
	for i=1:1:$length(record)-3 {
		set char=$extract(record,i)
		if (char=$extract(record,i+1))||(char=$extract(record,i+2))||(char=$extract(record,i+3)) continue
		set char=$extract(record,i+1)
		if (char=$extract(record,i+2))||(char=$extract(record,i+3)) continue
		set char=$extract(record,i+2)
		if (char=$extract(record,i+3)) continue
		quit
	}
	if verbose write !,$extract(record,i,i+3)
	set answer=i+3
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",record=recordsArr(1)
	if verbose write !,record
	for i=1:1:$length(record)-13 {
		set sw=0
		for j=i:1:i+12 {
			set char=$extract(record,j)
			for k=j+1:1:i+13 {
				if char=$extract(record,k) set sw=1 quit
			}
			quit:sw
		}
		quit:'sw
	}
	if verbose write !,$extract(record,i,i+13)
	set answer=i+13
	quit answer
}

}

