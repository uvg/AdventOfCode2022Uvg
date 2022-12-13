Class AOC2022.Day13 Extends AOC2022.Base
{

Parameter InputFile = "d13.txt";

// d ##class(AOC2022.Day13).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line="",left="",right="",counter=1,sum=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if '$length(record) {
			set (left,right)=""
			set counter=counter+1
			continue
		}
		if '$length(left) {
			set left=record
			continue
		}
		if '$length(right) {
			set right=record
			set order=..IsInOrder(left,right)
			set:order'<0 sum=sum+counter
			if verbose write !,"left=",left,", right=",right,", order=",order
		}
	}
	set answer=sum
	quit answer
}

ClassMethod IsInOrder(left As %String, right As %String) As %Integer
{
	if '$length(right) quit 1
	if '$length(left) quit -1
	//W !!,"left=",left,",right=",right
	set isLeftList=..IsList(left)
	set isRightList=..IsList(right)
	if 'isLeftList,'isRightList {
		quit $select(left<right:1,left=right:0,1:-1)
	}
	set:'isLeftList left="["_left_"]"
	set:'isRightList right="["_right_"]"
	set leftListSize=..GetListSize(left)
	set rightListSize=..GetListSize(right)
	for pos=1:1:leftListSize {
		if pos>rightListSize return -1
		set leftElement=..GetElement(left,pos)
		set rightElement=..GetElement(right,pos)
		set ans=..IsInOrder(leftElement,rightElement)
		continue:'ans
		return ans
	}
	quit leftListSize<rightListSize
}

ClassMethod IsList(string)
{
	quit $extract(string)="["
}

ClassMethod GetListSize(string As %String) As %Integer
{
	if '$length(string) quit 0
	set size=0,squares=0,manip=$extract(string,2,*-1),pos=1
	for {
		quit:pos>$length(manip)
		if $extract(manip,pos)'="[" {
			set size=size+1,foundNext=0
			for i=pos+1:1:$length(manip) {
				if $extract(manip,i)="," {
					set pos=i+1,foundNext=1
					quit
				}
			}
			quit:'foundNext
			continue
		} else {
			set counter=0
			for i=pos:1:$length(manip) {
				if $extract(manip,i)="[" {
					set counter=counter+1
					continue
				}
				if $extract(manip,i)="]" {
					set counter=counter-1
					continue:counter'=0
					set size=size+1,pos=i+1
					set:$extract(manip,pos)="," pos=pos+1
					quit
				}
			}
		}
	}
	quit size
}

ClassMethod GetElement(string As %String, elemId As %Integer) As %String
{
	if '$length(string) quit ""
	set size=0,squares=0,manip=$extract(string,2,*-1),pos=1
	for {
		quit:pos>$length(manip)
		if $extract(manip,pos)'="[" {
			set size=size+1,foundNext=0
			for i=pos+1:1:$length(manip) {
				if $extract(manip,i)="," {
					if size=elemId {
						return $extract(manip,pos,i-1)
					}
					set pos=i+1,foundNext=1
					quit
				}
			}
			if 'foundNext,size=elemId {
				return $extract(manip,pos,*)
			}
			quit:'foundNext
			continue
		} else {
			set counter=0
			for i=pos:1:$length(manip) {
				if $extract(manip,i)="[" {
					set counter=counter+1
					continue
				}
				if $extract(manip,i)="]" {
					set counter=counter-1
					continue:counter'=0
					set size=size+1
					if size=elemId {
						return $extract(manip,pos,i)
					}
					set pos=i+1
					set:$extract(manip,pos)="," pos=pos+1
					quit
				}
			}
		}
	}
	quit ""
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		continue:'$length(record)
		set packetsArr($increment(packetsArr))=record
	}
	set packetsArr($increment(packetsArr))="[[2]]"
	set packetsArr($increment(packetsArr))="[[6]]"
	if verbose write !!,"before: ",! zwrite packetsArr
	for i=1:1:packetsArr-1 {
		for j=i+1:1:packetsArr {
			set left=packetsArr(i),right=packetsArr(j)
			set order=..IsInOrder(left,right)
			if order=-1 {
				set packetsArr(i)=right,packetsArr(j)=left
			}
		}
	}
	if verbose write !!,"after: ",! zwrite packetsArr
	set idx2=0,idx6=0
	for i=1:1:packetsArr {
		set:packetsArr(i)="[[2]]" idx2=i
		set:packetsArr(i)="[[6]]" idx6=i
	}
	set answer=idx2*idx6
	quit answer
}

}

