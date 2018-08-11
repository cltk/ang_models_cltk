#!/usr/bin/awk  -f

$1 != sentence_id { 
	print ""
}

{
	printf "%s/%s%s ", $2, $3, $4
	sentence_id = $1
}
