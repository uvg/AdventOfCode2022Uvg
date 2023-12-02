Class AOC2022.Day25 Extends AOC2022.Base
{

Parameter InputFile = "d25.txt";

// d ##class(AOC2022.Day25).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set total=..AddBase5(total,record)
	}
	set answer=total
	quit answer
}

ClassMethod AddBase5(num1 As %String, num2 As %String) As %String
{
	//                        1    2    3    4    5    6    7    8    9   10   11
	//                       -5   -4   -3   -2   -1    0    1    2    3    4    5
	set sumBase5=$listbuild("-0","-1","-2","0=","0-","00","01","02","1=","1-","10")
	set len1=$length(num1),len2=$length(num2)
	set len=len1
	set:len2>len1 len=len2
	if len1<len2 set add=10**(len2-len1),add=$extract(add,2,*),num1=add_num1
	if len2<len1 set add=10**(len1-len2),add=$extract(add,2,*),num2=add_num2
	set total="",carry=0
	for i=len:-1:1 {
		set digit1=$extract(num1,i),digit2=$extract(num2,i)
		set:digit1="=" digit1=-2
		set:digit1="-" digit1=-1
		set:digit2="=" digit2=-2
		set:digit2="-" digit2=-1
		set sum=digit1+digit2+carry
		set sum5=$list(sumBase5,sum+6)
		set carry=$extract(sum5,1),digit5=$e(sum5,2)
		set:carry="-" carry=-1
		set total=digit5_total
	}
	set:carry total=$select(carry=-1:"-",1:1)_total
	quit total
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	if verbose write !,"You made it to the last day"
	set Answer="Finito la comedy"
	quit Answer
}

}

