Class AOC2022.Day09 Extends AOC2022.Base
{

Parameter InputFile = "d09.txt";

// d ##class(AOC2022.Day09).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	set answer="",line="",(hX,hY,tX,tY)=0,posT(tX,tY)=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set dir=$extract(record,1),size=$piece(record," ",2)
		if verbose write !,line,"=",dir,",",size
		for i=1:1:size {
			set hX=$select(dir="L":hX-1,dir="R":hX+1,1:hX)
			set hY=$select(dir="U":hY-1,dir="D":hY+1,1:hY)
			if ($zabs(hX-tX)>1)||($zabs(hY-tY)>1) {
				if hX=tX {
					set tY=$select(dir="U":tY-1,dir="D":tY+1,1:tY)
				} elseif hY=tY {
					set tX=$select(dir="L":tX-1,dir="R":tX+1,1:tX)
				} else {
					if ($zabs(hX-tX-1)<=1),($zabs(hY-tY-1)<=1) {
						set tX=tX+1,tY=tY+1
					} elseif ($zabs(hX-tX+1)<=1),($zabs(hY-tY+1)<=1) {
						set tX=tX-1,tY=tY-1
					}
					 elseif ($zabs(hX-tX+1)<=1),($zabs(hY-tY-1)<=1) {
						 set tX=tX-1,tY=tY+1
					} else {
						set tX=tX+1,tY=tY-1
					}
				}
				set posT(tX,tY)=""
			}
		}
	}
	if verbose write ! zwrite posT
	set counter=0
	set tX="" for  {
		set tX=$order(posT(tX)) quit:tX=""
		set tY="" for  {
			set tY=$order(posT(tX,tY)) quit:tY=""
			set counter=counter+1
		}
	}
	set answer=counter
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	for type=0:1:9 {
		set pos(type)=$listbuild(0,0)
	}
	set pos(9,0,0)=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set dir=$extract(record,1),size=$piece(record," ",2)
		if verbose write !,line,"=",dir,",",size
		for i=1:1:size {
			set type=0,hX=$list(pos(type),1),hY=$list(pos(type),2)
			set hX=$select(dir="L":hX-1,dir="R":hX+1,1:hX)
			set hY=$select(dir="U":hY-1,dir="D":hY+1,1:hY)
			set pos(type)=$listbuild(hX,hY)
			for type=1:1:9 {
				set hX=$list(pos(type-1),1),hY=$list(pos(type-1),2)
				set tX=$list(pos(type),1),tY=$list(pos(type),2)
				if ($zabs(hX-tX)>1)||($zabs(hY-tY)>1) {
					if hX=tX {
						set tY=$select(hY>tY:tY+1,1:tY-1)
					} elseif hY=tY {
						set tX=$select(hX>tX:tX+1,1:tX-1)
					} else {
						if ($zabs(hX-tX-1)<=1),($zabs(hY-tY-1)<=1) {
							set tX=tX+1,tY=tY+1
						} elseif ($zabs(hX-tX+1)<=1),($zabs(hY-tY+1)<=1) {
							set tX=tX-1,tY=tY-1
						}
						 elseif ($zabs(hX-tX+1)<=1),($zabs(hY-tY-1)<=1) {
							 set tX=tX-1,tY=tY+1
						} else {
							set tX=tX+1,tY=tY-1
						}
					}
					set pos(type)=$listbuild(tX,tY)
					set:type=9 pos(type,tX,tY)=""
				}
			}
		}
	}
	if verbose write ! zwrite pos
	set counter=0
	set tX="" for  {
		set tX=$order(pos(9,tX)) quit:tX=""
		set tY="" for  {
			set tY=$order(pos(9,tX,tY)) quit:tY=""
			set counter=counter+1
		}
	}
	set answer=counter
	quit answer
}

}

