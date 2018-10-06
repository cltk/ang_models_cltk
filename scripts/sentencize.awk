#!/usr/bin/gawk -f

{
	text = text " " $0
}

END {
	gsub(/  +/, " ", text)
	split(text, sents, /[.?!] */)
	for (i in sents) {
		print sents[i] "."
	}
}