#!/usr/bin/gawk -f

BEGIN {
	FS = "\t"
}

{
	for (i = 2; i <= NF; i++) {
		split($i, forms, ",")
		for (j in forms) {
			print forms[j] "\t" $1
		}
	}
}