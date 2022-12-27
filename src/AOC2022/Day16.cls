Class AOC2022.Day16 Extends AOC2022.Base
{

Parameter InputFile = "d16.txt";

// d ##class(AOC2022.Day16).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)

	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set from=$piece(record," ",2),rate=+$piece(record,"=",2),toValves=$select(record["valves ":$piece(record,"valves ",2),1:$piece(record,"valve ",2))
		set to=""
		for pos=1:1:$length(toValves,", ") {
			set toValve=$piece(toValves,", ",pos)
			set to=to_$listbuild(toValve)
		}
		set valvesArr(from)=$listbuild(rate,to)
	}
	if verbose zwrite valvesArr
	set path=$listbuild("AA")
	set answer=..FindShortestPathPriorityQueue(.valvesArr,"AA",0,.path,30,verbose)
	quit answer
}

ClassMethod FindShortestPathPriorityQueue(ByRef arr, from As %String, steps As %Integer = 0, path As %String = "", maxsteps As %Integer = 0, verbose As %Boolean)
{
	//..FindShortestPathPriorityQueue(.arr,"AA",0,,,30) from "AA" to "BB" with initial steps of 0 and maxsteps of 30
	//arr(from)=$listbuild(rate,to)
	if maxsteps,steps>maxsteps quit 999999
	kill ^||Queue,^||cachedArr
	set ^||Queue(0,$increment(^||Queue))=$listbuild(steps,path,$list(arr(from),1),"",from),maxFlow=0,maxPath="",best=0,lastbest=best
	
	for  {
		//write !!!! zwrite ^||Queue //hang 1
		set flow=$order(^||Queue("")) quit:'$length(flow)
		set:flow<best best=flow
		if lastbest'=best {
			set lastbest=best
			if verbose write !,best
		}
		set cnt="",lastCount=$order(^||Queue(flow,""),-1)
		for  {
			//write ! zwrite ^||Queue hang 1
			set cnt=$order(^||Queue(flow,cnt)) quit:cnt=""
			do ..SetQueueForAllLevel(.arr,flow,cnt,.maxFlow,maxsteps)
			quit:maxFlow
			quit:cnt>lastCount
		}
	}
	kill ^||Queue,^||cachedArr
	quit maxFlow
}

ClassMethod SetQueueForAllLevel(ByRef arr, flow As %Integer, cnt As %Integer, ByRef maxFlow As %Integer, maxsteps As %Integer)
{
	//^||Queue(flow,cnt)=$listbuild(steps,myPath,rate,opened,myPos,elephantPos,elephantPath)
	set data=^||Queue(flow,cnt)
	set steps=$list(data,1),myPath=$list(data,2),flowPerMinute=$list(data,3),opened=$list(data,4),myPos=$list(data,5),elephantPos=$listget(data,6),elephantPath=$listget(data,7)
	//write !! zwrite myPos,elephantPos,steps,myPath,elephantPath,flowPerMinute,^||Queue
	kill ^||Queue(flow,cnt)
	if '$length($order(^||Queue(flow,""))) kill ^||Queue(flow)
	if maxsteps,steps>maxsteps quit
	if maxsteps,steps=maxsteps {
		if -flow>maxFlow set maxFlow=-flow
		//write !! zwrite myPos,elephantPos,steps,myPath,elephantPath,flowPerMinute,maxFlow,^||Queue h 1
		quit
	}
	quit:..IsAllOpen(.arr,opened)
	set:'$length(elephantPos) elephantPos=" "
	//if $data(^||cachedArr(steps,myPos,flowPerMinute,elephantPos)),^||cachedArr(steps,myPos,flowPerMinute,elephantPos)<=flow quit
	//set ^||cachedArr(steps,myPos,flowPerMinute,elephantPos)=flow
	set combinedPos=$listbuild(myPos_elephantPos)
	set:myPos]]elephantPos combinedPos=$listbuild(elephantPos_myPos)
	if $data(^||cachedArr(steps,combinedPos,flowPerMinute)),^||cachedArr(steps,combinedPos,flowPerMinute)<=flow quit
	set ^||cachedArr(steps,combinedPos,flowPerMinute)=flow
	//
	//part1
	if $length(elephantPos)<2 {
		set from=myPos
		set data=arr(from)
		set rate=$list(data,1),toValves=$list(data,2),isOpened=$listfind(opened,from)
		set addedFlow=rate*(maxsteps-1-steps)
		set newFlow=flow-$select(isOpened:0,1:addedFlow)
		set newFlowPerMinute=flowPerMinute+rate //If I'll open it
		for pos=1:1:$listlength(toValves) {
			set to=$list(toValves,pos)
			set ^||Queue(flow,$increment(^||Queue))=$listbuild(steps+1,myPath_$listbuild(to),flowPerMinute,opened,to) //move without open
			if 'isOpened,addedFlow {
				set ^||Queue(newFlow,$increment(^||Queue))=$listbuild(steps+2,myPath_$listbuild(to),newFlowPerMinute,opened_$listbuild(from),to) //open only if there's a flow rate and move
			}
}
		quit
	}
	//
	//part2
	set data=arr(myPos)
	set myRate=$list(data,1),myToValves=$list(data,2),myIsOpened=$listfind(opened,myPos)
	set myAddedFlow=myRate*(maxsteps-1-steps)
	set data=arr(elephantPos)
	set elRate=$list(data,1),elToValves=$list(data,2),elIsOpened=$listfind(opened,elephantPos)
	set elAddedFlow=elRate*(maxsteps-1-steps)
	;
	set myCanOpen=myRate&&'myIsOpened
	set elCanOpen=elRate&&'elIsOpened
	set newSteps=steps+1
	;
	//^||Queue(flow,cnt)=$listbuild(steps,myPath,rate,opened,myPos,elephantPos,elephantPath)
	if myCanOpen {
		//Open my valve & move the elephant
		set toValves=elToValves,addedFlow=myAddedFlow,rate=myRate,location=myPos
		set newFlow=flow-addedFlow,newFlowRatePerMinute=flowPerMinute+rate
		for pos=1:1:$listlength(toValves) {
			set to=$list(toValves,pos)
			set ^||Queue(newFlow,$increment(^||Queue))=$listbuild(newSteps,myPath,newFlowRatePerMinute,opened_$listbuild(location),location,to,elephantPath_$listbuild(to))
		}
	}
	if elCanOpen {
		//Open elephant's valve & i'm moving
		set toValves=myToValves,addedFlow=elAddedFlow,rate=elRate,location=elephantPos
		set newFlow=flow-addedFlow,newFlowRatePerMinute=flowPerMinute+rate
		for pos=1:1:$listlength(toValves) {
			set to=$list(toValves,pos)
			set ^||Queue(newFlow,$increment(^||Queue))=$listbuild(newSteps,myPath_$listbuild(to),newFlowRatePerMinute,opened_$listbuild(location),to,location,elephantPath)
		}
	}
	if myCanOpen,elCanOpen,myPos'=elephantPos {
		//We both open valves without moving
		set addedFlow=elAddedFlow+myAddedFlow,rate=elRate+myRate
		set newFlow=flow-addedFlow,newFlowRatePerMinute=flowPerMinute+rate
		set ^||Queue(newFlow,$increment(^||Queue))=$listbuild(newSteps,myPath,newFlowRatePerMinute,opened_$listbuild(myPos,elephantPos),myPos,elephantPos,elephantPath)
	}
	//
	//We both move without openeing valves
	for pos1=1:1:$listlength(myToValves) {
		set myTo=$list(myToValves,pos1)
		for pos2=1:1:$listlength(elToValves) {
			set elTo=$list(elToValves,pos2)
			set ^||Queue(flow,$increment(^||Queue))=$listbuild(newSteps,myPath_$listbuild(myTo),flowPerMinute,opened,myTo,elTo,elephantPath_$listbuild(elTo))
		}
	}
}

ClassMethod IsAllOpen(ByRef arr, opened As %Integer)
{
	//arr(from)=$listbuild(rate,to)
	set from=""
	for  {
		set from=$order(arr(from)) quit:from=""
		if $length(arr(from),1),'$listfind(opened,from) return 0
	}
	quit 1
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		set from=$piece(record," ",2),rate=+$piece(record,"=",2),toValves=$select(record["valves ":$piece(record,"valves ",2),1:$piece(record,"valve ",2))
		set to=""
		for pos=1:1:$length(toValves,", ") {
			set toValve=$piece(toValves,", ",pos)
			set to=to_$listbuild(toValve)
		}
		set valvesArr(from)=$listbuild(rate,to)
	}
	if verbose zwrite valvesArr
	set path=$listbuild("AA")
	set answer=..FindShortestPathPriorityQueue2(.valvesArr,"AA","AA",0,.path,26,verbose)
	quit answer
}

ClassMethod FindShortestPathPriorityQueue2(ByRef arr, from As %String, elephant As %String, steps As %Integer = 0, ByRef path As %String = "", maxsteps As %Integer = 0, verbose As %Boolean)
{
	//..FindShortestPathPriorityQueue(.arr,"AA",0,,,30) from "AA" to "BB" with initial steps of 0 and maxsteps of 30
	//arr(from)==$listbuild(rate,to)
	if maxsteps,steps>maxsteps quit 999999
	kill ^||Queue,^||cachedArr
	set ^||Queue(0,$increment(^||Queue))=$listbuild(steps,path,$list(arr(from),1),"",from,elephant,""),maxFlow=0,maxPath="",best=0,lastbest=best
	
	for  {
		//write !!!! zwrite ^||Queue //hang 1
		set flow=$order(^||Queue("")) quit:'$length(flow)
		set:flow<best best=flow
		if lastbest'=best {
			set lastbest=best
			if verbose write !,best
		}
		set cnt="",lastCount=$order(^||Queue(flow,""),-1)
		for  {
			//write ! zwrite ^||Queue hang 1
			set cnt=$order(^||Queue(flow,cnt)) quit:cnt=""
			do ..SetQueueForAllLevel(.arr,flow,cnt,.maxFlow,maxsteps)
			quit:maxFlow
			quit:cnt>lastCount
		}
	}
	quit maxFlow
}

}

