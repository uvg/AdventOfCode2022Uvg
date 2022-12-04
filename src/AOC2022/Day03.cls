Class AOC2022.Day03 Extends AOC2022.Base
{

Parameter InputFile = "d03.txt";

// d ##class(AOC2022.Day03).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set part1=$extract(record,1,$length(record)/2),part2=$extract(record,$length(record)/2+1,*)
		set same=$zstrip(part1,"*E",,part2)
		set prio=$ascii(same)-97+1
		set:prio<0 prio=prio+32+26
		if verbose write ! zwrite part1,part2,same,prio
		set total=total+prio
	}
	set answer=total
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",total=0,elf=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set elf=elf+1
		set ltrsArr(elf)=record
		if elf=3 {
			set elf=0
			set same=$zstrip(ltrsArr(1),"*E",,ltrsArr(2))
			set same=$zstrip(same,"*E",,ltrsArr(3))
			set prio=$ascii(same)-97+1
			set:prio<0 prio=prio+32+26
			if verbose write ! zwrite ltrsArr,same,prio
			set total=total+prio
			kill ltrsArr
		}
	}
	set answer=total
	quit answer
}

}

