#!/bin/bash

LIBRARIES="magick opencv"
RESOURCES=resources
OUTPUT_FOLDER=out

MONITOR=./scripts/monitor.sh

CSV_FORMAT="%tm,%tM,%ta,%td,%Tm,%TM,%Ta,%Td,%mm,%mM,%ma,%md\n"

format=default

function help()
{
  echo 'Usage: $0 [options]'
  echo "Options:"
  echo -e "\E[1m c \E[0m - run every single test n times (default n=1)"
  echo -e "\E[1m v \E[0m - verbose mode"
  echo -e "\E[1m f <format> \E[0m - format: default, csv"
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
      format=csv
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

while getopts vf:c: option 
do 
 case $option in
  v) monitorOptions="$monitorOptions -v";; 
  c) monitorOptions="$monitorOptions -c $OPTARG";;
  f) formatOpt=`getFormatOption $OPTARG` 
     monitorOptions="$monitorOptions $formatOpt";;
  ?) wrongUsage "Unknown option";;
 esac
done

mkdir -p $OUTPUT_FOLDER
rm -rf $OUTPUT_FOLDER/*

for folder in $RESOURCES/*; do
    if [ -d $folder ]; then
    	echo $folder:
    	for lib in $LIBRARIES; do
        size=`ls -oh tester-$lib | sed -e "s/\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+\([^ ]\+\) \+.*/\4/"`
        if [[ '$format' = 'csv' ]]; then
          echo -n "$lib,$size";
        else
          echo "  $lib"
          echo "    size: $size"
        fi
    		out=$OUTPUT_FOLDER/`basename $folder`/$lib/
    		mkdir -p $out
    		$MONITOR $monitorOptions ./tester-$lib $folder $out
    	done
    fi
done