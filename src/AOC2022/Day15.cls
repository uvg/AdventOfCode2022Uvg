Class AOC2022.Day15 Extends AOC2022.Base
{

Parameter InputFile = "d15.txt";

// d ##class(AOC2022.Day15).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line="",(minX,minY)=999999999,(maxX,maxY)=-minX,maxDist=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set sensorX=+$piece(record,"x=",2),sensorY=+$piece(record,"y=",2),beaconX=+$piece(record,"x=",3),beaconY=+$piece(record,"y=",3)
		set dist=$zabs(sensorX-beaconX)+$zabs(sensorY-beaconY)
		set sensorArr($increment(sensorArr))=$listbuild(sensorY,sensorX,beaconY,beaconX,dist)
		set:sensorX<minX minX=sensorX
		set:sensorY<minY minY=sensorY
		set:sensorX>maxX maxX=sensorX
		set:sensorY>maxY maxY=sensorY
		set:beaconX<minX minX=beaconX
		set:beaconY<minY minY=beaconY
		set:beaconX>maxX maxX=beaconX
		set:beaconY>maxY maxY=beaconY
		set:dist>maxDist maxDist=dist
		set beaconsArr(beaconY,beaconX)=""
		set grid(sensorY,sensorX)="S"
		set grid(beaconY,beaconX)="B"
	}
	if verbose zwrite maxDist,minX,minY,maxX,maxY,sensorArr //,grid
	set test=sensorArr<15
	set findY=$select(test:10,1:2000000)
	if verbose,test {
		for x=minX:1:maxX {
			for y=minY:1:maxY {
				continue:$data(grid(y,x))
				set grid(y,x)="."
				set sensor=""
				for {
					set sensor=$order(sensorArr(sensor)) quit:sensor=""
					set data=sensorArr(sensor)
					set sensorY=$list(data,1),sensorX=$list(data,2),dist=$list(data,5)
					if $zabs(sensorX-x)+$zabs(sensorY-y)<=dist {
						set grid(y,x)="#"
						quit
					}
				}
			}
		}
		do ..GridDisplay(.grid)
	}
	set sensor="",counter=0
	for  {
		set sensor=$order(sensorArr(sensor)) quit:sensor=""
		//set sensorArr($increment(sensorArr))=$listbuild(sensorY,sensorX,beaconY,beaconX,dist)
		set data=sensorArr(sensor)
		set sensorY=$list(data,1),sensorX=$list(data,2),beaconY=$list(data,3),beaconX=$list(data,4),dist=$list(data,5)
		/*
		for findX=minX:1:maxX {
			continue:$data(beaconsArr(findY,findX))
			continue:$data(findArr(findY,findX))
			continue:$zabs(sensorX-findX)+$zabs(sensorY-findY)>dist
			set counter=counter+1
			if $increment(findArr(findY,findX))
		}*/
		for findX=sensorX-dist:1:sensorX+dist {
			continue:$data(beaconsArr(findY,findX))
			continue:$data(findArr(findY,findX))
			continue:$zabs(sensorX-findX)+$zabs(sensorY-findY)>dist
			set counter=counter+1
			set findArr(findY,findX)=""
		}
	}
	if verbose,test write ! zwrite findArr
	set answer=counter
	quit answer
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
	
	set answer="",line="",(minX,minY)=999999999,(maxX,maxY)=-minX,maxDist=0
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set sensorX=+$piece(record,"x=",2),sensorY=+$piece(record,"y=",2),beaconX=+$piece(record,"x=",3),beaconY=+$piece(record,"y=",3)
		set dist=$zabs(sensorX-beaconX)+$zabs(sensorY-beaconY)
		set sensorArr($increment(sensorArr))=$listbuild(sensorY,sensorX,beaconY,beaconX,dist)
		set:sensorX<minX minX=sensorX
		set:sensorY<minY minY=sensorY
		set:sensorX>maxX maxX=sensorX
		set:sensorY>maxY maxY=sensorY
		set:beaconX<minX minX=beaconX
		set:beaconY<minY minY=beaconY
		set:beaconX>maxX maxX=beaconX
		set:beaconY>maxY maxY=beaconY
		set:dist>maxDist maxDist=dist
		set beaconsArr(beaconY,beaconX)=""
		set grid(sensorY,sensorX)="S"
		set grid(beaconY,beaconX)="B"
	}
	if verbose zwrite maxDist,minX,minY,maxX,maxY,sensorArr //,grid
	set test=sensorArr<15
	if verbose,test {
		for x=minX:1:maxX {
			for y=minY:1:maxY {
				continue:$data(grid(y,x))
				set grid(y,x)="."
				set sensor=""
				for {
					set sensor=$order(sensorArr(sensor)) quit:sensor=""
					set data=sensorArr(sensor)
					set sensorY=$list(data,1),sensorX=$list(data,2),dist=$list(data,5)
					if $zabs(sensorX-x)+$zabs(sensorY-y)<=dist {
						set grid(y,x)="#"
						quit
					}
				}
			}
		}
		do ..GridDisplay(.grid)
	}
	set answer=0
	/*
	//Looking for 4000000*4000000 will take for ever
	for findX=0:1:findSize {
		for findY=0:1:findSize {
			continue:$data(beaconsArr(findY,findX))
			set sensor="",found=0
			for  {
				set sensor=$order(sensorArr(sensor)) quit:sensor=""
				set data=sensorArr(sensor)
				set sensorY=$list(data,1),sensorX=$list(data,2),beaconY=$list(data,3),beaconX=$list(data,4),dist=$list(data,5)
				if $zabs(sensorY-findY)+$zabs(sensorX-findX)<=dist {
					set found=1
					quit
				}
			}
			if 'found {
				set answer=4000000*findX+findY
				quit
			}
		}
		quit:answer
	}
	*/
	set sensor="",findSize=$select(test:20,1:4000000)
	for  {
		set sensor=$order(sensorArr(sensor)) quit:sensor=""
		set data=sensorArr(sensor)
		set sensorY=$list(data,1),sensorX=$list(data,2),dist=$list(data,5)
		for tempDist=0:1:dist {
			//
			//Left-Top
			set x=sensorX-dist-1+tempDist,y=sensorY-tempDist
			set answer=..GetFreq(x,y,findSize,.sensorArr)
			quit:answer
			//
			//Right-Top
			set x=sensorX+dist+1-tempDist,y=sensorY-tempDist
			set answer=..GetFreq(x,y,findSize,.sensorArr)
			quit:answer
			//
			//Left-Bottom
			set x=sensorX-dist-1+tempDist,y=sensorY+tempDist
			set answer=..GetFreq(x,y,findSize,.sensorArr)
			quit:answer
			//
			//Right-Bottom
			set x=sensorX+dist+1-tempDist,y=sensorY+tempDist
			set answer=..GetFreq(x,y,findSize,.sensorArr)
			quit:answer
		}
		quit:answer
	}
	quit answer
}

ClassMethod GetFreq(x As %Integer, y As %Integer, findSize As %Integer, ByRef sensorArr) As %Integer
{
	quit:x<0 0
	quit:x>findSize 0
	quit:y<0 0
	quit:y>findSize 0
	quit:'..IsVisible(.sensorArr,x,y) 4000000*x+y
	quit 0
}

ClassMethod IsVisible(ByRef sensorArr, x As %Integer, y As %Integer) As %Boolean
{
	set sensor=""
	for  {
		set sensor=$order(sensorArr(sensor)) quit:sensor=""
		set data=sensorArr(sensor)
		set sensorY=$list(data,1),sensorX=$list(data,2),dist=$list(data,5)
		if $zabs(sensorY-y)+$zabs(sensorX-x)<=dist {
			return 1
		}
	}
	quit 0
}

}

