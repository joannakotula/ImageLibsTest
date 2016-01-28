#!/bin/bash

DEFAULT_FORMAT='min time: %tm, max time: %tM, avg time: %ta, time stdev: %td\nCPU time min: %Tm, CPU time max: %TM, CPU time avg: %Ta, CPU time stdev: %Td\nmemory min: %mm, memory max: %mM, memory avg: %ma, memory stdev: %md\n'


##################################################
## FUNCTIONS

function help(){
  echo 'Usage: $0 [options] {executable} <args ... >'
  echo "Options:"
  echo -e "\E[1m f \E[0m - set format for output data"
  echo "      default format: '$DEFAULT_FORMAT'"
  echo -e "\E[1m c \E[0m - run executable n times (default n=1)"
  echo -e "\E[1m v \E[0m - verbose mode"

}

function wrongUsage()
{
  echo $*
  help
  exit 1
}


function isset(){
  [ $1 = 1 ]
}


function countMemory()
{
  if [ $# -ne 42 ]; then let n=$#-42; shift $n; fi;  
  wynik=${23}
  
  echo $wynik
}

jif=`getconf CLK_TCK`
jif=$(echo "scale=2; 1/$jif" | bc)

function countTime()
{
  czas=$1
  shift 1
  a=${14}; b=${15}
  wynik=$(echo "scale=2; ($a+$b)*$jif-$czas" | bc)
  
  echo $wynik
}

function giveCpu()
{
  w=$(echo "scale=2; $2+$3" | bc)
  echo $w
}

function giveTimes()
{
  echo $1
}

function deviation()
{
  sr=$1
  shift
  s=0
  for k in $*
  do
     s=$(echo "scale=4; $s+($k-$sr)^2" | bc)
  done
   w=$(echo "scale=4; sqrt( $s )" | bc)
   echo $w
}


######################################################
## VARIABLES

#option variables:
format=$DEFAULT_FORMAT
v=0

declare -i nc=1; 


#counted variables

wtm=0 #min real time
wtM=0 #max real time
wta=0 #avg real time
wtd=0 #real time standard deviation
wTm=0 #min CPU time
wTM=0 #max CPU time
wTa=0 #avg CPU time
wTd=0 #CPU time standard deviation
wmm=0 #min memory
wmM=0 #max memory
wma=0 #avg memory
wmd=0 #memory standard deviation

allMem='' #all memory values - to count wmd
allTime='' #all real time values - to count wtd
allCpuTime='' #all CPU time values - to count wTd

sm=0 #sum of memory values - to count wma
st=0 #sum of real time values - to count wta
sT=0 #sum of CPU time values - to count wTa

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
while getopts vf:c: option 
do 
 case $option in
  v) v=1;; 
  f) format=$OPTARG;;
  c) nc=$OPTARG;;
  ?) wrongUsage "Unknown option";;
 esac
done

#shift all options:
let OPTIND=$OPTIND-1
shift $OPTIND

#now $* = {executable} <arguments>
program=$1; shift
#now $* = <arguments>

for i in `seq $nc`; do
  sync
  sudo bash -c "echo 3 > /proc/sys/vm/drop_caches"
  tmp=`mktemp /tmp/monitortmp.XXXXXX`
  log=`mktemp /tmp/$program.log.XXXXXX`
  /usr/bin/time -f "%e %U %S" -o $tmp $program $* >$log 2>$log &

  #pid - time pid
  #progpid - program pid
  pid=$!
  progpid=`pgrep -P $pid`

  while [ $? -ne 0 ] && ps $pid 2>/dev/null 1>/dev/null; do progpid=`pgrep -P $pid`; done


  maxMem=0
  time=0

  if [ $nc -gt 1 ] && isset $v; then echo "====== iteration $i:"; fi
  while (ps "$progpid" 2>/dev/null 1>/dev/null) #process is alive
  do
    res=`cat /proc/$progpid/stat 2> /dev/null`
    if [ -z res ]; 
      then if isset $v; then echo "    exiting loop - process is dead"; fi
      break; 
    fi
    memory=`countMemory $res`
    
    if [ $memory -gt $maxMem ]; then maxMem=$memory; fi
    if isset $v; then
      time=`countTime $time $res`
      echo "    memory: $memory"
      echo "    CPU time since last sampling: $time"
      echo "    -----------"
    fi
 
   
   sleep 1
  done

  wait $pid

  times=`cat $tmp | tail -n 1`
  wt=`giveTimes $times`
  wT=`giveCpu $times`

  rm $tmp

  #memory
  if [ $maxMem -gt $wmM ]; then wmM=$maxMem; fi
  if [ $maxMem -lt $wmm ]; then wmm=$maxMem; fi
  if [ $wmm -eq 0 ]; then wmm=$maxMem; fi
  let sm=$sm+$maxMem
  allMem="$allMem $maxMem"


  #real time
  wtm=$(echo "scale=2; if( $wtm>$wt || $wtm == 0 ) x=$wt else x=$wtm; x" | bc)
  wtM=$(echo "scale=2; if( $wtM<$wt ) x=$wt else x=$wtM; x" | bc)
  st=$(echo "scale=2; $st+$wt" | bc)
  allTime="$allTime $wt"

  #CPU time
  wTm=$(echo "scale=2; if( $wTm>$wT || $wTm == 0 ) x=$wT else x=$wTm; x" | bc)
  wTM=$(echo "scale=2; if( $wTM<$wT ) x=$wT else x=$wTM; x" | bc)
  swT=$(echo "scale=2; $sT+$wT" | bc)
  allCpuTime="$allCpuTime $wT"

  
done

wma=$(echo "scale=2; $sm/$nc" | bc)
wmd=`deviation $wma $allMem`

wta=$(echo "scale=2; $st/$nc" | bc)
wtd=`deviation $wta $allTime`

wTa=$(echo "scale=2; $sT/$nc" | bc)
wTd=`deviation $wTa $allCpuTime`



printf "`echo $format | sed "s/%tm/$wtm/g; s/%tM/$wtM/g; s/%ta/$wta/g; s/%td/$wtd/g; s/%Tm/$wTm/g; s/%TM/$wTM/g; s/%Ta/$wTa/g; s/%Td/$wTd/g; s/%mm/$wmm/g; s/%mM/$wmM/g; s/%ma/$wma/g; s/%md/$wmd/g;"`"
