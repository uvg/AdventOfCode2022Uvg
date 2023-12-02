Class AOC2022.Day22 Extends AOC2022.Base
{

Parameter InputFile = "d22.txt";

// d ##class(AOC2022.Day22).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	set data=..AnalayzeData(.recordsArr,.grid,.rows,.columns)
	set lastX=$list(data,1),path=$list(data,2)
	if verbose zwrite grid,path,rows,columns,lastX,path write $length(path),!
	set lastPos=..MoveOnGrid(.grid,.rows,.columns,path,$list(rows(1),1),1,0)
	if verbose zwrite lastPos
	set answer=($list(lastPos,1)*1000)+($list(lastPos,2)*4)+$list(lastPos,3)
	quit answer
}

ClassMethod MoveOnGrid(ByRef grid, ByRef rows, ByRef columns, path, fromX, fromY, dir, ByRef cubeType)
{
	//dir = 0 - right, 1 - down, 2 - left, 3 - up
	set x=fromX,y=fromY
	for  {
		set len=+path,path=$extract(path,$length(len)+1,*),rotate=$extract(path),$extract(path)=""
		if dir=0 {
			//Move right
			do ..MoveX(.grid,.rows,.columns,.x,.y,1,len,.cubeType,.dir)
		} elseif dir=1 {
			//Move down
			do ..MoveY(.grid,.rows,.columns,.x,.y,1,len,.cubeType,.dir)
		} elseif dir=2 {
			//Move left
			do ..MoveX(.grid,.rows,.columns,.x,.y,-1,len,.cubeType,.dir)
		} elseif dir=3 {
			//Move up
			do ..MoveY(.grid,.rows,.columns,.x,.y,-1,len,.cubeType,.dir)
		}
		quit:'$length(path)
		set dir=dir+$select(rotate="R":1,1:-1)
		set:dir<0 dir=3
		set:dir>3 dir=0
	}
	quit $listbuild(y,x,dir)
}

ClassMethod DisplayGrid(ByRef grid)
{
	Q
	write !!
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		write !,grid(y)
	}
	write !
}

ClassMethod MoveX(ByRef grid, ByRef rows, ByRef columns, ByRef x, ByRef y, dir, len, ByRef cubeType, ByRef currDir)
{
	set row=rows(y),newY=y,newDir=currDir
	for i=1:1:len {
		set inBoundry=0,newX=x+dir
		if newX>=$list(row,1),newX<=$list(row,2) {
			set inBoundry=1
		}
		if 'inBoundry {
			if '$data(cubeType) {
				set newX=$select(dir=1:$list(row,1),1:$list(row,2))	
			} else {
				set data=..SetNewXYDir(x,y,currDir,.cubeType)
				set newY=$list(data,1),newX=$list(data,2),newDir=$list(data,3)
			}
		}
		if $extract(grid(newY),newX)="#" {
			quit
		}
		set $extract(grid(y),x)=$case(currDir,0:">",1:"v",2:"<",3:"^",:".") do ..DisplayGrid(.grid)
		set y=newY,x=newX,currDir=newDir
		if 'inBoundry {
			return ..MoveOutOfBoundry(.grid,.rows,.columns,.x,.y,.currDir,len-i,.cubeType)
		}
	}
	quit x
}

ClassMethod MoveY(ByRef grid, ByRef rows, ByRef columns, ByRef x, ByRef y, dir, len, ByRef cubeType, ByRef currDir)
{
	set column=columns(x)
	set newX=x,newDir=currDir
	for i=1:1:len {
		set inBoundry=0,newY=y+dir
		if newY>=$list(column,1),newY<=$list(column,2) {
			set inBoundry=1
		}
		if 'inBoundry {
			if '$data(cubeType) {
				set newY=$select(dir=1:$list(column,1),1:$list(column,2))
			} else {
				set data=..SetNewXYDir(x,y,currDir,.cubeType)
				//zw data h 5
				set newY=$list(data,1),newX=$list(data,2),newDir=$list(data,3)
			}
		}
		if $extract(grid(newY),newX)="#" {
			quit
		}
		set $extract(grid(y),x)=$case(currDir,0:">",1:"v",2:"<",3:"^",:".") do ..DisplayGrid(.grid)
		set y=newY,x=newX,currDir=newDir
		if 'inBoundry {
			return ..MoveOutOfBoundry(.grid,.rows,.columns,.x,.y,.currDir,len-i,.cubeType)
		}
	}
	quit y
}

ClassMethod MoveOutOfBoundry(ByRef grid, ByRef rows, ByRef columns, ByRef x, ByRef y, ByRef currDir, len, ByRef cubeType)
{
	if currDir=0 {
		//Move right
		return ..MoveX(.grid,.rows,.columns,.x,.y,1,len,.cubeType,.currDir)
	} elseif currDir=1 {
		//Move down
		return ..MoveY(.grid,.rows,.columns,.x,.y,1,len,.cubeType,.currDir)
	} elseif currDir=2 {
		//Move left
		return ..MoveX(.grid,.rows,.columns,.x,.y,-1,len,.cubeType,.currDir)
	} elseif currDir=3 {
		//Move up
		return ..MoveY(.grid,.rows,.columns,.x,.y,-1,len,.cubeType,.currDir)
	}
}

ClassMethod SetNewXYDir(x, y, currDir, ByRef cubeType)
{
	set data=..GetCubeYX(x,y,.cubeType)
	set currCubeY=$list(data,1),currCubeX=$list(data,2)
	set currCubeTypeData=cubeType(currCubeY,currCubeX)
	set currDeltaY=y-$list(cubeType(currCubeY),2),currDeltaX=x-$list(currCubeTypeData,2)
	set newPosData=$list(currCubeTypeData,4+currDir)
	set newDir=$list(newPosData,1),mirror=$list(newPosData,2),newCubeY=$list(newPosData,3),newCubeX=$list(newPosData,4)
	set newCubeTypeYData=cubeType(newCubeY)
	set newCubeTypeXData=cubeType(newCubeY,newCubeX)
	set newY=$select(newDir=1:$list(newCubeTypeYData,2),newDir=3:$list(newCubeTypeYData,3),1:$select(mirror=1:$list(newCubeTypeYData,2)+$select(13[currDir:currDeltaX,1:currDeltaY),1:$list(newCubeTypeYData,3)-$select(13[currDir:currDeltaX,1:currDeltaY)))
	set newX=$select(newDir=0:$list(newCubeTypeXData,2),newDir=2:$list(newCubeTypeXData,3),1:$select(mirror=1:$list(newCubeTypeXData,2)+$select(13[currDir:currDeltaX,1:currDeltaY),1:$list(newCubeTypeXData,3)-$select(13[currDir:currDeltaX,1:currDeltaY)))
	//zw currCubeTypeData,newPosData,newCubeTypeYData,newCubeTypeXData,mirror,x,y,currDir,newY,newX,newDir,currDeltaX,currDeltaY
	quit $listbuild(newY,newX,newDir)
}

ClassMethod GetCubeYX(x, y, ByRef cubeType)
{
	set cubeY=""
	for  {
		set cubeY=$order(cubeType(cubeY)) quit:cubeY=""
		set data=cubeType(cubeY)
		if $list(data,2)<=y,$list(data,3)>=y {
			set cubeX=""
			for  {
				set cubeX=$order(cubeType(cubeY,cubeX)) quit:cubeX=""
				set data=cubeType(cubeY,cubeX)
				if $list(data,2)<=x,$list(data,3)>=x {
					return $lb(cubeY,cubeX)
				}
			}
		}
	}
}

ClassMethod AnalayzeData(ByRef recordsArr, ByRef grid, ByRef rows, ByRef columns, ByRef cubeType)
{
	set line="",state=0,lastX=0,minSize=999
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set end=$length($zstrip(record,">W"))
		if state=0,$length(record) {
			set grid(line)=record
			set start=end-$length($zstrip(record,"*W"))+1
			set rows(line)=$listbuild(start,end)
			set:end>lastX lastX=end
			set size=end-start+1
			set:size<minSize minSize=size
		}
		if state=0,'$length(record) set state=1
		if state=1,$length(record) set path=record,state=2
	}
	for col=1:1:lastX {
		set line=""
		for  {
			set line=$order(rows(line)) quit:line=""
			set data=rows(line)
			if $list(data,1)<=col,$list(data,2)>=col {
				set columns(col)=$listbuild(line)
				quit
			}
		}
		set line=""
		for  {
			set line=$order(rows(line),-1) quit:line=""
			set data=rows(line)
			if $list(data,1)<=col,$list(data,2)>=col {
				set columns(col)=columns(col)_$listbuild(line)
				quit
			}
		}
	}
	do ..CubeOrder(.grid,minSize,lastX,.cubeType)
	quit $listbuild(lastX,path,minSize)
}

ClassMethod CubeOrder(ByRef grid, cubeSize, lastX, ByRef cubeType)
{
	set cntY=0
	for y=1:cubeSize:$order(grid(""),-1) {
		set cntX=0,cntY=cntY+1,cubeType(cntY)="",types=""
		for x=1:cubeSize:lastX {
			set cntX=cntX+1
			set type=$length($translate($extract(grid(y),x)," "))
			set cubeType(cntY,cntX)=$listbuild(type,x,x+cubeSize-1),types=types_type
		}
		set cubeType(cntY)=$listbuild(types,y,y+cubeSize-1)
	}
	do ..LoadTransitions(.cubeType)
}

ClassMethod LoadTransitions(ByRef cubeType)
{
	set lastY=$order(cubeType(""),-1),err=0
	if 'err,lastY'=3,lastY'=4 set err=1
	if 'err,lastY=3,($list(cubeType(1),1)'="0010")||($list(cubeType(2),1)'="1110")||($list(cubeType(3),1)'="0011") set err=1
	if 'err,lastY=4,($list(cubeType(1),1)'="011")||($list(cubeType(2),1)'="010")||($list(cubeType(3),1)'="110")||($list(cubeType(4),1)'="100") set err=1
	if err kill a set a=a //INTENDED BUG FOR UNHANDLED CUBE FOLDING TYPE
	if lastY=3 {  //Small 4x4
		for x=1,2,4 set cubeType(1,x)=cubeType(1,x)_$listbuild("","","","")
		for x=4 set cubeType(2,x)=cubeType(2,x)_$listbuild("","","","")
		for x=1,2 set cubeType(3,x)=cubeType(3,x)_$listbuild("","","","")
		//dir = 0 - right, 1 - down, 2 - left, 3 - up
		//$listbuild(transitionRight,transitionDown,transitionLeft,transitionUp)....transition=$listbuild(newDir,1/-1,CubeTypeY,CubeTypeX)...1 - same pos, -1 - mirror pos
		set cubeType(1,3)=cubeType(1,3)_$listbuild($listbuild(2,-1,3,4),"",$listbuild(1,1,2,2),$listbuild(1,-1,2,1))
		set cubeType(2,1)=cubeType(2,1)_$listbuild("",$listbuild(3,-1,3,3),$listbuild(3,-1,3,4),$listbuild(1,-1,1,3))
		set cubeType(2,2)=cubeType(2,2)_$listbuild("",$listbuild(0,-1,3,3),"",$listbuild(0,1,1,3))
		set cubeType(2,3)=cubeType(2,3)_$listbuild($listbuild(1,-1,3,4),"","","")
		set cubeType(3,3)=cubeType(3,3)_$listbuild("",$listbuild(3,-1,2,1),$listbuild(3,-1,2,2),"")
		set cubeType(3,4)=cubeType(3,4)_$listbuild($listbuild(2,-1,1,3),$listbuild(0,-1,2,1),"",$listbuild(2,-1,2,3))
	}
	if lastY=4 {  //Big 50x50
		for x=1 set cubeType(1,x)=cubeType(1,x)_$listbuild("","","","")
		for x=1,3 set cubeType(2,x)=cubeType(2,x)_$listbuild("","","","")
		for x=3 set cubeType(3,x)=cubeType(3,x)_$listbuild("","","","")
		for x=2,3 set cubeType(4,x)=cubeType(4,x)_$listbuild("","","","")
		//dir = 0 - right, 1 - down, 2 - left, 3 - up
		//$listbuild(transitionRight,transitionDown,transitionLeft,transitionUp)....transition=$listbuild(newDir,1/-1,CubeTypeY,CubeTypeX)...1 - same pos, -1 - mirror pos
		set cubeType(1,2)=cubeType(1,2)_$listbuild("","",$listbuild(0,-1,3,1),$listbuild(0,1,4,1))
		set cubeType(1,3)=cubeType(1,3)_$listbuild($listbuild(2,-1,3,2),$listbuild(2,1,2,2),"",$listbuild(3,1,4,1))
		set cubeType(2,2)=cubeType(2,2)_$listbuild($listbuild(3,1,1,3),"",$listbuild(1,1,3,1),"")
		set cubeType(3,1)=cubeType(3,1)_$listbuild("","",$listbuild(0,-1,1,2),$listbuild(0,1,2,2))
		set cubeType(3,2)=cubeType(3,2)_$listbuild($listbuild(2,-1,1,3),$listbuild(2,1,4,1),"","")
		set cubeType(4,1)=cubeType(4,1)_$listbuild($listbuild(3,1,3,2),$listbuild(1,1,1,3),$listbuild(1,1,1,2),"")
	}
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer=""
	set data=..AnalayzeData(.recordsArr,.grid,.rows,.columns,.cubeType)
	set lastX=$list(data,1),path=$list(data,2),size=$list(data,3)
	if verbose zwrite grid,path,rows,columns,lastX,path,size,cubeType write $length(path),!
	set lastPos=..MoveOnGrid(.grid,.rows,.columns,path,$list(rows(1),1),1,0,.cubeType)
	if verbose zwrite lastPos
	set answer=($list(lastPos,1)*1000)+($list(lastPos,2)*4)+$list(lastPos,3)
	quit answer
}

}

