#!/usr/bin/gawk -f

{
	text = text $0
}

END {
	split(text, sentences, /[\.\?\!]/)
	for (i in sentences) {
		print sentences[i] "."
	}
}