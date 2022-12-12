Class AOC2022.Day12 Extends AOC2022.Base
{

Parameter InputFile = "d12.txt";

// d ##class(AOC2022.Day12).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	set answer="",line="",(startX,endX,startY,endY)=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if record["S" set startX=$find(record,"S")-1,startY=line,$extract(recordsArr(line),startX)="a"
		if record["E" set endX=$find(record,"E")-1,endY=line,$extract(recordsArr(line),endX)="z"
	}
	if verbose zwrite startX,startY,endX,endY //,recordsArr
	set answer=..FindShortestPathPriorityQueue(.recordsArr,startX,startY,endX,endY,,.visited,.path)
	//if verbose zwrite visited
	if verbose zwrite path
	quit answer
}

ClassMethod FindShortestPathPriorityQueue(ByRef grid, fromX As %Integer, fromY As %Integer, toX As %Integer, toY As %Integer, steps As %Integer = 0, ByRef visited, ByRef path As %String = "", maxsteps As %Integer = 0, ByRef noVisitPlaces)
{
	//grid(y)=data
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	//
	set minSteps=999999
	if maxsteps,steps>maxsteps quit 999999
	quit:$data(noVisitPlaces(fromX,fromY)) 999999
	if fromX=toX,fromY=toY quit steps
	set Queue(steps,$listbuild(fromX,fromY))=path
	for  {
		set steps=$order(Queue("")) quit:'$length(steps)
		set value=$order(Queue(steps,"")),path=Queue(steps,value) kill Queue(steps,value)
		set fromX=$list(value,1),fromY=$list(value,2)
		if maxsteps,steps>maxsteps continue
		continue:$data(noVisitPlaces(fromX,fromY))
		set type=$extract($get(grid(fromY)),fromX)
		if '$length(type) continue
		if $data(visited(fromX,fromY)),visited(fromX,fromY)<=steps {
			continue
		}
		set visited(fromX,fromY)=steps
		set visited(fromX,fromY,"path")=path
		if fromX=toX,fromY=toY {
			set:steps<minSteps minSteps=steps
			quit
		}
		set typeCode=$ascii(type)
		set nextPosCode=$ascii($extract($get(grid(fromY)),fromX+1)) if ..IsValidMove(typeCode,nextPosCode) set Queue(steps+1,$listbuild(fromX+1,fromY))=path_$listbuild($listbuild(fromX+1,fromY))
		set nextPosCode=$ascii($extract($get(grid(fromY)),fromX-1)) if ..IsValidMove(typeCode,nextPosCode) set Queue(steps+1,$listbuild(fromX-1,fromY))=path_$listbuild($listbuild(fromX-1,fromY))
		set nextPosCode=$ascii($extract($get(grid(fromY+1)),fromX)) if ..IsValidMove(typeCode,nextPosCode) set Queue(steps+1,$listbuild(fromX,fromY+1))=path_$listbuild($listbuild(fromX,fromY+1))
		set nextPosCode=$ascii($extract($get(grid(fromY-1)),fromX)) if ..IsValidMove(typeCode,nextPosCode) set Queue(steps+1,$listbuild(fromX,fromY-1))=path_$listbuild($listbuild(fromX,fromY-1))
	}
	//w !,fromX,";",fromY,";",steps
	quit minSteps
}

ClassMethod IsValidMove(fromCode As %Integer, toCode As %Integer) As %Boolean
{
	if toCode<0 quit 0
	if toCode-fromCode>1 quit 0
	quit 1
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set answer="",line="",(startX,endX,startY,endY)=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if record["S" set startX=$find(record,"S")-1,startY=line,$extract(recordsArr(line),startX)="a"
		if record["E" set endX=$find(record,"E")-1,endY=line,$extract(recordsArr(line),endX)="z"
	}
	if verbose zwrite endX,endY //startX,startY,recordsArr
	set line="",minSteps=999999,minPath=""
	for  {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		for startX=1:1:$length(record) {
			if $extract(record,startX)="a" {
				if verbose write !,"Starting from ",startX,",",line
				set path=""
				set steps=..FindShortestPathPriorityQueue(.recordsArr,startX,line,endX,endY,,,.path,minSteps)
				set:steps<minSteps minSteps=steps,minPath=path
				if verbose write "=",steps,",",minSteps
			}
		}
	}
	set answer=minSteps
	//if verbose zwrite visited
	if verbose write ! zwrite minPath
	quit answer
}

}

