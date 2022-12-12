Class AOC2022.Day11 Extends AOC2022.Base
{

Parameter InputFile = "d11.txt";

// d ##class(AOC2022.Day11).Run()

ClassMethod Part1(verbose = 0) As %String [ Private, PublicList = (new, old) ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//After 20 rounds the answer is the multiply of two most active monkeys' number of actions 
	//
	new new,old
	set answer="",line=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if $piece(record," ",1)="Monkey" {
			set monkey=+$piece(record," ",2)
			continue
		}
		if record["Starting " {
			set itemsStr=$piece(record,"items: ",2)
			set items=""
			if verbose write !,monkey,"=",itemsStr
			for index=1:1:$length(itemsStr,", ") {
				set item=+$piece(itemsStr,", ",index)
				set items=items_$listbuild(item)
			}
			set $list(monkeysArr(monkey),6)=items
			continue
		}
		if record["Operation: " {
			set opp=$piece(record,"Operation: ",2)
			set $list(monkeysArr(monkey),1)=opp
			continue
		}
		if record["Test: " {
			set div=+$piece(record,"by ",2)
			set $list(monkeysArr(monkey),2)=div
			continue
		}
		if record["If true: " {
			set reciever=+$piece(record,"monkey ",2)
			set $list(monkeysArr(monkey),3)=reciever
			continue
		}
		if record["If false: " {
			set reciever=+$piece(record,"monkey ",2)
			set $list(monkeysArr(monkey),4)=reciever
			set $list(monkeysArr(monkey),5)=0
			continue
		}
	}
	if verbose write ! zwrite monkeysArr
	for round=1:1:20 {
		set monkey="" for  {
			set monkey=$order(monkeysArr(monkey)) quit:monkey=""
			set attr=monkeysArr(monkey)
			set opp=$list(attr,1),div=$list(attr,2),monkeyT=$list(attr,3),monkeyF=$list(attr,4),counter=$list(attr,5),items=$list(attr,6)
			if $length(items),$listlength(items) {
				for itemIndex=1:1:$listlength(items) {
					set item=$list(items,itemIndex)
					set counter=counter+1
					set old=item
					xecute "s "_opp
					set new=new\3
					if (new#div=0) {
						set monkeyTItems=$list(monkeysArr(monkeyT),6)
						set monkeyTItems=monkeyTItems_$listbuild(new)
						set $list(monkeysArr(monkeyT),6)=monkeyTItems
					}
					else {
						set monkeyFItems=$list(monkeysArr(monkeyF),6)
						set monkeyFItems=monkeyFItems_$listbuild(new)
						set $list(monkeysArr(monkeyF),6)=monkeyFItems
					}
				}
			}
			set $list(monkeysArr(monkey),5)=counter,$list(monkeysArr(monkey),6)=""
		}
		if verbose {
			write !!!,"After round ",round
			write ! zwrite monkeysArr
		}
	}
	set monkey="" for  {
		set monkey=$order(monkeysArr(monkey)) quit:monkey=""
		set counter=$list(monkeysArr(monkey),5)
		set counterArr(counter)=""
	}
	set answer=$order(counterArr(""),-1)
	set answer=answer*$order(counterArr(answer),-1)
	quit answer
}

ClassMethod Part2(verbose = 0) As %String [ Private, PublicList = (new, old) ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	new new,old
	set answer="",line=""
	//All dividors are primes
	set primesProduct=1
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if $piece(record," ",1)="Monkey" {
			set monkey=+$piece(record," ",2)
			continue
		}
		if record["Starting " {
			set itemsStr=$piece(record,"items: ",2)
			set items=""
			if verbose write !,monkey,"=",itemsStr
			for index=1:1:$length(itemsStr,", ") {
				set item=+$piece(itemsStr,", ",index)
				set items=items_$listbuild(item)
			}
			set $list(monkeysArr(monkey),6)=items
			continue
		}
		if record["Operation: " {
			set opp=$piece(record,"Operation: ",2)
			set $list(monkeysArr(monkey),1)=opp
			continue
		}
		if record["Test: " {
			set div=+$piece(record,"by ",2)
			set $list(monkeysArr(monkey),2)=div
			set primesProduct=primesProduct*div
			continue
		}
		if record["If true: " {
			set reciever=+$piece(record,"monkey ",2)
			set $list(monkeysArr(monkey),3)=reciever
			continue
		}
		if record["If false: " {
			set reciever=+$piece(record,"monkey ",2)
			set $list(monkeysArr(monkey),4)=reciever
			set $list(monkeysArr(monkey),5)=0
			continue
		}
	}
	if verbose write ! zwrite monkeysArr,primesProduct
	for round=1:1:10000 {
		//write !,"round=",round
		set monkey="" for  {
			set monkey=$order(monkeysArr(monkey)) quit:monkey=""
			set attr=monkeysArr(monkey)
			set opp=$list(attr,1),div=$list(attr,2),monkeyT=$list(attr,3),monkeyF=$list(attr,4),counter=$list(attr,5),items=$list(attr,6)
			if $length(items),$listlength(items) {
				for itemIndex=1:1:$listlength(items) {
					set item=$list(items,itemIndex)
					set counter=counter+1
					set old=item
					xecute "s "_opp
					set new=new#primesProduct
					if (new#div=0) {
						set monkeyNewAttr=monkeysArr(monkeyT)
						set monkeyNewItems=$list(monkeyNewAttr,6)
						set monkeyNewDiv=$list(monkeyNewAttr,2)
						set monkeyNewItems=monkeyNewItems_$listbuild(new)
						set $list(monkeysArr(monkeyT),6)=monkeyNewItems
					}
					else {
						set monkeyNewAttr=monkeysArr(monkeyF)
						set monkeyNewItems=$list(monkeyNewAttr,6)
						set monkeyNewItems=monkeyNewItems_$listbuild(new)
						set $list(monkeysArr(monkeyF),6)=monkeyNewItems
					}
				}
			}
			set $list(monkeysArr(monkey),5)=counter,$list(monkeysArr(monkey),6)=""
		}
		if verbose,(round=1)||(round=20)||(round#1000=0) {
			write !!!,"After round ",round
			write ! zwrite monkeysArr
		}
	}
	set monkey="" for  {
		set monkey=$order(monkeysArr(monkey)) quit:monkey=""
		set counter=$list(monkeysArr(monkey),5)
		set counterArr(counter)=""
	}
	set answer=$order(counterArr(""),-1)
	set answer=answer*$order(counterArr(answer),-1)
	quit answer
}

}

