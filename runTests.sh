#!/bin/bash

LIBRARIES="magick opencv"
RESOURCES=resources
OUTPUT_FOLDER=out

MONITOR=./scripts/monitor.sh

function help()
{
  echo 'Usage: $0 [options]'
  echo "Options:"
  echo -e "\E[1m c \E[0m - run every single test n times (default n=1)"
  echo -e "\E[1m v \E[0m - verbose mode"
}

function wrongUsage()
{
  if [ $# -gt 1 ]; then echo $*; fi
  help
  exit 1
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
  ?) wrongUsage "Unknown option";;
 esac
done

mkdir -p $OUTPUT_FOLDER
rm -rf $OUTPUT_FOLDER/*

for folder in $RESOURCES/*; do
    if [ -d $folder ]; then
    	echo $folder:
    	for lib in $LIBRARIES; do
    		echo "  $lib"
    		out=$OUTPUT_FOLDER/`basename $folder`/$lib/
    		mkdir -p $out
    		$MONITOR $monitorOptions ./tester-$lib $folder $out
    	done
    fi
done