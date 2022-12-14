Class AOC2022.Day14 Extends AOC2022.Base
{

Parameter InputFile = "d14.txt";

// d ##class(AOC2022.Day14).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line="",(minX,maxX)=500,(minY,maxY)=0,grid(0,500)="+"
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set start=$piece(record," -> ",1)
		for pos=2:1:$length(record," -> ") {
			set startX=$piece(start,",",1),startY=$piece(start,",",2)
			set end=$piece(record," -> ",pos)
			set endX=$piece(end,",",1),endY=$piece(end,",",2)
			//w !,startX,",",startY,"-",endX,",",endY
			if startX=endX {
				//vertical
				set x=startX,dir=1
				set:endY<startY dir=-1
				set:startY<minY minY=startY
				set:startY>maxY maxY=startY
				set:endY<minY minY=endY
				set:endY>maxY maxY=endY
				for y=startY:dir:endY {
					set grid(y,x)="#"
				}
			} else {
				//horizontal
				set y=startY,dir=1
				set:endX<startX dir=-1
				set:startX<minX minX=startX
				set:startX>maxX maxX=startX
				set:endX<minX minX=endX
				set:endX>maxX maxX=endX
				for x=startX:dir:endX {
					set grid(y,x)="#"
				}
			}
			set start=end
		}
	}
	if verbose write ! zwrite minX,maxX,minY,maxY //,grid
	for y=minY:1:maxY {
		for x=minX:1:maxX {
			set:'$data(grid(y,x)) grid(y,x)="."
		}
	}
	if verbose write ! do ..GridDisplay(.grid)
	//OFF BY 1!!!! I did from 1 instead from 0, nahhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh....took me more than 1.5 hour to figure it out
	for counter=0:1 {
		quit:'..PourSand(.grid,500,0,minX,maxX)
	}
	if verbose write !!! do ..GridDisplay(.grid)
	set answer=counter
	quit answer
}

ClassMethod PourSand(ByRef grid, x As %Integer, y As %Integer, minX As %Integer, maxX As %Integer) As %Boolean
{
	for  {
		return:grid(0,500)'="+" 0  //DAMN RTFM
		return:'$data(grid(y+1)) 0
		if (x-1<minX)||(x+1>maxX) return 0
		if grid(y+1,x)="." {
			set y=y+1
			continue
		}
		if grid(y+1,x-1)="." {
			set y=y+1
			set x=x-1
			continue
		}
		if grid(y+1,x+1)="." {
			set y=y+1
			set x=x+1
			continue
		}
		set grid(y,x)="o"
		quit
	}
	quit 1
}

ClassMethod GridDisplay(ByRef grid)
{
	//grid(y,x)=data
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		write !
		set x=""
		for  {
			set x=$order(grid(y,x)) quit:x=""
			write grid(y,x)
		}
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set answer="",line="",(minX,maxX)=500,(minY,maxY)=0,grid(0,500)="+"
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set start=$piece(record," -> ",1)
		for pos=2:1:$length(record," -> ") {
			set startX=$piece(start,",",1),startY=$piece(start,",",2)
			set end=$piece(record," -> ",pos)
			set endX=$piece(end,",",1),endY=$piece(end,",",2)
			//w !,startX,",",startY,"-",endX,",",endY
			if startX=endX {
				//vertical
				set x=startX,dir=1
				set:endY<startY dir=-1
				set:startY<minY minY=startY
				set:startY>maxY maxY=startY
				set:endY<minY minY=endY
				set:endY>maxY maxY=endY
				for y=startY:dir:endY {
					set grid(y,x)="#"
				}
			} else {
				//horizontal
				set y=startY,dir=1
				set:endX<startX dir=-1
				set:startX<minX minX=startX
				set:startX>maxX maxX=startX
				set:endX<minX minX=endX
				set:endX>maxX maxX=endX
				for x=startX:dir:endX {
					set grid(y,x)="#"
				}
			}
			set start=end
		}
	}
	if verbose write ! zwrite minX,maxX,minY,maxY //,grid
	set maxY=maxY+2,minX=minX\2,maxX=maxX*2
	if verbose zwrite minX,maxX
	for y=minY:1:maxY {
		set type="."
		set:y=maxY type="#"
		for x=minX:1:maxX {
			set:'$data(grid(y,x)) grid(y,x)=type
		}
	}
	if verbose write ! do ..GridDisplay(.grid)
	for counter=0:1 {
		quit:'..PourSand(.grid,500,0,minX,maxX)
		//i verbose w !!,counter do GridDisplay(.grid)
	}
	if verbose write !!! do ..GridDisplay(.grid)
	set answer=counter
	quit answer
}

}

