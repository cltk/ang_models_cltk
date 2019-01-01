function decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl) {
	printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl
}

function conjugate(type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc) {
	printf "type=%s\tclass=%s\t", type, class
	printf "%s\t%s\t", infinitive, infinitive2
	printf "%s\t%s\t%s\t%s\t%s\t", sg1_pres_indc, sg2_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj
	printf "%s\t%s\t%s\t%s\t%s\t", sg1_past_indc, sg2_past_indc, pl_past_indc, sg_past_subj, pl_past_subj
	printf "%s\t%s\t", sg_impr, pl_impr
	printf "%s\t%s\t", pres_ptc, past_ptc
	printf "\n"
}

function pos_param(pos,  a) {
	orig_pos = pos
	split($0, a, /\|/)
	delete a[1]

	diff = 2
	while (a[diff] ~ /=/) diff++
	pos += diff - 1

	gsub(/}/, "", a[pos])

	if (debug) print "pos " orig_pos " (actual " pos ")=" a[pos]
	return a[pos]
}

function named_param(key,  a) {
	if (match($0, key "= ?([^|{}]*)[|{}]", a)) {
		if (debug) print key "=" a[1]
		return a[1]
	} else {
		return 0
	}
}

function get_basic_vars() {
	pos1 = pos_param(1)
	pos2 = pos_param(2)

	alt1 = named_param("alt1")
	alt2 = named_param("alt2")
}

/ang-decl-noun-a-n/ {
	get_basic_vars()

	nomsg = named_param("nomsg")
	altnomsg = named_param("altnomsg")
	short = named_param("short")

	nom_sing = altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1
	acc_sing = nom_sing
	gen_sing = (alt1 ? alt1 : pos1) "es"
	dat_sing = (alt1 ? alt1 : pos1) "e"

	if (short) 
		nom_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) "u"
	else
		nom_pl = altnomsg ? altnomsg : nomsg ? nomsg : alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1
	acc_pl = nom_pl
	gen_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) "a"
	dat_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) "um"

	decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-a-m/ {
	get_basic_vars()

	datsg = named_param("datsg")
	vowel = named_param("vowel")

	nom_sing = altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1
	acc_sing = nom_sing
	gen_sing = (alt1 ? alt1 : pos1) (vowel ? "" : "e") "s"
	dat_sing = (datsg ? datsg : alt1 ? alt1 : pos1) (vowel ? "" : "e")

	nom_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) (vowel ? "" : "a") "s"
	acc_pl = nom_pl
	gen_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) (vowel ? "n" : "") "a"
	dat_pl = (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) (vowel ? "" : "u") "m" (vowel ? ("," (alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1) "um") : "")

	decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-cons-m/ {
	get_basic_vars()

	nom_sing = alt1 ? alt1 : pos1
	acc_sing = nom_sing
	gen_sing = nom_sing "es"
	dat_sing = alt2 ? alt2 : pos2 

	nom_pl = dat_sing
	acc_pl = nom_pl
	gen_pl = nom_sing "a"
	dat_pl = nom_sing "um"

	decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
}

/ang-decl-noun-n-f/ {
	get_basic_vars()

	stem_sing = alt1 ? alt1 : pos1
	nom_sing = stem_sing "e"
	acc_sing = stem_sing "an"
	gen_sing = acc_sing
	dat_sing = gen_sing

	stem_pl = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1
	nom_pl = stem_pl "an"
	acc_pl = nom_pl
	gen_pl = stem_pl "ena"
	dat_pl = stem_pl "um"

	decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
}

/ang-decl-noun-o-f/ {
	get_basic_vars()

	nomsg = named_param("nomsg")
	altnomsg = named_param("altnomsg")
	short = named_param("short")

	stem = alt1 ? alt1 : pos1
	nom_sing = (altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1) (short ? "u" : "")
	acc_sing = stem "e"
	gen_sing = acc_sing
	dat_sing = gen_sing

	nom_pl = stem "a" "," acc_sing
	acc_pl = nom_pl
	gen_pl = stem "a"
	dat_pl = stem "um"

	decline(nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
}

/ang-conj\|/ {
	type = named_param("type")
	class = named_param("class")

	infinitive = pos_param(1)
	infinitive2 = pos_param(2)

	sg1_pres_indc = pos_param(3)
	sg2_pres_indc = pos_param(4)
	sg3_pres_indc = pos_param(5)
	pl_pres_indc  = pos_param(6)
	sg_pres_subj  = pos_param(7)
	pl_pres_subj  = pos_param(8)

	sg1_past_indc = pos_param(9)
	sg2_past_indc = pos_param(10)
	sg3_past_indc = pos_param(11)
	pl_past_indc  = pos_param(12)
	sg_past_subj  = pos_param(13)
	pl_past_subj  = pos_param(14)

	sg_impr = pos_param(15)
	pl_impr = pos_param(16)

	pres_ptc = pos_param(17)
	past_ptc = pos_param(18)

	conjugate(type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc)
}

