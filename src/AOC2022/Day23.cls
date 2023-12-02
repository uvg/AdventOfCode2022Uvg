Class AOC2022.Day23 Extends AOC2022.Base
{

Parameter InputFile = "d23.txt";

// d ##class(AOC2022.Day23).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set grid(line)=record
	}
	set dir="NSWE"
	for turn=1:1 {
		//write !,dir
		if verbose write !,turn
		quit:'..Move(.grid,dir)
		quit:turn=10
		set dir=dir_$extract(dir),$extract(dir)=""
	}
	if verbose write !! zwrite grid
	do ..CompressGrid(.grid)
	if verbose write !! zwrite grid
	set answer=..GetEmptyGround(.grid)
	quit answer
}

ClassMethod GetEmptyGround(ByRef grid)
{
	set y="",total=0
	for  {
		set y=$order(grid(y)) quit:y=""
		set data=grid(y)
		set total=total+$length($translate(grid(y),"#"))
	}
	quit total
}

ClassMethod Move(ByRef grid, dir)
{
	do ..ChangeGrid(.grid)
	merge newGrid=grid
	set y="",sw=0
	for  {
		set y=$order(grid(y)) quit:y=""
		set data=grid(y)
		for x=1:1:$length(data) {
			continue:$extract(data,x)'="#"
			set ans=..MaybeMove(.grid,y,x,dir)
			continue:'$length($list(ans,1))
			set to($list(ans,2),$list(ans,3),y,x)="",sw=1
		}
	}
	//zwrite grid //,to
	quit:'sw 0
	set newY="",sw=0
	for  {
		set newY=$order(to(newY)) quit:newY=""
		set newX=""
		for  {
			set newX=$order(to(newY,newX)) quit:newX=""
			set oldY=$order(to(newY,newX,""))
			continue:$order(to(newY,newX,""),-1)'=oldY
			set oldX=$order(to(newY,newX,oldY,""))
			continue:$order(to(newY,newX,oldY,""),-1)'=oldX
			set sw=1
			set $extract(newGrid(newY),newX)="#"
			set $extract(newGrid(oldY),oldX)="."
		}
	}
	kill grid merge grid=newGrid
	quit sw
}

ClassMethod ChangeGrid(ByRef grid)
{
	merge newGrid=grid
	do ..CompressGrid(.newGrid)
	set y=$order(newGrid("")),len=$length(newGrid(y)),data=$translate($justify("",len)," ",".")
	set newGrid(y-1)=data
	set y=$order(newGrid(""),-1)
	set newGrid(y+1)=data
	set y=""
	for  {
		set y=$order(newGrid(y)) quit:y=""
		set newGrid(y)="."_newGrid(y)_"."
	}
	kill grid merge grid=newGrid
}

ClassMethod CompressGrid(ByRef grid)
{
	do ..CompressGridUpDown(.grid)
	do ..CompressGridLeftRight(.grid)
}

ClassMethod CompressGridUpDown(ByRef grid)
{
	//Compress up
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		quit:$length($translate(grid(y),"."))
	}
	set tempY=y
	for  {
		set tempY=$order(grid(tempY),-1) quit:tempY=""
		kill grid(tempY)
	}
	//
	//Compress Down
	set y=""
	for  {
		set y=$order(grid(y),-1) quit:y=""
		quit:$length($translate(grid(y),"."))
	}
	set tempY=y
	for  {
		set tempY=$order(grid(tempY)) quit:tempY=""
		kill grid(tempY)
	}
}

ClassMethod CompressGridLeftRight(ByRef grid)
{
	//Find min,max X
	set minX=99,maxX=0
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		set data=grid(y)
		for x=1:1:$length(data) {
			quit:$extract(data,x)="#"
		}
		set:x<minX minX=x
		for x=$length(data):-1:1 {
			quit:$extract(data,x)="#"
		}
		set:x>maxX maxX=x
	}
	//
	//Compress left,right
	set y=""
	for  {
		set y=$order(grid(y)) quit:y=""
		set grid(y)=$extract(grid(y),minX,maxX)
	}
}

ClassMethod MaybeMove(ByRef grid, y, x, dir)
{
	set sw=0
	for tempX=x-1:1:x+1 {
		for tempY=y-1:1:y+1 {
			if (x'=tempX)||(y'=tempY),$extract($get(grid(tempY)),tempX)="#" set sw=1
			quit:sw
		}
		quit:sw
	}
	quit:'sw $listbuild("",y,x)  //nothing around so not moving
	set dirs("N")=$listbuild($listbuild(-1,-1),$listbuild(-1,0),$listbuild(-1,1),$listbuild(-1,0))
	set dirs("S")=$listbuild($listbuild(1,-1),$listbuild(1,0),$listbuild(1,1),$listbuild(1,0))
	set dirs("W")=$listbuild($listbuild(-1,-1),$listbuild(0,-1),$listbuild(1,-1),$listbuild(0,-1))
	set dirs("E")=$listbuild($listbuild(-1,1),$listbuild(0,1),$listbuild(1,1),$listbuild(0,1))
	for i=1:1:$length(dir) {
		set sw=0
		set newDir=$extract(dir,i)
		set diffs=dirs(newDir)
		for j=1:1:3 {
			set data=$list(diffs,j)
			set tempY=$list(data,1),tempX=$list(data,2)
			if $extract($get(grid(y+tempY)),x+tempX)="#" set sw=1
			quit:sw
		}
		continue:sw
		return $listbuild(newDir,y+$list($list(diffs,4),1),x+$list($list(diffs,4),2))
	}
	quit $listbuild("",y,x)  //no place to move, so not moving
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set grid(line)=record
	}
	set dir="NSWE"
	for turn=1:1 {
		//write !,dir
		if verbose write !,turn
		quit:'..Move(.grid,dir)
		set dir=dir_$extract(dir),$extract(dir)=""
	}
	if verbose write !! zwrite grid
	set answer=turn
	quit answer
}

}

