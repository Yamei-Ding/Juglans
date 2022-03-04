num=$1;  #num of K

data="./Juglans_structure.txt"  #input
rdir="Juglans_result"
logdir="Juglans_resultlog"

mkdir -p $rdir   #result dir
mkdir -p $logdir   #log file dir
for i in {1..20}
{
     random=$(echo $RANDOM)     
     fileout="result_"$num"-"$i
     filelog="log"$num"-"$i
    nohup  structure -K $1 -D $random -i $data -o ./$rdir/$fileout  >./$logdir/$filelog &
}
