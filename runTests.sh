#!/bin/bash

LIBRARIES="cimg freeimage magick opencv vips"
RESOURCES=resources
OUTPUT_FOLDER=out

MONITOR=./scripts/monitor.sh

CSV_FORMAT="%avgM, %minM, %maxM, %avgP, %minP, %maxP, %avgW, %minW, %maxW, %avgS, %minS, %maxS, %avgU, %minU, %maxU, %avgA, %minA, %maxA, %avgT, %minT, %maxT, %avgC, %minC, %maxC, %avgI, %minI, %maxI, %avgO, %minO, %maxO"
CSV_HEADER="library,size,avg memory,min memory,max memory, avg major page faults, min major page faults, max major page faults, avg swapped times, min swapped times, max swapped times, avg system cpu time, min system cpu time, max system cpu time, avg user cpu time, min user cpu time, max user cpu time, avg total cpu time, min total cpu time, max total cpu time, avg real time, min real time, max real time, avg cpu percent, min cpu percent, max cpu percent, avg file inputs, min file inputs, max file inputs, avg file outputs, min file outputs, max file outputs"

format=default

function help()
{
  echo 'Usage: $0 [options]'
  echo "Options:"
  echo -e "\E[1m c <n>\E[0m - run every single test n times (default n=1)"
  echo -e "\E[1m v \E[0m - verbose mode"
  echo -e "\E[1m f <format> \E[0m - format: default, csv"
  echo -e "\E[1m d \E[0m - drop caches before every run"

}

function wrongUsage()
{
  if [ $# -gt 1 ]; then echo $*; fi
  help
  exit 1
}

function getFormatOption(){
  case $1 in
    default)
      return;;
    csv)
      echo "-f $CSV_FORMAT";
      ;;
    *) wrongUsage "Unknown format: $1";
  esac
}

if [ '$1' = 'help' ]; then
	help
	exit 0
fi

monitorOptions=''

while getopts vf:c:d option 
do 
 case $option in
  v) monitorOptions="$monitorOptions -v";; 
  c) monitorOptions="$monitorOptions -c $OPTARG";;
  f) formatOpt=`getFormatOption $OPTARG`
     format=$OPTARG 
     monitorOptions="$monitorOptions $formatOpt";;
  d) monitorOptions="$monitorOptions -d";;
  ?) wrongUsage "Unknown option";;
 esac
done

mkdir -p $OUTPUT_FOLDER
rm -rf $OUTPUT_FOLDER/*

for folder in $RESOURCES/*; do
    if [ -d $folder ]; then
    	echo $folder:
      if [[ $format = csv ]]; then
        echo $CSV_HEADER
      fi
    	for lib in $LIBRARIES; do
        size=`ls -oh tester-$lib | sed -e "s/\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+.*/\4/"`
        if [[ $format = csv ]]; then
          echo -n "$lib,$size,";
        else
          echo "  $lib"
          echo "    size: $size"
        fi
    		out=$OUTPUT_FOLDER/`basename $folder`/$lib/
    		mkdir -p $out
    		$MONITOR $monitorOptions -o $out/result.csv ./tester-$lib $folder $out
    	done
    fi
done