#!/bin/bash

DEFAULT_FORMAT="memory: (%avgM, %minM, %maxM)\nmajor page faults: (%avgP, %minP, %maxP)\nswapped out of main memory (%avgW, %minW, %maxW)\nsystem cpu time (%avgS, %minS, %maxS)\nuser cpu time (%avgU, %minU, %maxU)\ntotal cpu time (%avgA, %minA, %maxA)\nreal time (%avgT, %minT, %maxT)\ncpu percent (%avgC, %minC, %maxC)\nfile inputs (%avgI, %minI, %maxI)\nfile outputs (%avgO, %minO, %maxO)\n"

SUMUP=`dirname $0`/sumup.awk

######################################################
## FUNCTIONS

function help(){
  echo 'Usage: $0 [options] {executable} <args ... >'
  echo "Options:"
  echo -e "\E[1m f <format>\E[0m - set format for output data"
  echo "      default format: '$DEFAULT_FORMAT'"
  echo -e "\E[1m c <n>\E[0m - run executable n times (default n=1)"
  echo -e "\E[1m o <file>\E[0m - write output to given file"
  echo -e "\E[1m d \E[0m - drop caches before every run"
  echo -e "\E[1m v \E[0m - verbose mode"

}

function wrongUsage()
{
  echo $*
  help
  exit 1
}

######################################################
## VARIABLES

drop_caches=false
time_opts=''
count=1
output=''
format=$DEFAULT_FORMAT

######################################################
## MAIN CONTENT

if [[ $# -lt 1 ]]; then
  wrongUsage "No arguments given";
fi

if [[ $1 = 'help' ]]; then
  help
  exit 0;
fi

#Reading options:
while getopts vf:c:o: option 
do 
 case $option in
  v) time_opts="$time_opts -v";; 
  f) format=$OPTARG;;
  d) drop_caches=true;;
  c) count=$OPTARG;;
  o) output=$OPTARG;;
  ?) wrongUsage "Unknown option";;
 esac
done

#shift all options:
let OPTIND=$OPTIND-1
shift $OPTIND

#now $* = {executable} <arguments>
program=$1; shift
#now $* = <arguments>


if [[ -z "$output" ]]; then
	output=`mktemp /tmp/monitor.log.XXXXXX`
fi
# empty file
> $output



for (( i = 0; i < count; i++ )); do
	if [[ "$drop_caches" = true ]]; then
		sudo bash -c "echo 3 > /proc/sys/vm/drop_caches"
	fi

	log=`mktemp /tmp/$program.log.XXXXXX`
	/usr/bin/time $time_opts -o $output -a -f "%M;%W;%F;%S;%U;%P;%e;%I;%O;%k;%x" $program "$@" >$log 2>$log
done

# cat $output

$SUMUP -v FORMAT="$format" $output 
