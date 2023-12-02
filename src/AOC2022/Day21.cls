Class AOC2022.Day21 Extends AOC2022.Base
{

Parameter InputFile = "d21.txt";

// d ##class(AOC2022.Day21).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set var=$piece(record,": ",1),value=$piece(record,": ",2)
		set varArr(var)=value
	}
	set answer=..GetValue(.varArr,"root")
	quit answer
}

ClassMethod GetValue(ByRef varArr, var)
{
	set value=varArr(var)
	quit:$length(value," ")<3 value
	if $piece(value," ",1)'?1.n set $piece(value," ",1)=..GetValue(.varArr,$piece(value," ",1))
	if $piece(value," ",3)'?1.n set $piece(value," ",3)=..GetValue(.varArr,$piece(value," ",3))
	quit @value
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set var=$piece(record,": ",1),value=$piece(record,": ",2)
		set varArr(var)=value
	}
	set lastVal=varArr("humn")
	set $piece(varArr("root")," ",2)="-"
	merge orgVarArr=varArr
	kill varArr merge varArr=orgVarArr set lastRoot=$zabs(..GetValue(.varArr,"root"))
	set val=0
	set orgVarArr("humn")=val
	kill varArr merge varArr=orgVarArr set root=$zabs(..GetValue(.varArr,"root"))
	for  {
		kill varArr merge varArr=orgVarArr
		set slope=$select(lastRoot=root:-1,1:(val-lastVal)\(root-lastRoot))
		set lastVal=val,lastRoot=root
		set val=val-(slope*root*.01)
		set varArr("humn")=val
		set root=$zabs(..GetValue(.varArr,"root"))
		quit:root<.1
	}
	set answer=$fnumber(val,"",0)
	quit answer
}

}

