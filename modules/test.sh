#!/bin/bash

#IFS=" " read -ra modified <<< $(git status --porcelain .); declare -p modified;
#echo $modified;
IFS=$'\n'
for line in $(git ls-files -m . | xargs -n 1 dirname | uniq); do
	IFS=$'/' read -ra newline <<< "$line";
	#echo ${newline[0]};
	#echo ${newline[1]};
	#echo "__________"
	#continue;
	if [[ -z ${newline[1]} ]]; then
		newname=${newline[0]};
		echo $newname;
		git add $newname;
		git commit -m "Updated module: $newname";
		git push;
	fi;
done;

exit;

for file in $(fd -IH -t d --max-depth 1 . .); do
	#echo $file;
	[[ -z $(git diff $file) ]] && echo "$file: new";
done
