#!/usr/bin/awk  -f

/^$/ { 
	print "\n"
	next
}

{
	printf "%s/%s ", $2, $5
}
