Class AOC2022.Day17 Extends AOC2022.Base
{

Parameter InputFile = "d17.txt";

// d ##class(AOC2022.Day17).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	do ..GetRocks(.rocksArr)
	do ..InitGrid(.grid)
	if verbose zwrite rocksArr
	//if verbose write ! do ..DisplayGrid(.grid)
	set answer="",gasFlow=recordsArr(1),gasPos=1 //,counter=0
	//s fn="C:\devl\work\Cache\AOC\Files\2022\d17t1.log"
	//o fn:("NW")
	//u fn
	for rockCounter=0:1:2021 {
		set rockId=rockCounter#5+1
		kill rockArr merge rockArr=rocksArr(rockId)
		do ..SetRockOnGrid(.grid,.rockArr)
		//if verbose write !!,"before moving ",rockCounter do ..DisplayGrid(.grid,60)
		do ..MoveRock(.grid,.rockArr,gasFlow,.gasPos) // ,.counter)
		//if verbose write !!,"after moving ",rockCounter do ..DisplayGrid(.grid,60)
	}
	//if verbose zwrite grid
	set line=..GetFirstNotEmpty(.grid),counter=-line
	set answer=counter
	if verbose do ..DisplayGrid(.grid)
	//close fn
	quit answer
}

ClassMethod SetRockOnGrid(ByRef grid, ByRef rockArr) [ Private ]
{
	set height=$order(rockArr(""),-1)
	set topLine=..GetFirstNotEmpty(.grid) //=$order(grid(""))
	set toLine=topLine-4
	//Remove empty lines from top of the grid
	for line=$order(grid("")):1:toLine {
		kill grid(line)
	}
	set fromLine=toLine-height+1,rockLine=0,width=$length(rockArr(1)),addDot=$extract("....",width,4)
	//w !,rock,",",fromLine,":",toLine
	for line=fromLine:1:toLine {
		set rockLine=rockLine+1
		set grid(line)="|.."_rockArr(rockLine)_addDot_"|"
	}
}

ClassMethod GetFirstNotEmpty(ByRef grid) As %Integer [ Private ]
{
	set line=""
	for  {
		set line=$order(grid(line)) quit:line=""
		if grid(line)'="|.......|" return line
	}
	quit 0
}

ClassMethod MoveRock(ByRef grid, ByRef rockArr, gasFlow As %String, gasPos As %Integer) [ Private ]
{
	set maxGasPos=$length(gasFlow),fromY=$order(grid("")),fromX=4
	//write !
	for  {
		set dir=$extract(gasFlow,gasPos)
		set gasPos=gasPos+1
		if gasPos>maxGasPos set gasPos=1 // w !,"Starting over with the gas" d DisplayGrid(.grid)
		//write !!,"before moving ",dir do DisplayGrid(.grid,fromY-$order(grid(""))+10)
		//w dir
		do ..MoveRockOnGridX(.grid,.rockArr,dir,fromY,.fromX)
		//w !!,"after x" d DisplayGrid(.grid)
		quit:'..MoveRockOnGridY(.grid,.rockArr,fromY,fromX)
		//w !!,"after y" d DisplayGrid(.grid)
		set fromY=fromY+1
	}
}

ClassMethod MoveRockOnGridX(ByRef grid, ByRef rockArr, dir As %String, y As %Integer, x As %Integer) [ Private ]
{
	set height=$order(rockArr(""),-1),width=$length(rockArr(1))
	set fromY=y,toY=fromY+height-1
	set fromX=x,toX=fromX+width-1
	if dir=">" {
		quit:'..IsRightEmpty(.grid,.rockArr,toX+1,fromY,toY)
		do ..MoveRockRight(.grid,.rockArr,fromX,toX,fromY,toY)
		set x=x+1
	}
	if dir="<" {
		quit:'..IsLeftEmpty(.grid,.rockArr,fromX-1,fromY,toY)
		do ..MoveRockLeft(.grid,.rockArr,fromX,toX,fromY,toY)
		set x=x-1
	}
}

ClassMethod IsRightEmpty(ByRef grid, ByRef rockArr, x As %Integer, fromY As %Integer, toY As %Integer) As %Boolean [ Private ]
{
	set width=$length(rockArr(1))
	//zw width,rockArr,x,fromY,toY
	for y=fromY:1:toY {
		set diff=..GetFirstFromRight(.rockArr,y-fromY+1)
		continue:$extract(grid(y),x-diff)="."
		return 0
	}
	quit 1
}

ClassMethod GetFirstFromRight(ByRef rockArr, y As %Integer) As %Integer [ Private ]
{
	set data=rockArr(y),width=$length(data)
	for x=width:-1:1 {
		if $extract(data,x)'="." return width-x
	}
	quit 0
}

ClassMethod MoveRockRight(ByRef grid, ByRef rockArr, fromX As %Integer, toX As %Integer, fromY As %Integer, toY As %Integer) [ Private ]
{
	//set eraser=$translate($justify(" ",toX-fromX+1)," ",".")
	set width=$length(rockArr(1))
	for y=fromY:1:toY {
		//set $extract(grid(y),fromX,toX)=eraser
		//set $extract(grid(y),fromX+1,toX+1)=rockArr(y-fromY+1)
		for x=width:-1:1 {
			set val=$extract(rockArr(y-fromY+1),x)
			continue:val'="#"
			set $extract(grid(y),fromX+x-1)="." //current position
			set $extract(grid(y),fromX+x)="#"   //next position
		}
	}
}

ClassMethod IsLeftEmpty(ByRef grid, ByRef rockArr, x As %Integer, fromY As %Integer, toY As %Integer) As %Boolean [ Private ]
{
	for y=fromY:1:toY {
		//continue:$extract(rockArr(y-fromY+1),1)="."
		set diff=..GetFirstFromLeft(.rockArr,y-fromY+1)
		continue:$extract(grid(y),x+diff)="."
		return 0
	}
	quit 1
}

ClassMethod GetFirstFromLeft(ByRef rockArr, y As %Integer) [ Private ]
{
	set data=rockArr(y),width=$length(data)
	for x=1:1:width {
		if $extract(data,x)'="." return x-1
	}
	quit 0
}

ClassMethod MoveRockLeft(ByRef grid, ByRef rockArr, fromX As %Integer, toX As %Integer, fromY As %Integer, toY As %Integer) [ Private ]
{
	//set eraser=$translate($justify(" ",toX-fromX+1)," ",".")
	set width=$length(rockArr(1))
	for y=fromY:1:toY {
		//set $extract(grid(y),fromX,toX)=eraser
		//set $extract(grid(y),fromX-1,toX-1)=rockArr(y-fromY+1)
		for x=1:1:width {
			set val=$extract(rockArr(y-fromY+1),x)
			continue:val'="#"
			set $extract(grid(y),fromX+x-1)="." //current position
			set $extract(grid(y),fromX+x-2)="#"   //next position
		}
	}
}

ClassMethod MoveRockOnGridY(ByRef grid, ByRef rockArr, fromY As %Integer, fromX As %Integer) As %Boolean [ Private ]
{
	quit:'..IsDownEmpty(.grid,.rockArr,fromY,fromX) 0
	do ..MoveRockDown(.grid,.rockArr,fromY,fromX)
	quit 1
}

ClassMethod IsDownEmpty(ByRef grid, ByRef rockArr, fromY As %Integer, fromX As %Integer) As %Boolean [ Private ]
{
	set height=$order(rockArr(""),-1),width=$length(rockArr(1))
	set toY=fromY+height-1
	set toX=fromX+width-1
	set curLine=grid(toY)
	set nextLine=grid(toY+1)
	//w ! zw curLine,nextLine,rockArr,grid
	//w !!,"IsDownEmpty" d DisplayGrid(.grid)
	for x=fromX:1:toX {
		if $extract(rockArr(height),x-fromX+1)="#",$extract(nextLine,x)'="." return 0
		if $extract(rockArr(height),x-fromX+1)=".",$extract(curLine,x)'="." return 0
	}
	quit 1
}

ClassMethod MoveRockDown(ByRef grid, ByRef rockArr, fromY As %Integer, fromX As %Integer) [ Private ]
{
	set curLine=grid(fromY)
	set nextLine=grid(fromY+1)
	set height=$order(rockArr(""),-1),width=$length(rockArr(1))
	set toY=fromY+height-1
	set toX=fromX+width-1
	for y=toY:-1:fromY {
		set rockLine=rockArr(y-fromY+1)
		set gridCurLine=grid(y)
		set gridNextLine=grid(y+1)
		for x=fromX:1:toX {
			continue:$extract(rockLine,x-fromX+1)'="#"
			set $extract(gridCurLine,x)="."
			set $extract(gridNextLine,x)="#"
		}
		set grid(y)=gridCurLine
		set grid(y+1)=gridNextLine
	}
}

ClassMethod DisplayGrid(ByRef grid, maxLines As %Integer = 0, linesToMarkArr As %Integer) [ Private ]
{
	set line="",counter=0
	for  {
		set line=$order(grid(line)) quit:line=""
		write !,grid(line)
		if $data(linesToMarkArr(line)) write linesToMarkArr(line)
		if maxLines set counter=counter+1 quit:counter=maxLines
	}
}

ClassMethod GetRocks(Output rocksArr) [ Private ]
{
	;-
	set rocksArr(1,1)="####"
	;
	;+
	set rocksArr(2,1)=".#."
	set rocksArr(2,2)="###"
	set rocksArr(2,3)=".#."
	;
	;mirrored L
	set rocksArr(3,1)="..#"
	set rocksArr(3,2)="..#"
	set rocksArr(3,3)="###"
	;
	;|
	set rocksArr(4,1)="#"
	set rocksArr(4,2)="#"
	set rocksArr(4,3)="#"
	set rocksArr(4,4)="#"
	;
	;square
	set rocksArr(5,1)="##"
	set rocksArr(5,2)="##"
}

ClassMethod InitGrid(Output grid) [ Private ]
{
	set grid(-3)="|.......|"
	set grid(-2)="|.......|"
 	set grid(-1)="|.......|"
	set grid(0)="+-------+"
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	do ..GetRocks(.rocksArr)
	do ..InitGrid(.grid)
	if verbose zwrite rocksArr
	set answer="",gasFlow=recordsArr(1),gasPos=1
	for rockCounter=0:1 {
		set rockId=rockCounter#5+1
		kill rockArr merge rockArr=rocksArr(rockId)
		do ..SetRockOnGrid(.grid,.rockArr)
		do ..MoveRock(.grid,.rockArr,gasFlow,.gasPos)
		set line=..GetFirstNotEmpty(.grid)
		set heightsArr(rockCounter)=line
		//Repeat pattern when tpo line is full
		//if verbose zwrite grid(line),grid(line+1)
		if (grid(line)="|#######|")||((grid(line)="|..###..|")&&(grid(line+2)="|..####.|")) {  //####### for input data, ### + #### good for example
			set full($increment(full))=rockCounter
			quit:full=2
		}
		quit:rockCounter>20000
	}
	set rockFrom=full(1),rockTo=full(2)
	//set rockFrom=$list(from,3),rockTo=$list(to,3)
	set diff=rockTo-rockFrom
	set deltaRock=(1000000000000-rockTo-1)#diff
	set startHeight=-heightsArr(rockFrom),endHeight=-heightsArr(rockTo)
	set deltaHeight=-startHeight-heightsArr(rockFrom+deltaRock)
	set numToDo=(1000000000000-rockFrom-1)\diff
	set diffHeight=endHeight-startHeight
	if verbose zwrite full,diff,deltaRock,deltaHeight,numToDo,startHeight,diffHeight
	set answer=numToDo*diffHeight+startHeight+deltaHeight
	set linesToMark(-startHeight)=" <<<<<<<<<< from here",linesToMark(-endHeight)=" <<<<<<<<<< to here"
	//f line=-startHeight:-1:-endHeight s shapes(grid(line))=""
	//if verbose zwrite shapes
	//if verbose do ..DisplayGrid(.grid,,.linesToMark)
	quit answer
}

}

