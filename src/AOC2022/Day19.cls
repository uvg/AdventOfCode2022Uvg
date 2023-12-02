Class AOC2022.Day19 Extends AOC2022.Base
{

Parameter InputFile = "d19.txt";

// d ##class(AOC2022.Day19).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	kill ^AOC202219
	//24 minutes
	//Check all blueprints
	//Quality level=blueprint id * max geodes collected in 24 minutes
	//Answer=Sum of qulaity levels
	set answer="",line=""
	//
	//Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		//if verbose write !,record
		set id=+$piece(record,"Blueprint ",2)
		set ore=$piece($piece(record,".",1)," costs ",2),oreOre=+ore
		set clay=$piece($piece(record,".",2)," costs ",2),clayOre=+clay
		set obsidian=$piece($piece(record,".",3)," costs ",2),obsidianOre=+obsidian,obsidianClay=+$piece(obsidian," ",4)
		set geode=$piece($piece(record,".",4)," costs ",2),geodeOre=+geode,geodeObsidian=+$piece(geode," ",4)
		set blueprintsArr(id)=$listbuild($listbuild($listbuild(oreOre,1)),$listbuild($listbuild(clayOre,1)),$listbuild($listbuild(obsidianOre,1),$listbuild(obsidianClay,2)),$listbuild($listbuild(geodeOre,1),$listbuild(geodeObsidian,3)))
		set maxCost(id)=$listbuild(..Max(..Max(..Max(oreOre,clayOre),obsidianOre),geodeOre),obsidianClay,geodeObsidian)
		//if verbose w ! zwrite id,ore,clay,obsidian,geode,oreOre,clayOre,obsidianOre,obsidianClay,geodeOre,geodeObsidian
	}
	if verbose zwrite blueprintsArr,maxCost
	set id="",total=0
	for  {
		set id=$order(blueprintsArr(id)) quit:id=""
		kill ^||CurrMax
		set maxGeodes=..GetMaxGeodes(blueprintsArr(id),maxCost(id),24,$listbuild(1,0,0,0),$listbuild(0,0,0,0))
		set total=maxGeodes*id+total
	}
	kill ^||CurrMax
	set answer=total
	quit answer
}

ClassMethod GetMaxGeodes(blueprintData, maxCosts, remTime, bots, amount, cacheArr, id)
{
	quit:remTime=0 $list(amount,4)
	set key=$listbuild(remTime,bots,amount)
	quit:$data(cacheArr(key)) cacheArr(key)
	//zwrite key
	//h .1
	set currGeodesBots=$list(bots,4)
	set maxGeodes=$list(amount,4)+(currGeodesBots*remTime)
	set hypotheticalMaxGeodes=maxGeodes+((remTime+1)*remTime/2)
	//for time=remTime:-1:0 set hypotheticalMaxGeodes=hypotheticalMaxGeodes+hypotheticalGeodesBots,hypotheticalGeodesBots=hypotheticalGeodesBots+1
	if hypotheticalMaxGeodes<=$get(^||CurrMax) quit $list(amount,4)
	set:maxGeodes>$get(^||CurrMax) ^||CurrMax=maxGeodes
	//w !,"maxcost:",! zw maxCosts
	//                                           1             ,                 2               ,                             3                                  ,                        4
	//blueprintData=$listbuild($listbuild($listbuild(oreOre,1)),$listbuild($listbuild(clayOre,1)),$listbuild($listbuild(obsidianOre,1),$listbuild(obsidianClay,2)),$listbuild($listbuild(geodeOre,1),$listbuild(geodeObsidian,3)))
	//zw bots
	for botIndex=1:1:$listlength(blueprintData) {
		if botIndex'=4,$list(bots,botIndex)>=$list(maxCosts,botIndex) continue
		set wait=0
		set amountsNeeded=$list(blueprintData,botIndex)  //$listbuild($listbuild(obsidianOre,1),$listbuild(obsidianClay,2))= $lb($lb(amount,type),$lb(amount,type))
		//zw botIndex,amountsNeeded
		set haveAllBots=1
		for amtIndex=1:1:$listlength(amountsNeeded) {
			set amountNeeded=$list(amountsNeeded,amtIndex)
			set cost=$list(amountNeeded,1)
			set botNeeded=$list(amountNeeded,2)
			set numOfBots=$list(bots,botNeeded)
			if numOfBots=0 {
				set haveAllBots=0
				quit
			}
			set ceil=(cost-$list(amount,botNeeded))/numOfBots
			set:ceil<0 ceil=0
			set:ceil["." ceil=ceil\1+1
			//w "wait before=",wait,!
			set wait=..Max(wait,ceil)
			//zw cost,botNeeded,numOfBots,$list(amount,botNeeded)
			//w "wait after=",wait,!
		}
		continue:'haveAllBots
		set timeLeft=remTime-wait-1
		continue:timeLeft<=0
		//zw timeLeft
		//i timeLeft<14 k a s a=a
		set tempBots=bots
		set tempAmount=""
		for amtIndex=1:1:$listlength(amount) {
			set tempAmount=tempAmount_$listbuild($list(bots,amtIndex)*(wait+1)+$list(amount,amtIndex))
		}
		for amtIndex=1:1:$listlength(amountsNeeded) {
			set amountNeeded=$list(amountsNeeded,amtIndex)
			set cost=$list(amountNeeded,1)
			set botNeeded=$list(amountNeeded,2)
			set $list(tempAmount,botNeeded)=$list(tempAmount,botNeeded)-cost
		}
		set $list(tempBots,botIndex)=$list(tempBots,botIndex)+1
		for typeIndex=1:1:$listlength(maxCosts) {
			set $list(tempAmount,typeIndex)=..Min($list(tempAmount,typeIndex),$list(maxCosts,typeIndex)*timeLeft)
		}
		set maxGeodes=..Max(maxGeodes,..GetMaxGeodes(blueprintData,maxCosts,timeLeft,tempBots,tempAmount,.cacheArr))
	}
	
	set cacheArr(key)=maxGeodes
	set:$get(id) ^AOC202219(id)=maxGeodes
	quit maxGeodes
}

ClassMethod Max(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1>Val2 quit Val1
	quit Val2
}

ClassMethod Min(Val1 As %Integer, Val2 As %Integer) As %Integer
{
	if Val1<Val2 quit Val1
	quit Val2
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line=""
	//
	//Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
	for {
		set line=$order(recordsArr(line)) quit:line=""
		quit:line>3  //Only first 3 blueprints
		set record=recordsArr(line)
		//if verbose write !,record
		set id=+$piece(record,"Blueprint ",2)
		set ore=$piece($piece(record,".",1)," costs ",2),oreOre=+ore
		set clay=$piece($piece(record,".",2)," costs ",2),clayOre=+clay
		set obsidian=$piece($piece(record,".",3)," costs ",2),obsidianOre=+obsidian,obsidianClay=+$piece(obsidian," ",4)
		set geode=$piece($piece(record,".",4)," costs ",2),geodeOre=+geode,geodeObsidian=+$piece(geode," ",4)
		set blueprintsArr(id)=$listbuild($listbuild($listbuild(oreOre,1)),$listbuild($listbuild(clayOre,1)),$listbuild($listbuild(obsidianOre,1),$listbuild(obsidianClay,2)),$listbuild($listbuild(geodeOre,1),$listbuild(geodeObsidian,3)))
		set maxCost(id)=$listbuild(..Max(..Max(..Max(oreOre,clayOre),obsidianOre),geodeOre),obsidianClay,geodeObsidian)
		//if verbose write ! zwrite id,ore,clay,obsidian,geode,oreOre,clayOre,obsidianOre,obsidianClay,geodeOre,geodeObsidian
	}
	if verbose zwrite blueprintsArr,maxCost
	kill ^AOC202219
	set id="",total=1
	for  {
		set id=$order(blueprintsArr(id)) quit:id=""
		//  32 instead of 24
		set blueprintData=blueprintsArr(id),maxCosts=maxCost(id),remTime=32,bots=$listbuild(1,0,0,0),amount=$listbuild(0,0,0,0)
		job ..GetMaxGeodes(blueprintData,maxCosts,remTime,bots,amount,"",id)
	}
	for  {
		hang 1
		set sw=1
		set id=""
		for  {
			set id=$order(blueprintsArr(id)) quit:id=""
			if '$data(^AOC202219(id)) set sw=0 quit
		}
		quit:sw
	}
	set id=""
	for  {
		set id=$order(blueprintsArr(id)) quit:id=""
		set total=total*^AOC202219(id)
	}
	//kill ^AOC202219
	set answer=total
	quit answer
}

}

