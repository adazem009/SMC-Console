#!/bin/bash

reduce=`cat reduce`
if [[ "$2" == '' ]]; then
	compiler="./compiler"
else
	compiler="$2"
fi
auto="$3"
cd "$(dirname $BASH_SOURCE)"
source CONFIG
if ! [ -d "$compiler" ]; then
	echo "Error: PowerSlash compiler not found. Did you run sync.sh?"
	exit 1
fi
cd "$compiler"
if ! [ -f "compile.sh" ]; then
	echo "Error: Couldn't find compiler script."
	exit 2
fi
if [ -d include ]; then
	rm -rf include
elif [ -f include ]; then
	echo "Error: 'include' must be a directory."
	exit 2
fi
ln -s ../include include
chmod +x compile.sh
if [[ "$1" == '' ]]; then
	name=main
	ext=pwsl
else
	n="$1"
	name1=""
	name2=""
	i=0
	while (( i < ${#n} )); do
		i=$((i+1))
		if [[ "${n:$((i-1)):1}" == "." ]]; then
			name1="$name2"
			name2=""
		else
			name2="${name2}${n:$((i-1)):1}"
		fi
	done
	if [[ "$name1" == "" ]]; then
		name1="$name2"
		name2=""
	fi
	name="$name1"
	ext="$name2"
fi
if ! [ -f "../${name}.$ext" ]; then
	echo "Error: ${name}.${ext}: No such file."
	exit 3
fi
# Set version
tmp0='"'
echo 'linkdef/"_getver","gv"
{' > include/version.pwsl
echo "	set/${tmp0}VER${tmp0},${tmp0}${CONFIG_VERSION}${tmp0}" >> include/version.pwsl
echo '}' >> include/version.pwsl
# Compile
echo "Compiling ${name}.$ext"
./compile.sh "../${name}.$ext" "$reduce" "" "$auto"
case "$CONFIG_CONVERT" in
	y)
		IFS=$'\r\n' GLOBIGNORE='*' command eval  'smc=($(cat ./output/${name}.smc))'
		echo "Creating BIOS image..."
		image=""
		i=0
		while (( i < ${#smc[@]} )); do
			i=$((i+1))
			echo -e "\e[1A\e[KCreating BIOS image... line $i of ${#smc[@]}..."
			line="${smc[$((i-1))]}"
			len=${#line}
			image="${image}${len};${line}"
		done
		echo "$image" > ../image
		;;
	n)
		mv ./output/${name}.smc ../image
		;;
	*)
		echo "Error: Invalid value '$CONFIG_CONVERT' of CONFIG_CONVERT"
		exit 4
		;;
esac
