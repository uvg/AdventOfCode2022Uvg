# aoc-2022-uvg
This is the source code for my advent of code 2022 using objectscript classes.


## AdventOfCode
From [Advent Of Code](https://adventofcode.com/about):
Advent of Code is an Advent calendar of small programming puzzles for a variety of skill sets and skill levels that can be solved in any programming language you like. People use them as a speed contest, interview prep, company training, university coursework, practice problems, or to challenge each other.


## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git),
and if you wish to run inside a docker then make sure you also have [Docker desktop](https://www.docker.com/products/docker-desktop) installed,
or if you want to install using zpm then make sure you have [ObjectScript Package Manager](https://openexchange.intersystems.com/package/ObjectScript-Package-Manager) installed in your IRIS server.


## Installation with zpm
in the namespace prompt:
```
zpm
```

inside zpm shell:
```
install aoc-2022-uvg
```


## Installation inside a docker
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/uvg/AdventOfCode2022Uvg.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
```


## How to Test it
Put all your input data into files in a specific folder, and set the **Folder** parameter inside **Class AOC2022.Base**

Open IRIS terminal. For docker:

```
$ docker-compose exec iris iris session iris
```

And enter the following command to run the first day both parts:
```
USER>do ##class(AOC2022.Day01).Run()
```

- Extended Run parameters:  _do ##class(AOC2022.Day01).Run(**verbose,part**)_ with
verbose =  1 ; will display some messages, Otherwise will just print the answer
part = 1,2 ; run only first or second part of example, empty/0 will run both parts
````
; to run all exercises use
for day=0:1:25 set zday=day set:zday<10 zday=0_day do $classmethod("AOC2022.Day"_zday,"Run")
; to run all exercises while printing message use
for day=0:1:25 set zday=day set:zday<10 zday=0_day do $classmethod("AOC2022.Day"_zday,"Run",1)
; to run all exercises part 1 use
for day=0:1:25 set zday=day set:zday<10 zday=0_day do $classmethod("AOC2022.Day"_zday,"Run",,1)
; to run all exercises part 2 use
for day=0:1:25 set zday=day set:zday<10 zday=0_day do $classmethod("AOC2022.Day"_zday,"Run",,2)
````


## How to start coding
The script in Installer.cls will import everything you place under /src into IRIS.


## What's inside the repository

### Dockerfile

The simplest dockerfile which starts IRIS and imports code from /src folder into it.
Use the related docker-compose.yml to easily setup additional parametes like port number and where you map keys and host folders.


### .vscode/settings.json

Settings file to let you immedietly code in VSCode with [VSCode ObjectScript plugin](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript))


### .vscode/launch.json
Config file if you want to debug with VSCode ObjectScript

[Read about all the files in this artilce](https://community.intersystems.com/post/dockerfile-and-friends-or-how-run-and-collaborate-objectscript-projects-intersystems-iris)