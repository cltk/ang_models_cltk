#!/usr/bin/gawk -f

BEGIN {
	FS = "\t"
}

{
	for (i = 2; i <= NF; i++) {
		split($i, forms, ",")
		for (j in forms) {
			print $1 "\t" forms[j]
		}
	}
}