#!/bin/bash
cmd="/home/codis/codis-vip/bin/codis-admin --dashboard=192.168.33.7:18080"
$cmd --group-status |grep "\[E\]" >/dev/null
if [ $? -eq 0 ];then
	groups=$($cmd --group-status |grep "\[E\]"|awk '{print $2}')
	master=$($cmd --group-status |grep "\[E\]"|awk '{print $4}')
	for group in $groups
	do 
	#echo $group
	gid=$(echo $group | awk -F "-" '{print $NF}')
	#echo $gid
	#$cmd --group-status |grep $group | grep -v $master
	slave=$($cmd --group-status |grep $group | grep -v "\[E\]"|awk '{print $4}'|head -n 1)
	#slave=$($cmd --group-status |grep -v "\[E\]"|grep $group |awk '{print $NF}'|awk -F ":" '{print $1}')
	$cmd --promote-server --gid=$gid --addr $slave
	done
fi

