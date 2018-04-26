#!/bin/bash 

project_name="CleanLocalizableExample"
development_file="./"$project_name"/en.lproj/Localizable.strings"

es_duplicates=9
es_match=8
es_not_included=7

sort_and_find_duplicates() {
	echo "== Sorting localizable files: $1 =="
 	sed -i '' '/^$/d' $1 #deletes whitespace lines
  sort $1 -o $1 #sorts file
	duplicates=`sed 's/^[^"]*"\([^"]*\)".*/\1/' $1 | uniq -d`
	if [ ! -z "${duplicates}" ]; then
		echo "error: Found duplicated keys"
		echo "error: $duplicates in file: $1"
		exit $es_duplicates
	fi
}

keys_match() {
	echo "== Checking if keys match in localizable files: $1 =="
	base_keys=`sed 's/^[^"]*"\([^"]*\)".*/\1/' "$development_file"`
	localizable_keys=`sed 's/^[^"]*"\([^"]*\)".*/\1/' $1`
	is_different=`diff <(echo "$base_keys") <(echo "$localizable_keys")`
	
	if [ ! -z "${is_different}" ]; then
		echo "error: Localizable string keys do not match"
		echo "error: $is_different in file: $1" 
		exit $es_match
	fi
}

keys_not_used() {	
	echo "== Checking keys not used in code =="
	sed 's/^[^"]*"\([^"]*\)".*/\1/' "$development_file" | 
	while read key; do
		exist=`grep -rl "NSLocalizedString(\"$key\"" --include \*.swift --include \*.m ./"$project_name"/*`
		if [ -z "${exist}" ]; then
			echo "warning: Found keys not used in code"
			echo "warning: \"$key\" is not used being used"
		fi
	done
}

keys_not_included() {
	echo "== Checking keys not included in localizable =="
	base_keys=`sed 's/^[^"]*"\([^"]*\)".*/\1/' "$development_file"`	
	# grep NSLocalizedString("anything until first quotes" | sed everything in between quotes | sort and unique
	grep -r -o "NSLocalizedString(\"[^\"]*\"" --include \*.swift --include \*.m ./"$project_name"/* --exclude ./"$project_name"/NSLocalizedString.swift | 
	grep -v "%d" |
	sed 's/^[^"]*"\([^"]*\)".*/\1/' | 
	sort -u | 
	while read key; do
		if [[ $base_keys != *$key* ]]; then
			echo "error: Found keys not included in localizable file"
			echo "error: \"$key\" not define in file: $1"
			exit $es_not_included
		fi
	done
}


find ./"$project_name" -name 'Localizable.strings' |
while read file; do
  sort_and_find_duplicates $file
	keys_match $file
 	echo ""
done
keys_not_used
keys_not_included
