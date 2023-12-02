Class AOC2022.Day10 Extends AOC2022.Base
{

Parameter InputFile = "d10.txt";

// d ##class(AOC2022.Day10).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line="",cycle=1,x=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set cmd=$piece(record," ",1)
		set opps(cycle)=""
		if cmd="noop" {
			set cycle=cycle+1
			continue
		}
		else {
			set value=$piece(record," ",2)
			set opps(cycle+1)=value
			set cycle=cycle+2
		}
	}
	if verbose zwrite opps
	set cycle="",strength=0
	for  {
		set cycle=$order(opps(cycle)) quit:cycle=""
		if cycle#40=20 {
			set strength=x*cycle+strength
		}
		set x=x+opps(cycle)
		if verbose write !,cycle,",",x,",",strength
	}
	set answer=strength
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",cycle=1,x=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set cmd=$piece(record," ",1)
		set opps(cycle)=""
		if cmd="noop" {
			set cycle=cycle+1
			continue
		}
		else {
			set value=$piece(record," ",2)
			set opps(cycle+1)=value
			set cycle=cycle+2
		}
	}
	if verbose zwrite opps
	set cycle="",pos=0,y=0,string=""
	for  {
		set cycle=$order(opps(cycle)) quit:cycle=""
		if cycle#40=1 {
			set y=y+1,string=""
		}
		if $zabs(pos-x)<2 {
			set string=string_"#"
		} else {
			set string=string_" "
		}
		set pos=pos+1
		if pos#40=0 {
			set pos=0
			set grid(y)=string
		}
		set x=x+opps(cycle)
	}
	if verbose zwrite grid
	set answer=##class(AOC.Utils).OCR(.grid,"#"," ")
	quit answer
}

}

