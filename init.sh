#!/bin/bash 
#Name:init.sh
#Auther:hongyu
#Desc:
#Usage:
#Path:/home/hongyu
#Update:Tue 15 Sep 2020 02:43:10 PM CST
#!/bin/sh
#

runzynqmp(){
	mkdir -p /mnt/ram
	#mkdir -p /var/log/boa
	#cp /mnt/flash/boa/mime.types /etc
	#/mnt/flash/boa/boa -c /mnt/flash/boa

	cd /mnt/flash
	dir=$(pwd)
	for var in $(ls /mnt/flash)    # 判断au/eu/ru目录中所有的文件
	do
		if [[ $var == smallbase*.d ]]     # 查找对应的应用程序文件
		then
			cp -rf $dir/$var /mnt/ram/zynqmp.d
		fi
		if [[ $var == dpd-host ]]
		then
			cp $dir/$var /home/root
		fi
		if [[ $var == fun ]]
		then
			cp $dir/$var /usr/bin
		fi
	done

	printf "\033c"
	echo "-------- Run App ---------"
	read -t 5 -n 1 -p "do you want to run App [Y/n] :" ack

	case $ack in 
		N|n)
			echo "----- App Stop -----"
			exit 1 ;;
		*)
		 	#dpd-smp -u 0 &
			/mnt/ram/zynqmp.d &
			sleep 1 ;;
	esac

	read -t 5 -n 1 -p "do you want to stop App [Y/n] :" Ack
	
	case $Ack in 
		Y|y)
			set -e
			kill -9 $(ps -a | grep "zynqmp.d" | sed '/grep/d' | cut -d' ' -f2)	
			echo "----- App Stop -----" ;;
		*)
			;;
	esac 
}

mkdir -p /lib/firmware
ifconfig eth0 10.0.0.136 netmask 255.255.0.0
runzynqmp

