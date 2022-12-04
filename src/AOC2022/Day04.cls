Class AOC2022.Day04 Extends AOC2022.Base
{

Parameter InputFile = "d04.txt";

// d ##class(AOC2022.Day04).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",counter=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set from1=+$piece(record,"-",1),to1=+$piece(record,"-",2)
		set from2=+$piece(record,",",2),to2=+$piece(record,"-",3)
		if from1>=from2,to1<=to2 {
			set counter=counter+1
			if verbose write !,from1,",",to1,",",from2,",",to2,">>>",counter
			continue
		}
		if from2>=from1,to2<=to1 {
			set counter=counter+1
			if verbose write !,from1,",",to1,",",from2,",",to2,">>>",counter
		}
	}
	set answer=counter
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",counter=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set from1=+$piece(record,"-",1),to1=+$piece(record,"-",2)
		set from2=+$piece(record,",",2),to2=+$piece(record,"-",3)
		if from1<=to2,to1>=from2 {
			set counter=counter+1
			if verbose write !,from1,",",to1,",",from2,",",to2,">>>",counter
			continue
		}
		if from2<=to1,to2>=from1 {
			set counter=counter+1
			if verbose write !,from1,",",to1,",",from2,",",to2,">>>",counter
		}
	}
	set answer=counter
	quit answer
}

}

