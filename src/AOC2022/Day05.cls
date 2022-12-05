Class AOC2022.Day05 Extends AOC2022.Base
{

Parameter InputFile = "d05.txt";

// d ##class(AOC2022.Day05).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if state=0,record'["[" {
			set state=1
			continue
		}
		if '$length(record),state=1 {
			set state=2
			if verbose zwrite arr
			continue
		}
		if state=0 {
			set loc=0
			for i=2:4:$length(record) {
				set loc=loc+1
				set char=$zstrip($extract(record,i),"*W")
				if $length(char) {
					set arr(loc,$increment(arr(loc)))=char
				}
			}
		}
		if state=2 {
			set cnt=$piece(record," ",2)
			set from=$piece(record," ",4)
			set to=$piece(record," ",6)
			set pos=""
			for i=1:1:cnt {
				set pos=$order(arr(from,pos)) quit:pos=""
				set arr(to,$order(arr(to,""))-1)=arr(from,pos)
				kill arr(from,pos)
			}
			if verbose write !!!,line,"=",cnt,",",from,",",to,!
			if verbose zwrite arr
		}
	}
	set loc="" for  {
		set loc=$order(arr(loc)) quit:loc=""
		set answer=answer_arr(loc,$order(arr(loc,"")))
	}
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",state=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if state=0,record'["[" {
			set state=1
			continue
		}
		if '$length(record),state=1 {
			set state=2
			if verbose zwrite arr
			continue
		}
		if state=0 {
			set loc=0
			for i=2:4:$length(record) {
				set loc=loc+1
				set char=$zstrip($extract(record,i),"*W")
				if $length(char) {
					set arr(loc,$increment(arr(loc)))=char
				}
			}
		}
		if state=2 {
			set cnt=$piece(record," ",2)
			set from=$piece(record," ",4)
			set to=$piece(record," ",6)
			set pos="",temp=""
			for i=1:1:cnt {
				set pos=$order(arr(from,pos)) quit:pos=""
				set temp=arr(from,pos)_temp
				kill arr(from,pos)
			}
			for i=1:1:cnt {
				set arr(to,$order(arr(to,""))-1)=$extract(temp,i)
			}
			if verbose write !!!,line,"=",cnt,",",from,",",to,!
			if verbose zwrite arr
		}
	}
	set loc="" for  {
		set loc=$order(arr(loc)) quit:loc=""
		set answer=answer_arr(loc,$order(arr(loc,"")))
	}
	quit answer
}

}

