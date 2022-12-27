Class AOC2022.Day18 Extends AOC2022.Base
{

Parameter InputFile = "d18.txt";

// d ##class(AOC2022.Day18).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set grid($piece(record,",",1),$piece(record,",",2),$piece(record,",",3))=6
	}
	set x="",counter=0
	for  {
		set x=$order(grid(x)) quit:x=""
		set y=""
		for  {
			set y=$order(grid(x,y)) quit:y=""
			set z=""
			for  {
				set z=$order(grid(x,y,z)) quit:z=""
				set exposed=grid(x,y,z)
				if $data(grid(x-1,y,z)) set exposed=exposed-1
				if $data(grid(x+1,y,z)) set exposed=exposed-1
				if $data(grid(x,y+1,z)) set exposed=exposed-1
				if $data(grid(x,y-1,z)) set exposed=exposed-1
				if $data(grid(x,y,z+1)) set exposed=exposed-1
				if $data(grid(x,y,z-1)) set exposed=exposed-1
				set grid(x,y,z)=exposed
				set counter=counter+exposed
			}
		}
	}
	set answer=counter
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
		set answer="",line="",(minX,minY,minZ)=99999999,(maxX,maxY,maxZ)=-minX
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set x=$piece(record,",",1),y=$piece(record,",",2),z=$piece(record,",",3)
		set minX=..Min(x,minX),maxX=..Max(x,maxX)
		set minY=..Min(y,minY),maxY=..Max(y,maxY)
		set minZ=..Min(z,minZ),maxZ=..Max(z,maxZ)
		set grid(x,y,z)=1 //laba
	}
	//zw grid
	set counter=..Part1()
	set from=..Min(..Min(minX,minY),minZ)-1
	set to=..Max(..Max(maxX,maxY),maxZ)+1
	set grid(from,from,from)=-1 //flowing
	for x=from:1:to {
		for y=from:1:to {
			for z=from:1:to {
				continue:$get(grid(x,y,z))  //laba or flowing
				set grid(x,y,z)=0 //empty
			}
		}
	}
	do {
		set changed=0
		for x=from:1:to {
			for y=from:1:to {
				for z=from:1:to {
					continue:grid(x,y,z)'=-1  //check the flowings
					if x-1>=from,'grid(x-1,y,z) set grid(x-1,y,z)=-1,changed=1
					if x+1<=to,'grid(x+1,y,z) set grid(x+1,y,z)=-1,changed=1
					if y-1>=from,'grid(x,y-1,z) set grid(x,y-1,z)=-1,changed=1
					if y+1<=to,'grid(x,y+1,z) set grid(x,y+1,z)=-1,changed=1
					if z-1>=from,'grid(x,y,z-1) set grid(x,y,z-1)=-1,changed=1
					if z+1<=to,'grid(x,y,z+1) set grid(x,y,z+1)=-1,changed=1
				}
			}
		}
	} while changed
	for x=from:1:to {
		for y=from:1:to {
			for z=from:1:to {
				if 'grid(x,y,z) { //empty
					if $get(grid(x-1,y,z))=1 set counter=counter-1
					if $get(grid(x+1,y,z))=1 set counter=counter-1
					if $get(grid(x,y-1,z))=1 set counter=counter-1
					if $get(grid(x,y+1,z))=1 set counter=counter-1
					if $get(grid(x,y,z-1))=1 set counter=counter-1
					if $get(grid(x,y,z+1))=1 set counter=counter-1
				}
			}
		}
	}
	set answer=counter
	quit answer
}

ClassMethod Min(Val1 As %Integer, Val2 As %Integer) As %Integer [ Private ]
{
	if Val1<Val2 quit Val1
	quit Val2
}

ClassMethod Max(Val1 As %Integer, Val2 As %Integer) As %Integer [ Private ]
{
	if Val1>Val2 quit Val1
	quit Val2
}

}

