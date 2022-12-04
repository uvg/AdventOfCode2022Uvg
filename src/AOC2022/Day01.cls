Class AOC2022.Day01 Extends AOC2022.Base
{

Parameter InputFile = "d01.txt";

// d ##class(AOC2022.Day01).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",sum=0,max=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set:sum>max max=sum
			set sum=0
			if verbose write !,line,"=",sum,",",max
			continue
		}
		set sum=sum+record
	}
	set:sum>max max=sum //Last elf
	if verbose write !,line,"=",sum,",",max
	set answer=max
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	kill sumArr
	set answer="",line="",sum=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set sumArr(sum)=""
			set sum=0
			continue
		}
		set sum=sum+record
	}
	set sumArr(sum)=""  //Last elf
	if verbose zwrite sumArr
	set sum="",total=0,counter=0
	for  {
		set sum=$order(sumArr(sum),-1)
		quit:sum=""
		set counter=counter+1,total=total+sum
		if verbose write !,counter,"=",sum,",",total
		quit:counter=3
	}
	set answer=total
	quit answer
}

}

