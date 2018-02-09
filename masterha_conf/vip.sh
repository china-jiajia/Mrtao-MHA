#!/bin/bash

source /etc/profile


AVIP="10.96.28.140/32"
DVIP="10.96.28.140/0"
IP='/sbin/ip' 


add_vip(){
	$IP  addr add $AVIP dev bond0
}

del_vip(){
	$IP  addr del $DVIP dev bond0
}

vip_status(){
	 $IP a  
}


case "$1" in
		add_vip)
		add_vip
		;;
		del_vip)
		del_vip
		;;
		vip_status)
		vip_status
		;;
		*)
		echo -e  "\033[32mUsage: service `basename $0` {add_vip|del_vip|vip_status}\033[0m"
		exit 2
		;;
esac
