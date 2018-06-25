#!/usr/bin/awk  -f

/^$/ { 
	print
	next
}

{
	printf "%s/%s ", $2, $5
}
