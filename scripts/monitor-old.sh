#!/bin/bash


#trap
trap 'rm $tmp 2>/dev/null 1>/dev/null; kill $progpid 2>/dev/null 1>/dev/null; kill $pid 1>/dev/null 2>/dev/null' 0

#FUNKCJE:
jif=`getconf CLK_TCK`
jif=$(echo "scale=2; 1/$jif" | bc)

function wrongUsage()
{
  echo 'Uzycie: $0 [-t] [-m] [-s | -d -i <n>] [-f <format>] [-c <n>] {executable} <args ... >'
  exit
}

function jest()
{
  [ $1 = 1 ]
}

function wyliczPamiec()
{
  if [ $# -ne 42 ]; then let n=$#-42; shift $n; fi;  
  wynik=${23}
  
  echo $wynik
}

function wyliczCzas()
{
  czas=$1
  if [ $# -gt 42 ]; then let n=$#-42; shift $n; fi;
  a=${14}; b=${15}
  wynik=$(echo "scale=2; ($a+$b)*$jif-$czas" | bc)
  
  echo $wynik
}

function odchylenie()
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

function dajCPU()
{
  w=$(echo "scale=2; $2+$3" | bc)
  echo $w
}

function dajCzas()
{
  echo $1
}


###########################################################33
#tresc glowna:

#zmienne:
t=0; #statystyki zwiazane z czasem (tak/nie)
m=0; #statystyki zwiazane z pamiecia
s=0; #statystyki ogolne (sumaryczne)
d=0; #statystyki szczegolowe
f=0; #format prezentacji wynikow
c=0; #liczba prob
format=''; #format

wtm=0 #wartosc minimalna dla czasu rzeczywistego
wtM=0 #wartosc maksymalna dla czasu rzeczywistego
wta=0 #wartosc srednia dla czasu rzeczywistego
wtv=0 #wartosc odchylenia standardowego dla czasu rzeczywistego
wTm=0 #wartosc minimalna dla czasu CPU
wTM=0 #wartosc maksymalna dla czasu CPU
wTa=0 #wartosc srednia dla czasu CPU
wTv=0 #wartosc odchylenia standardowego dla czasu CPU
wmm=0 #wartosc minimalna dla pamieci
wmM=0 #wartosc maksymalna dla pamieci
wma=0 #wartosc srednia dla pamieci
wmv=0 #wartosc odchylenia standardowego dla pamieci 

ciagm='' #ciąg wartosci pamieci - do policzenia wmv
ciagt='' #ciąg wartosci czasu rzeczywistego - do policzenia wtv
ciagT='' #ciąg wartosci czasu CPU - do policzenia wTv

sm=0 #suma wartości pamięci - do policzenia wma
st=0 #suma wartości czasu rzeczywistego - do policzenia wta
sT=0 #suma wartości czasu CPU - do policzenia wTa

declare -i nd=0; #co ile sekund wypisywane sa statystyki szczegolowe
declare -i nc=0; #ile prob

#spisuje parametry:
while getopts tmsdi:f:c: opcja 
do 
 case $opcja in
  t) t=1;;
  m) m=1;;
  s) if jest $d  
       then wrongUsage
       else s=1
      fi;;
  d) if jest $s 
       then wrongUsage
       else d=1; 
     fi;;
  f) f=1; format=$OPTARG;;
  c) c=1; nc=$OPTARG;;
  i) nd=$OPTARG;;
  ?) wrongUsage;;
 esac
done

#sprawdzam czy dobrze użyte -d oraz -i 
if jest $d
 then if [ $nd -eq 0 ]; then wrongUsage; fi
 else if [ $nd -gt 0 ]; then wrongUsage; fi
fi

#ustawiam nazwe programu i jego argumenty:
let OPTIND=$OPTIND-1
shift $OPTIND
program=$1; shift

#ustawiam inne parametry:
jest $d || nd=1
jest $c || nc=1
jest $f || format="czas min: %tm, czas max: %tM, czas średni: %ta, czas odchylenie standardowe: %tv\\nczas CPU min: %Tm, czas CPU max: %TM, czas CPU średni: %Ta, czas CPU ochylenie standardowe: %Tv\\npamiec min: %mm, pamiec max: %mM, pamiec srednia: %ma, pamiec odchylenie standardowe: %mv\\n"

#uruchamianie programu (w pętli for):
for zm in `seq $nc`
do
  sync
  echo 3 > /proc/sys/vm/drop_caches
  tmp=`mktemp /tmp/mojtmp.XXXXXX`
  log=`mktemp $program.log.XXXXXX`
  /usr/bin/time -f "%e %U %S" -o $tmp $program $* >$log 2>/dev/null &

  #pid - pid time'a, progpid - pid programu
  pid=$!
  progpid=`pgrep -P $pid`
  while [ $? -ne 0 ] && ps $pid 2>/dev/null 1>/dev/null; do progpid=`pgrep -P $pid`; done
  #if [ $? -ne 0 ]; then break; fi

  maxPam=0
  czas=0
  if jest $c && jest $d; then echo uruchomienie $zm; fi
  #pętla z wyliczaniem i wypisywaniem wyników:
  while (ps "$progpid" 2>/dev/null 1>/dev/null)
  do
   wyn=`cat /proc/$progpid/stat 2> /dev/null`
   if [ -z wyn ]; then echo wychodze; break; fi
   pamiec=`wyliczPamiec $wyn`
  
   if [ $pamiec -gt $maxPam ]; then maxPam=$pamiec; fi
   if jest $d
     then
       if jest $m; then printf "pamiec: $pamiec "; fi
       if jest $t; then czas=`wyliczCzas $czas $wyn`; printf "czas CPU od ostatniego próbkowania: $czas"; fi
       printf "\\n"
   fi
 
   
   sleep $nd
  done

  wait $pid

  czasy=`cat $tmp | tail -n 1`
  wt=`dajCzas $czasy`
  wT=`dajCPU $czasy`

  rm $tmp

  #pamiec
  if [ $maxPam -gt $wmM ]; then wmM=$maxPam; fi
  if [ $maxPam -lt $wmm ]; then wmm=$maxPam; fi
  if [ $wmm -eq 0 ]; then wmm=$maxPam; fi
  let sm=$sm+$maxPam
  ciagm="$ciagm $maxPam"


  #czas
  wtm=$(echo "scale=2; if( $wtm>$wt || $wtm == 0 ) x=$wt else x=$wtm; x" | bc)
  wtM=$(echo "scale=2; if( $wtM<$wt ) x=$wt else x=$wtM; x" | bc)
  st=$(echo "scale=2; $st+$wt" | bc)
  ciagt="$ciagt $wt"

  #czas
  wTm=$(echo "scale=2; if( $wTm>$wT || $wTm == 0 ) x=$wT else x=$wTm; x" | bc)
  wTM=$(echo "scale=2; if( $wTM<$wT ) x=$wT else x=$wTM; x" | bc)
  swT=$(echo "scale=2; $sT+$wT" | bc)
  ciagT="$ciagT $wT"


  
done
wma=$(echo "scale=2; $sm/$nc" | bc)
wmv=`odchylenie $wma $ciagm`

wta=$(echo "scale=2; $st/$nc" | bc)
wtv=`odchylenie $wta $ciagt`

wTa=$(echo "scale=2; $sT/$nc" | bc)
wTv=`odchylenie $wTa $ciagT`


printf "`echo $format | sed "s/%tm/$wtm/g; s/%tM/$wtM/g; s/%ta/$wta/g; s/%tv/$wtv/g; s/%Tm/$wTm/g; s/%TM/$wTM/g; s/%Ta/$wTa/g; s/%Tv/$wTv/g; s/%mm/$wmm/g; s/%mM/$wmM/g; s/%ma/$wma/g; s/%mv/$wmv/g;"`"

