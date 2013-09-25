#!/bin/bash

usr="13Test"
password="tset31"
loginurl="http://www.tangoriki.com/login.php"
wordlist="words"
answer=""

curl -c cookie -d "usr=$usr&pwd=$password" "$loginurl" > /dev/null 2>&1
for ((x = 0; x < 1; x++))
do
	curl -b cookie "http://www.tangoriki.com/exam.php?mode=level&op=4" -o htmfile
	grep -A2 '<td class="word">' htmfile | sed '/^--$/d' > wdtst
	for ((i = 0; i < 10; i++))
	do
		n=$((i * 3 + 1))
		word=$(head -$n wdtst | tail -1 | sed "s/>/>\\`echo -e '\n\r'`/g" | sed "s/</\\`echo -e '\n\r'`</g" | grep "[a-z]\{1,\}" | sed "s///g")
		trans=$(grep -A1 "^$word$" $wordlist | tail -1)
		value=$(grep -n $trans wdtst | cut -d":" -f1)
		value=$(($value % 3))
		if [ $value -eq 0 ];then
			value=3
		fi
		if [ "$answer" == "" ];then
			answer=ans[$i]=$value
		else
			answer=${answer}'&'ans[$i]=$value
		fi
	done

	echo $answer
	curl -b cookie -d "$answer" "http://www.tangoriki.com/ans.php?mode=level&op=4" -o a.htm
done
