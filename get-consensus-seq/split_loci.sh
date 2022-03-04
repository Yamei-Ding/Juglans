#!/bin/bash
for((i=1;i<=15;i+=1));
do
	st=$i
	intval=0
	((ed=$st+$intval))
	((n=n+1))
	echo $ed
	sed -n "$st,${ed}p" 15doubt_depth.txt >./depth$n.txt

done
