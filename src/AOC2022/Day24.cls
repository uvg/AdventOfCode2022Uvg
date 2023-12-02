Class AOC2022.Day24 Extends AOC2022.Base
{

Parameter InputFile = "d24.txt";

// d ##class(AOC2022.Day24).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..Analayze(.recordsArr,.blizards)
	set fromX=2,fromY=1,toY=$order(recordsArr(""),-1),toX=$length(recordsArr(toY))-1
	if verbose zwrite recordsArr,toY,toX,blizards
	merge tempGrid=recordsArr,tempBlizards=blizards
	for  {
		quit:..MoveBlizards(.tempGrid,.tempBlizards,.blizardsTrans)
	}
	//if verbose zw blizardsTrans
	/*
	set answer=""
	f i=1:1:20 {
		if verbose w !!,i,!
		do MoveBlizards(.recordsArr,.blizards,.blizardsTrans)
		if verbose zwrite recordsArr
	}*/
	set maxSteps=(toY+1+toX+1)*2 //=999
	set answer=..FindShortestPathQueue(.recordsArr,fromX,fromY,toX,toY,0,.path,maxSteps,.blizards,.blizardsTrans)
	if verbose zwrite recordsArr,path,blizards //,blizardsTrans
	quit answer
}

ClassMethod Analayze(ByRef grid, ByRef blizards)
{
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		for x=1:1:$length(grid(y)) {
			set blizard=$extract(grid(y),x)
			continue:"<>v^"'[blizard
			set blizards($increment(blizards))=$listbuild(blizard,y,x)
		}
	}
}

ClassMethod FindShortestPathQueue(ByRef grid, fromX, fromY, toX, toY, steps = 0, path = "", maxsteps = 0, ByRef blizards, ByRef blizardsTrans, deltaSteps = 0)
{
	//..FindShortestPathQueue(.grid,2,1,8,4) from 2,1 to 8,4 with initial steps of 0 and no maxsteps boundry
	//grid(y)=data
	//I $e(data,x)'="." ==> can't visit there
	//There should be no holes in the grid so if y=5..10 then there should be grid(5),grid(6),grid(7),,,grid(10)
	set minSteps=999999
	if maxsteps,steps>maxsteps quit 999999
	if fromX=toX,fromY=toY quit steps
	set queue(1)=$listbuild(steps+1,fromX,fromY,path),last=1 //merge queue(1,"grid")=grid,queue(1,"blizards")=blizards
	for  {
		set key=$order(queue("")) quit:key=""
		kill grid,blizards
		set value=queue(key) //merge grid=queue(key,"grid"),blizards=queue(key,"blizards")
		kill queue(key)
		set steps=$list(value,1),fromX=$list(value,2),fromY=$list(value,3),path=$list(value,4)
		//if verbose write !!! zw path,fromX,fromY,steps
		if maxsteps,steps>maxsteps continue
		continue:steps>=minSteps
		set blizardStep=(steps+deltaSteps-1)#blizardsTrans(1)+1,blizardKey=blizardsTrans(1,blizardStep)
		merge blizards=blizardsTrans(0,blizardKey,"currBlizards")
		//if verbose write !!! zwrite blizardStep,blizardKey,blizards
		set status=..GetStateLine(.blizards,.statesArr,fromX,fromY)
		//set status=$$GetStateLine(.blizards,fromX,fromY)
		//if $list(status,4),$list(status,4)<=steps continue
		if $list(status,2),$list(status,2)<=steps continue
		do ..SetState(.statesArr,status,steps)
		//do SetState(status,steps)
		//do MoveBlizards(.grid,.blizards,.blizardsTrans)
		//merge grid=blizardsTrans(0,blizardKey,"nextGrid")
		//if verbose zw grid
		//set type=$extract($get(grid(fromY)),fromX)
		set type=$extract($get(blizardsTrans(0,blizardKey,"nextGrid",fromY)),fromX)
		if type'="." continue
		if fromX=toX,fromY=toY {
			set minSteps=steps
			kill queue
			return minSteps
		}
		set queue(last+1)=$listbuild(steps+1,fromX+1,fromY,path_$listbuild($listbuild(fromX+1,fromY))) //merge queue(last+1,"grid")=grid,queue(last+1,"blizards")=blizards
		set queue(last+2)=$listbuild(steps+1,fromX-1,fromY,path_$listbuild($listbuild(fromX-1,fromY))) //merge queue(last+2,"grid")=grid,queue(last+2,"blizards")=blizards
		set queue(last+3)=$listbuild(steps+1,fromX,fromY+1,path_$listbuild($listbuild(fromX,fromY+1))) //merge queue(last+3,"grid")=grid,queue(last+3,"blizards")=blizards
		set queue(last+4)=$listbuild(steps+1,fromX,fromY-1,path_$listbuild($listbuild(fromX,fromY-1))) //merge queue(last+4,"grid")=grid,queue(last+4,"blizards")=blizards
		set queue(last+5)=$listbuild(steps+1,fromX,fromY,path_$listbuild($listbuild(fromX,fromY))) //merge queue(last+5,"grid")=grid,queue(last+5,"blizards")=blizards
		set last=last+5
	}
	quit minSteps
}

ClassMethod SetState(ByRef statesArr, keyLine, data)
{
	set stateKey=$list(keyLine,1) //,state=$list(keyLine,3)
	set statesArr(stateKey)=data //$listbuild(state,data)
}

ClassMethod GetStateLine(ByRef blizards, ByRef statesArr, x, y)
{
	set key=..GetStateKey(.blizards,x,y)
	//set data="" //$$GetStateData(.blizards,x,y)
	//quit:'$data(statesArr(key)) $listbuild(key,0,data,0)
	//quit $listbuild(key,1,data,$list(statesArr(key),2))
	quit $listbuild(key,+$get(statesArr(key)))
}

ClassMethod GetStateKey(ByRef blizards, x, y)
{
	set key=$listbuild(x,y)_..GetBlizardKey(.blizards)
	quit key
}

ClassMethod GetBlizardKey(ByRef blizards)
{
	
	quit $zcrc(..GetBlizardData(.blizards),9)
}

ClassMethod GetStateData(ByRef blizards, x, y)
{
	set data=$listbuild(x,y)_..GetBlizardData(.blizards)
	quit data
}

ClassMethod GetBlizardData(ByRef blizards)
{
	set data="",blizardCnt=""
	for  {
		set blizardCnt=$order(blizards(blizardCnt)) quit:blizardCnt=""
		set data=data_blizards(blizardCnt)
	}
	quit data
}

ClassMethod GetBlizardLine(ByRef blizards, ByRef blizardsTrans)
{
	set key=..GetBlizardKey(.blizards)
	//set data=$$GetBlizardData(.blizards)
	//quit:'$data(blizardsTrans(key)) $listbuild(key,0,data)
	quit $listbuild(key,''$data(blizardsTrans(0,key))) //,data)
}

ClassMethod SetBlizardTrans(ByRef currGrid, ByRef currBlizards, ByRef nextGrid, ByRef nextBlizards, ByRef blizardsTrans, keyLine)
{
	set key=$list(keyLine,1) //,data=$list(keyLine,3)
	//set blizardsTrans(0,key)=data
	//merge blizardsTrans(0,key,"currGrid")=currGrid
	merge blizardsTrans(0,key,"currBlizards")=currBlizards
	merge blizardsTrans(0,key,"nextGrid")=nextGrid
	merge blizardsTrans(0,key,"nextBlizards")=nextBlizards
	set blizardsTrans(1,$increment(blizardsTrans(1)))=key
}

ClassMethod MoveBlizards(ByRef grid, ByRef blizards, ByRef blizardsTrans)
{
	set blizardKeyLine=..GetBlizardLine(.blizards,.blizardsTrans)
	if $list(blizardKeyLine,2) {
		merge grid=blizardsTrans(0,$list(blizardKeyLine,1),"nextGrid")
		merge blizards=blizardsTrans(0,$list(blizardKeyLine,1),"nextBlizards")
		quit 1
	}
	//set blizardData=$$GetBlizardData(.blizards)
	merge currGrid=grid,currBlizards=blizards
	set blizardCnt="",maxY=$order(grid(""),-1)-1,maxX=$length(grid(1))-1
	for  {
		set blizardCnt=$order(blizards(blizardCnt)) quit:blizardCnt=""
		set data=blizards(blizardCnt)
		set blizard=$list(data,1),y=$list(data,2),x=$list(data,3)
		set newY=$case(blizard,"<":y,">":y,"^":y-1,"v":y+1)
		set newX=$case(blizard,"<":x-1,">":x+1,"^":x,"v":x)
		set newY=$select(newY=1:maxY,newY>maxY:2,1:newY)
		set newX=$select(newX=1:maxX,newX>maxX:2,1:newX)
		set blizards(blizardCnt)=$listbuild(blizard,newY,newX)
	}
	do ..SetBilzardsOnGrid(.grid,.blizards)
	do ..SetBlizardTrans(.currGrid,.currBlizards,.grid,.blizards,.blizardsTrans,blizardKeyLine)
	quit 0
}

ClassMethod SetBilzardsOnGrid(ByRef grid, ByRef blizards)
{
	do ..EraseBlizardsFromGrid(.grid)
	//set blizards($increment(blizards))=$listbuild(blizard,y,x)
	set blizardCnt=""
	for  {
		set blizardCnt=$order(blizards(blizardCnt)) quit:blizardCnt=""
		set data=blizards(blizardCnt)
		set blizard=$list(data,1),y=$list(data,2),x=$list(data,3)
		set gridData=$extract(grid(y),x)
		set gridData=$select(gridData=".":blizard,"<>v^"[gridData:2,1:gridData+1#10)
		set $extract(grid(y),x)=gridData
	}
}

ClassMethod EraseBlizardsFromGrid(ByRef grid)
{
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		for x=1:1:$length(grid(y)) {
			continue:"#."[$extract(grid(y),x)
			set $extract(grid(y),x)="."
		}
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	do ..Analayze(.recordsArr,.blizards)
	merge tempGrid=recordsArr,tempBlizards=blizards
	for  {
		quit:..MoveBlizards(.tempGrid,.tempBlizards,.blizardsTrans)
	}
	set fromX=2,fromY=1,toY=$order(recordsArr(""),-1),toX=$length(recordsArr(toY))-1
	if verbose zwrite recordsArr,toY,toX,blizards
	set maxSteps=(toY+1+toX+1)*2 //=999
	set total=0
	set total=total+..FindShortestPathQueue(.recordsArr,fromX,fromY,toX,toY,0,.path,maxSteps,.blizards,.blizardsTrans,0) if verbose write !,total
	set total=total+..FindShortestPathQueue(.recordsArr,toX,toY,fromX,fromY,0,.path,maxSteps,.blizards,.blizardsTrans,total) if verbose write !,total
	set total=total+..FindShortestPathQueue(.recordsArr,fromX,fromY,toX,toY,0,.path,maxSteps,.blizards,.blizardsTrans,total) if verbose write !,total
	set answer=total
	quit answer
}

}

