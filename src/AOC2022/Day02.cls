Class AOC2022.Day02 Extends AOC2022.Base
{

Parameter InputFile = "d02.txt";

// d ##class(AOC2022.Day02).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	//A,X - Rock      - 1
	//B,Y - Paper     - 2
	//C,Z - Scissors  - 3
	//0 - Lose, 3 - Draw, 6 - Win
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set opp=$piece(record," " ,1),me=$piece(record," ",2)
		set points=$select(me="X":1,me="Y":2,1:3)
		if me="X" set points=points+$select(opp="A":3,opp="B":0,1:6)
		if me="Y" set points=points+$select(opp="A":6,opp="B":3,1:0)
		if me="Z" set points=points+$select(opp="A":0,opp="B":6,1:3)
		set total=total+points
		if verbose write !,record,";",points,";",total
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	//A - Rock      - 1
	//B - Paper     - 2
	//C - Scissors  - 3
	//0 - X - Lose, 3 - Y - Draw, 6 - Z - Win
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set opp=$piece(record," " ,1),me=$piece(record," ",2)
		if me="X" set points=0+$select(opp="A":3,opp="B":1,1:2)
		if me="Y" set points=3+$select(opp="A":1,opp="B":2,1:3)
		if me="Z" set points=6+$select(opp="A":2,opp="B":3,1:1)
		set total=total+points
		if verbose write !,record,";",points,";",total
	}
	set answer=total
	quit answer
}

}

