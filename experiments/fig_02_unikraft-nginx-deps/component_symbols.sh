#!/bin/bash
components=("vfscore" "uktimeconv" "posix-libdl" "posix-process" "posix-process" "posix-user" "ramfs" "ukalloc" "ukallocbbuddy" "ukargparse" "lib-lwip" "lib-newlib" "ukboot" "ukbus" "uklock" "ukmpi" "uknetdev" "uksched" "ukschedcoop" "uktime" "uksglist" "ukswrand")


#### FInd all the function calls in the module
MYPWD=${PWD}
for i in "${components[@]}"; do 
	echo "Extracting symbols for $i"
	cd unikraft/lib/$i && cscope -R -L -2 ".*" | grep -v "extern" | grep -v "/usr/" |  awk -F ' ' '{print $2}' | sort | uniq  > $MYPWD/$i.symbols
	cd $MYPWD
	#rm -rf cscope.*
done

cd $MYPWD

#### We now find the definition of each call, later during processing we will plot the data.
for i in "${components[@]}"; do 
	echo "Writing calees for each function from $i"

	echo "" > $i.deps;
	while read in; do 
		#cscope -d -L3 $in | awk -F '.c' '{print $1}' | uniq | grep linux >> $i.deps;
		if [[ $(cscope -d -L1 $in | uniq | grep unikraft | wc -l) -le 1 ]]; then
			cscope -d -L1 $in | uniq | grep unikraft >> $i.deps;
		fi
	done < $i.symbols
done
