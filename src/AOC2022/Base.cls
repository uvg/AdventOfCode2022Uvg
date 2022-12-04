Class AOC2022.Base
{

Parameter Folder = "C:\devl\work\Cache\AOC\Files\2022\";

// Parameter Folder = "/irisrun/repo/Files/";

ClassMethod GetInputToArray(fn As %String, ByRef recordsArr) As %Status
{
    set stream = ..GetInput(fn)
    kill recordsArr
    set Line=0
	while 'stream.AtEnd {
		set Record=$zstrip(stream.ReadLine(),"*C")
		set Line=Line+1
		set recordsArr(Line)=Record
	}
	quit $$$OK
}

ClassMethod GetInput(fn) As %Stream
{
    set fn=..#Folder_fn
    set stream = ##Class(%Stream.FileCharacter).%New()
    do stream.LinkToFile(fn)
    set stream.LineTerminator=$char(13,10)
    return stream
}

// d ##class(AOC2022.Day{D}).Run()

ClassMethod Run(verbose = 0, part = 0) [ Final ]
{
	if (part=0)||(part=1) set answer=..Part1(verbose) write !,"Part1: " zwrite answer
	if (part=0)||(part=2) set answer=..Part2(verbose) write !,"Part2: " zwrite answer
}

ClassMethod Part1(verbose = 0) As %String [ Abstract, Private ]
{
	set stream=..GetInput(..#InputFile)
    set line=0
	while 'stream.AtEnd {
		set line=line+1
		set record=stream.ReadLine()
		set recordsArr(line)=record
	}
	set Answer="Part1"
	quit Answer
}

ClassMethod Part2(verbose = 0) As %String [ Abstract, Private ]
{
	set stream=..GetInput(..#InputFile)
    set line=0
	while 'stream.AtEnd {
		set line=line+1
		set record=stream.ReadLine()
		set recordsArr(line)=record
	}
	set Answer="Part2"
	quit Answer
}

}

