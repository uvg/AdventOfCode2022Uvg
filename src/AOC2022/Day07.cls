Class AOC2022.Day07 Extends AOC2022.Base
{

Parameter InputFile = "d07.txt";

// d ##class(AOC2022.Day07).Run()

ClassMethod Part1(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//Compute the sum of all dirs <=100000
	set answer="",line="",state=0,currDir=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if $extract(record,1,4)="$ cd" {
			set state=1,nextDir=$piece(record," ",3)
			if nextDir=".." {
				set nextDir=$list(filesArr(currDir),1)
			} else {
				set nextDir=..GetUniqueDirName(.filesArr,.idArr,nextDir,currDir)
			}
			set currDir=nextDir
			continue
		}
		if $extract(record,1,4)="$ ls" {
			set state=2
			continue
		}
		set fileSize=$piece(record," ",1),fileName=$piece(record," ",2)
		if fileSize="dir" set fileName=..GetUniqueDirName(.filesArr,.idArr,fileName,currDir)
		set filesArr(currDir,fileName)=fileSize
		if fileSize="dir" set filesArr(fileName)=$listbuild(currDir)
	}
	if verbose write !!,"before",! zwrite filesArr
	do ..ComputeDirSize(.filesArr)
	if verbose write !!,"after",! zwrite filesArr
	set total=0,dir="" for  {
		set dir=$order(filesArr(dir)) quit:dir=""
		set size=$list(filesArr(dir),2)
		continue:size>100000
		set total=total+size
	}
	set answer=total
	quit answer
}

ClassMethod GetUniqueDirName(ByRef filesArr, ByRef idArr, dirName As %String, parent As %String) As %String [ Private ]
{
	while $length(parent) {
		set dirName=parent_"/"_dirName
		set parent=$listget($get(filesArr(parent)),1)
	}
	quit ..GetDirId(.idArr,dirName)
}

ClassMethod GetDirId(ByRef idArr, dirName As %String) As %Integer [ Private ]
{
	set id=""
	for  {
		set id=$order(idArr(id)) quit:id=""
		if idArr(id)=dirName {
			return id
		}
	}
	set id=$increment(idArr)
	set idArr(id)=dirName
	quit id
}

ClassMethod ComputeDirSize(ByRef filesArr) [ Private ]
{
	set dirId="" for  {
		set dirId=$order(filesArr(dirId)) quit:dirId=""
		set $list(filesArr(dirId),2)=..GetDirSize(.filesArr,dirId)
	}
}

ClassMethod GetDirSize(ByRef filesArr, dirId As %Integer) As %Integer [ Private ]
{
	set total=0,file=""
	for  {
		set file=$order(filesArr(dirId,file)) quit:file=""
		set size=filesArr(dirId,file)
		if size="dir" set size=..GetDirSize(.filesArr,file)
		set total=total+size
	}
	quit total
}

ClassMethod Part2(verbose = 0) As %String [ Private ]
{
	do ..GetInputToArray(..#InputFile,.recordsArr)
	//
	set answer="",line="",state=0,currDir=""
	for {
		set line=$order(recordsArr(line)) quit:line=""
		set record=recordsArr(line)
		if $extract(record,1,4)="$ cd" {
			set state=1,nextDir=$piece(record," ",3)
			if nextDir=".." {
				set nextDir=$list(filesArr(currDir),1)
			} else {
				set nextDir=..GetUniqueDirName(.filesArr,.idArr,nextDir,currDir)
			}
			set currDir=nextDir
			continue
		}
		if $extract(record,1,4)="$ ls" {
			set state=2
			continue
		}
		set fileSize=$piece(record," ",1),fileName=$piece(record," ",2)
		if fileSize="dir" set fileName=..GetUniqueDirName(.filesArr,.idArr,fileName,currDir)
		set filesArr(currDir,fileName)=fileSize
		if fileSize="dir" set filesArr(fileName)=$listbuild(currDir)
	}
	if verbose write !!,"before",! zwrite filesArr
	do ..ComputeDirSize(.filesArr)
	if verbose write !!,"after",! zwrite filesArr
	set currSize=$list(filesArr(1),2)
	set unusedSize=70000000-currSize
	set neededSize=30000000-unusedSize
	if verbose write !,currSize,",",unusedSize,",",neededSize
	set min=currSize
	set dir="" for  {
		set dir=$order(filesArr(dir)) quit:dir=""
		set size=$list(filesArr(dir),2)
		if verbose write !,dir,",",size,",",min
		if size>=neededSize,size<min set min=size
	}
	set answer=min
	quit answer
}

}

