Class AOC2022.Day20 Extends AOC2022.Base
{

Parameter InputFile = "d20.txt";

// d ##class(AOC2022.Day20).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set answer="",line="",lastLine=+$order(recordsArr(""),-1),line0=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set value=+record
		set vc=$listbuild(+line,value)
		set prevLine=line-1,nextLine=line+1
		set:'prevLine prevLine=+lastLine
		set:nextLine>lastLine nextLine=1
		set vp=$listbuild(prevLine,+recordsArr(prevLine)),vn=$listbuild(nextLine,+recordsArr(nextLine))
		set circArr(vc)=$listbuild(vp,vn)
		if 'value set line0=+line
	}
	if verbose write !,"before: ",! zwrite circArr
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set vc=$listbuild(+line,+recordsArr(line)),value=$list(vc,2)
		continue:'value
		set dir=$select(value<0:-1,1:1)
		for i=dir:dir:value {
			set dvc=circArr(vc)
			set vp=$list(dvc,1),vn=$list(dvc,2)
			set dvp=circArr(vp),dvn=circArr(vn)
			set vpp=$list(dvp,1),vnn=$list(dvn,2)
			set dvpp=circArr(vpp),dvnn=circArr(vnn)
			set $list(dvp,2)=vn,$list(dvn,1)=vp //Connect between next and prev
			set:dir=1 $list(dvn,2)=vc,$list(dvc,1)=vn,$list(dvc,2)=vnn,$list(dvnn,1)=vc
			set:dir=-1 $list(dvp,1)=vc,$list(dvc,2)=vp,$list(dvc,1)=vpp,$list(dvpp,2)=vc
			set circArr(vc)=dvc,circArr(vp)=dvp,circArr(vn)=dvn,circArr(vnn)=dvnn,circArr(vpp)=dvpp
		}
	}
	if verbose write !!,"after: ",! zwrite circArr
	set sum=0,vc=$listbuild(+line0,0)
	for i=1:1:3000 {
		set dvc=circArr(vc),vc=$list(dvc,2) 
		if '(i#1000) {
			set sum=sum+$list(vc,2)
			if verbose write !,i,"=",vc,";",sum
		}
	}
	set answer=sum
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set key=811589153
	set answer="",line="",lastLine=+$order(recordsArr(""),-1),line0=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set value=record*key
		set vc=$listbuild(+line,value)
		set prevLine=line-1,nextLine=line+1
		set:'prevLine prevLine=+lastLine
		set:nextLine>lastLine nextLine=1
		set vp=$listbuild(prevLine,+recordsArr(prevLine)*key),vn=$listbuild(nextLine,+recordsArr(nextLine)*key)
		set circArr(vc)=$listbuild(vp,vn)
		if 'value set line0=+line
	}
	if verbose write !,"before: ",! zwrite circArr
	for turn=1:1:10 {
		if verbose write !,"turn #",turn
		set line=""
		for {
			set line=$order(recordsArr(line)) quit:line=""
			set vc=$listbuild(+line,+recordsArr(line)*key),value=$list(vc,2)
			continue:'(value#(lastLine-1))
			set dir=$select(value<0:-1,1:1)
			set value=$zabs(value)#(lastLine-1)*dir
			set dvc=circArr(vc),nv=vc
			for i=dir:dir:value {
				set dnv=circArr(nv)
				set nv=$select(dir=-1:$list(dnv,1),1:$list(dnv,2))
				set vp=$list(dvc,1),vn=$list(dvc,2)
				set dvp=circArr(vp),dvn=circArr(vn)
				set vpp=$list(dvp,1),vnn=$list(dvn,2)
				set dvpp=circArr(vpp),dvnn=circArr(vnn)
				set $list(dvp,2)=vn,$list(dvn,1)=vp //Connect between next and prev
				set:dir=1 $list(dvn,2)=vc,$list(dvc,1)=vn,$list(dvc,2)=vnn,$list(dvnn,1)=vc
				set:dir=-1 $list(dvp,1)=vc,$list(dvc,2)=vp,$list(dvc,1)=vpp,$list(dvpp,2)=vc
				set circArr(vc)=dvc,circArr(vp)=dvp,circArr(vn)=dvn,circArr(vnn)=dvnn,circArr(vpp)=dvpp
			}
		}
	}
	if verbose write !!,"after: ",! zwrite circArr
	set sum=0,vc=$listbuild(+line0,0)
	for i=1:1:3000 {
		set dvc=circArr(vc),vc=$list(dvc,2) 
		if '(i#1000) {
			set sum=sum+$list(vc,2)
			if verbose write !,i,"=",vc,";",sum
		}
	}
	set answer=sum
	quit answer
}

}

