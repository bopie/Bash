#!/bin/bash

usr=""
password=""
loginurl=""
seturl=""
wordurl=""
levels=100

rm words
curl -c cookie -d "usr=$usr&pwd=$password" "$loginurl" > /dev/null 2>&1
for ((n = 0; n < 10; n += 10))
do
	curl -b cookie "$seturl$n" > /dev/null 2>&1
	while :; do
		curl -b cookie "$wordurl" | grep -A2 '<td class="word">' | sed '/^--$/d' > filea
		curl -b cookie "$wordurl" | grep -A2 '<td class="word">' | sed '/^--$/d' > fileb
		for ((i = 3; i <= 30; i += 3))
		do
			head -$i filea | tail -3 | sed "s/>/>\\`echo -e '\n\r'`/g" | sed "s/</\\`echo -e '\n\r'`</g" | sort | uniq | tail -4 > tmp1
			head -$i fileb | tail -3 | sed "s/>/>\\`echo -e '\n\r'`/g" | sed "s/</\\`echo -e '\n\r'`</g" | sort | uniq | tail -4 > tmp2
			cat tmp1 tmp2 | sort | uniq -d >> tmp3	
		done
		if [ $(wc -l < tmp3) -eq 20 ]; then
			cat tmp3 >> words
			break
		fi
		rm tmp1 tmp2 tmp3
	done
done
rm tmp1 tmp2 tmp3 filea fileb
