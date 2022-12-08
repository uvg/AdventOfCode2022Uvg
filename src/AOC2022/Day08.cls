Class AOC2022.Day08 Extends AOC2022.Base
{

Parameter InputFile = "d08.txt";

// d ##class(AOC2022.Day08).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	set answer="",line="",width=$length(recordsArr(1)),height=$order(recordsArr(""),-1),counter=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if (line=1)||(line=height) {
			set counter=counter+width
			continue
		}
		set counter=counter+2
		for x=2:1:(width-1) set counter=counter+..IsVisible(.recordsArr,x,line,width,height,verbose)
	}
	set answer=counter
	quit answer
}

ClassMethod IsVisible(ByRef treesArr, posX As %Integer, posY As %Integer, width As %Integer, height As %Integer, verbose As %Boolean) As %Boolean [ Private ]
{
	set size=$extract(treesArr(posY),posX)
	if verbose write !,posX,",",posY,"=",size
	set isVisible=1
	for x=1:1:(posX-1) {
		if $extract(treesArr(posY),x)>=size {
			set isVisible=0
			quit
		}
	}
	quit:isVisible 1
	set isVisible=1
	for x=posX+1:1:width {
		if $extract(treesArr(posY),x)>=size {
			set isVisible=0
			quit
		}
	}
	quit:isVisible 1
	set isVisible=1
	for y=1:1:(posY-1) {
		if $extract(treesArr(y),posX)>=size {
			set isVisible=0
			quit
		}
	}
	quit:isVisible 1
	set isVisible=1
	for y=posY+1:1:height {
		if $extract(treesArr(y),posX)>=size {
			set isVisible=0
			quit
		}
	}
	quit:isVisible 1
	quit 0
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",width=$length(recordsArr(1)),height=$order(recordsArr(""),-1),maxScenicScore=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		if (line=1)||(line=height) {
			continue
		}
		set record=recordsArr(line)
		for x=2:1:width-1 {
			set scenicScore=..GetScenicScore(.recordsArr,x,line,width,height,verbose)
			set:scenicScore>maxScenicScore maxScenicScore=scenicScore
		}
	}
	set answer=maxScenicScore
	quit answer
}

ClassMethod GetScenicScore(ByRef treesArr, posX As %Integer, posY As %Integer, width As %Integer, height As %Integer, verbose As %Boolean) [ Private ]
{
	set size=$extract(treesArr(posY),posX)
	if verbose write !,posX,",",posY,"=",size
	set scenicScore=1
	set tempScenicScore=0
	for x=posX-1:-1:1 {
		set tempScenicScore=tempScenicScore+1
		if $extract(treesArr(posY),x)>=size {
			quit
		}
	}
	set scenicScore=scenicScore*tempScenicScore
	set tempScenicScore=0
	for x=posX+1:1:width {
		set tempScenicScore=tempScenicScore+1
		if $extract(treesArr(posY),x)>=size {
			quit
		}
	}
	set scenicScore=scenicScore*tempScenicScore
	set tempScenicScore=0
	for y=posY-1:-1:1 {
		set tempScenicScore=tempScenicScore+1
		if $extract(treesArr(y),posX)>=size {
			quit
		}
	}
	set scenicScore=scenicScore*tempScenicScore
	set tempScenicScore=0
	for y=posY+1:1:height {
		set tempScenicScore=tempScenicScore+1
		if $extract(treesArr(y),posX)>=size {
			quit
		}
	}
	set scenicScore=scenicScore*tempScenicScore
	quit scenicScore
}

}

