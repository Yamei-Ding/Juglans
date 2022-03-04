FILENAME=$1
function While_read_LINE(){
        cat $FILENAME | while read LINE
        do
                str=$LINE
                var=($str)
              #  var=${var//\s/}
                sample=${var[0]}
                depth=${var[1]}
                min=$(echo "$depth*10" |bc -l| cut -d. -f1)
                echo $sample $min
done
}
While_read_LINE
