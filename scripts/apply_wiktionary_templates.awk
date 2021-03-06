#!/usr/bin/gawk -f

BEGIN {
	FS = "\t"
}

function clean_title(word,   a) {
	if (word ~ /Reconstruction/) {
		split(word, a, /\//)
		return a[2]
	} else {
		return word
	}
}

function decline_noun(word, type, nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl) {
	word = clean_title(word)

	if (no_pos) {
		printf "%s\t", word
		} else {
		printf "%s\tnoun\t%s\t", word, type
	}
	printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl
}

function decline_adj(word, type, nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m,
		nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f,
		nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n,
		nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m,
		nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f,
		nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n) {
	word = clean_title(word)

	if (no_pos) {
		printf "%s\t", word
		} else {
		printf "%s\tadjective\t%s\t", word, type
	}
	printf "%s\t%s\t%s\t%s\t%s\t", nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m
	printf "%s\t%s\t%s\t%s\t%s\t", nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f
	printf "%s\t%s\t%s\t%s\t%s\t", nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n
	printf "%s\t%s\t%s\t%s\t%s\t", nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m
	printf "%s\t%s\t%s\t%s\t%s\t", nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f
	printf "%s\t%s\t%s\t%s\t%s",   nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n
	printf "\n"

}

function conjugate(word, type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc) {
	word = clean_title(word)

	if (no_pos) {
		printf "%s\t", word
		} else {
		printf "%s\tverb\t%s\t%s\t", word, type, class
	}
	printf "%s\t%s\t", infinitive, infinitive2
	printf "%s\t%s\t%s\t%s\t%s\t%s\t", sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj
	printf "%s\t%s\t%s\t%s\t%s\t%s\t", sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj
	printf "%s\t%s\t", sg_impr, pl_impr
	printf "%s\t%s", pres_ptc, past_ptc
	printf "\n"
}

function expand_variants(form,   a) {
	split(form, a, /, */)

	forms = ""
	for (i in a) {
		forms = (forms == "" ? "" : (forms ","))

		if (a[i] ~ /^\(.*\)$/) {
			form = substr(a[i], 2, length(a[i]) - 2)
			forms = forms form
		}
		else if (a[i] ~ /\((.*)\)/) {
			form1 = gensub(/\(([^)]+)\)/, "", 1, a[i])
			form2 = gensub(/\(([^)]+)\)/, "\\1", 1, a[i])
			forms = forms form1 "," form2
		} else {
			forms = forms a[i]
		}
	}

	return forms
}

function remove_markup(x) {
	x = gensub(/[\[\]]/, "", "g", x)
	x = gensub(/&lt;!--.*--&gt;/, "", "g" ,x)
	return expand_variants(x)
}


function pos_param(pos,  a, b) {
	params = gensub(/\{\{l\|ang\|([^}]+)\}\}/, "\\1", "g", $2)

	split(params, a, /\|/)
	
	i = 2
	j = 1
	while (i <= length(a)) {
		if (a[i] !~ /=/) {
			b[j] = a[i]
			j++
		}
		i++
	}

	gsub(/}/, "", b[pos])

	if (debug) print "pos " pos "= " b[pos]
	return remove_markup(b[pos])
}

function named_param(key,  a) {
	if (match($2, key "= ?([^|{}]*)[|{}]", a)) {
		if (debug) print key "=" a[1]
		return remove_markup(a[1])
	} else {
		if (debug) print "cannot find " key
		return 0
	}
}

function get_basic_vars() {
	pos1 = pos_param(1)
	pos2 = pos_param(2)

	alt1 = named_param("alt1")
	alt2 = named_param("alt2")
}

$1 ~ /^-/ {
	next
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

	decline_noun($1, "strong a-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
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

	decline_noun($1, "strong a-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
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

	decline_noun($1, "strong consonant stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
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

	decline_noun($1, "weak", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
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

	decline_noun($1, "strong ō-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
}

/ang-decl-noun-ja-m/ {
	get_basic_vars()

	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	nom_sing = stem1 "e"
	acc_sing = nom_sing
	gen_sing = stem1 "es"
	dat_sing = nom_sing

	nom_pl = stem2 "as"
	acc_pl = nom_pl
	gen_pl = stem2 "a"
	dat_pl = stem2 "um"

	decline_noun($1, "strong ja-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-ja-n/ {
	get_basic_vars()

	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	nom_sing = stem1 "e"
	acc_sing = nom_sing
	gen_sing = stem1 "es"
	dat_sing = nom_sing

	nom_pl = stem2 "u"
	acc_pl = nom_pl
	gen_pl = stem2 "a"
	dat_pl = stem2 "um"

	decline_noun($1, "strong ja-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-i-f/ {
	get_basic_vars()

	short = named_param("short")

	stem = alt1 ? alt1 : pos1

	nom_sing = stem (short ? "e" : "")
	acc_sing = (short ? "" : (stem ",")) stem "e"
	gen_sing = stem "e"
	dat_sing = stem "e"

	nom_pl = stem "e" "," stem "a"
	acc_pl = nom_pl
	gen_pl = stem "a"
	dat_pl = stem "um"

	decline_noun($1, "strong i-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-u-f/ {
	get_basic_vars()

	short = named_param("short")

	stem = alt1 ? alt1 : pos1

	nom_sing = stem (short ? "u" : "")
	acc_sing = nom_sing
	gen_sing = stem "a"
	dat_sing = stem "a"

	nom_pl = stem "a"
	acc_pl = nom_pl
	gen_pl = nom_pl
	dat_pl = stem "um"

	decline_noun($1, "strong u-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-n-m/ {
	get_basic_vars()

	vowel = named_param(vowel)

	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	nom_sing = stem1 (vowel ? "" : "a")
	acc_sing = nom_sing "n"
	gen_sing = acc_sing
	dat_sing = acc_sing

	nom_pl = stem2 (vowel ? "" : "a") "n"
	acc_pl = nom_pl
	gen_pl = stem2 (vowel ? "" : "e") "na"
	dat_pl = stem2 (vowel ? "" : "u") "m"

	decline_noun($1, "weak", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-n-f/ {
	get_basic_vars()

	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	nom_sing = stem1 "e"
	acc_sing = stem1 "an"
	gen_sing = acc_sing
	dat_sing = acc_sing

	nom_pl = stem2 "an"
	acc_pl = nom_pl
	gen_pl = stem2 "ena"
	dat_pl = stem2 "um"

	decline_noun($1, "weak", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-i-m/ {
	get_basic_vars()

	short = named_param("short")

	stem = alt1 ? alt1 : pos1

	nom_sing = stem (short ? "e" : "")
	acc_sing = nom_sing
	gen_sing = stem "es"
	dat_sing = stem "e"

	nom_pl = stem "e" "," stem1 "as"
	acc_pl = nom_pl
	gen_pl = stem "a"
	dat_pl = stem "um"

	decline_noun($1, "strong i-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}

/ang-decl-noun-i-f/ {
	get_basic_vars()

	short = named_param("short")

	stem = alt1 ? alt1 : pos1

	nom_sing = stem (short ? "e" : "")
	acc_sing = (short ? "" : (stem ",")) stem "e" 
	gen_sing = stem "e"
	dat_sing = gen_sing

	nom_pl = stem "e" "," stem1 "as"
	acc_pl = nom_pl
	gen_pl = stem "a"
	dat_pl = stem "um"

	decline_noun($1, "strong i-stem", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)
}


/ang-decl-noun\|/ {
	nom_sing = pos_param(1)
	acc_sing = pos_param(3)
	gen_sing = pos_param(5)
	dat_sing = pos_param(7)

	nom_pl = pos_param(2)
	acc_pl = pos_param(4)
	gen_pl = pos_param(6)
	dat_pl = pos_param(8)

	nom_sing == "-" ? "-" : nom_sing
	acc_sing == "-" ? "-" : acc_sing
	gen_sing == "-" ? "-" : gen_sing
	dat_sing == "-" ? "-" : dat_sing

	nom_pl == "-" ? "-" : nom_pl
	acc_pl == "-" ? "-" : acc_pl
	gen_pl == "-" ? "-" : gen_pl
	dat_pl == "-" ? "-" : dat_pl

	decline_noun($1, "", nom_sing, acc_sing, gen_sing, dat_sing, nom_pl, acc_pl, gen_pl, dat_pl)	
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

	conjugate($1, type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc)
}

/ang-conj-strong/ {
	stem1 = pos_param(1)
	stem2 = pos_param(2)
	stem3 = pos_param(3)
	stem4 = pos_param(4)

	mutstem = named_param("mutstem")
	pp_g = named_param("pp_g")
	pp = named_param("pp")

	type = "strong"
	class = named_param("class")

	infinitive = stem1 "an"
	infinitive2 = stem1 "enne"

	sg1_pres_indc = stem1 "e"
	sg2_pres_indc = (mutstem ? mutstem : stem1) "est"
	sg3_pres_indc = (mutstem ? mutstem : stem1) "eþ"
	pl_pres_indc  = stem1 "aþ"
	sg_pres_subj  = sg1_pres_indc
	pl_pres_subj  = stem1 "en"

	sg1_past_indc = stem2
	sg2_past_indc = stem3 "e"
	sg3_past_indc = sg1_past_indc
	pl_past_indc  = stem3 "on"
	sg_past_subj  = stem3 "e"
	pl_past_subj  = stem3 "en"

	sg_impr = stem1
	pl_impr = pl_pres_indc

	pres_ptc = stem1 "ende"
	past_ptc = pp_g ? ("ġe" pp_g "," pp_g) : pp ?  pp : ("ġe" stem4 "en" "," stem4 "en")

	conjugate($1, type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc)

}

/ang-conj-weak-1/ {
	stem1 = pos_param(1)
	stem2 = pos_param(2)
	stem3 = pos_param(3)
	
	sg1 = named_param("1sg")
	sg2 = named_param("2sg")
	sg3 = named_param("3sg")
	subj_pl = named_param("subj_pl")
	imp = named_param("imp")
	imp_pl = named_param("imp_pl")
	pp_g = named_param("pp_g")
	pp = named_param("pp")

	type = "weak"
	class = "1"

	infinitive = stem1 "an"
	infinitive2 = stem1 "enne"

	sg1_pres_indc = sg1 ? sg1 : (stem1 "e")
	sg2_pres_indc = sg2 ? sg2 : ((stem2 ? stem2 : stem1) "st")
	sg3_pres_indc = sg2 ? sg2 : ((stem2 ? stem2 : stem1) "þ")
	pl_pres_indc  = stem1 "aþ"
	sg_pres_subj  = stem1 "e"
	pl_pres_subj  = subj_pl ? subj_pl : (stem1 "en")

	past_stem = (stem3 ? stem3 : stem2 ? stem2 : stem1)
	sg1_past_indc = past_stem "e"
	sg2_past_indc = past_stem "est"
	sg3_past_indc = sg1_past_indc
	pl_past_indc  = past_stem "on"
	sg_past_subj  = past_stem "e"
	pl_past_subj  = past_stem "en"

	sg_impr = imp ? imp : stem1
	pl_impr = imp_pl ? imp_pl : pl_pres_indc

	pres_ptc = stem1 "ende"
	past_ptc = pp_g ? ("ġe" pp_g "," pp_g) : pp ?  pp : ("ġe" stem1 "ed" "," stem1 "ed")

	conjugate($1, type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc)

}

/ang-conj-weak-2/ {
	stem = pos_param(1)
	
	pp_g = named_param("pp_g")
	pp = named_param("pp")

	type = "weak"
	class = "2"

	infinitive = stem "ian"
	infinitive2 = stem "ienne"

	sg1_pres_indc = stem "ie" "," stem "iġe"
	sg2_pres_indc = stem "ast"
	sg3_pres_indc = stem "aþ"
	pl_pres_indc  = stem "iaþ" "," stem "iġaþ"
	sg_pres_subj  = sg1_pres_indc
	pl_pres_subj  = stem "ien" "," stem "iġen"

	sg1_past_indc = stem "ode"
	sg2_past_indc = stem "odest"
	sg3_past_indc = sg1_past_indc
	pl_past_indc  = stem "odon"
	sg_past_subj  = sg1_past_indc
	pl_past_subj  = sg_past_subj "n"

	sg_impr = stem "a"
	pl_impr = pl_pres_indc

	pres_ptc = stem "iende" "," stem "iġende"
	past_ptc = pp_g ? ("ġe" pp_g "," pp_g) : pp ?  pp : ("ġe" stem "od" "," stem "od")

	conjugate($1, type, class,
		infinitive, infinitive2, 
		sg1_pres_indc, sg2_pres_indc, sg3_pres_indc, pl_pres_indc, sg_pres_subj, pl_pres_subj, 
		sg1_past_indc, sg2_past_indc, sg3_past_indc, pl_past_indc, sg_past_subj, pl_past_subj,
		sg_impr, pl_impr,
		pres_ptc, past_ptc)

}

function adj_strong() {
	get_basic_vars()

	nomsg = named_param("nomsg")
	altnomsg = named_param("altnomsg")
	short = named_param("short")
	
	nom_stem = altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1
	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	# Strong declension

	# Singular
	nom_sg_m = nom_stem
	acc_sg_m = stem1 "ne"
	gen_sg_m = stem2 "es"
	dat_sg_m = stem2 "um"
	ins_sg_m = stem2 "e"

	nom_sg_f = short ? (stem2 "u," stem2 "o") : nom_stem
	acc_sg_f = stem2 "e"
	gen_sg_f = stem1 "re"
	dat_sg_f = gen_sg_f
	ins_sg_f = gen_sg_f

	nom_sg_n = nom_sg_m
	acc_sg_n = nom_sg_m
	gen_sg_n = gen_sg_m
	dat_sg_n = dat_sg_m
	ins_sg_n = ins_sg_m

	# Plural
	nom_pl_m = stem2 "e"
	acc_pl_m = nom_pl_m
	gen_pl_m = stem1 "ra"
	dat_pl_m = dat_sg_m
	ins_pl_m = dat_sg_m

	nom_pl_f = stem2 "a," nom_pl_m
	acc_pl_f = nom_pl_f
	gen_pl_f = gen_pl_m
	dat_pl_f = dat_pl_m
	ins_pl_f = ins_pl_m

	nom_pl_n = nom_sg_f
	acc_pl_n = nom_pl_n
	gen_pl_n = gen_pl_f
	dat_pl_n = dat_pl_f
	ins_pl_n = ins_pl_f

	decline_adj($1, "strong", nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m,
		nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f,
		nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n,
		nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m,
		nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f,
		nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n)
}

function adj_weak() {
	get_basic_vars()

	nomsg = named_param("nomsg")
	altnomsg = named_param("altnomsg")
	short = named_param("short")
	
	nom_stem = altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1
	stem1 = alt1 ? alt1 : pos1
	stem2 = alt2 ? alt2 : pos2 ? pos2 : alt1 ? alt1 : pos1

	# Weak declension

	# Singular
	nom_sg_m = stem2 "a"
	acc_sg_m = stem2 "an"
	gen_sg_m = acc_sg_m
	dat_sg_m = acc_sg_m
	ins_sg_m = acc_sg_m

	nom_sg_f = stem2 "e"
	acc_sg_f = acc_sg_m
	gen_sg_f = acc_sg_m
	dat_sg_f = acc_sg_m
	ins_sg_f = acc_sg_m	

	nom_sg_n = nom_sg_f
	acc_sg_n = nom_sg_f
	gen_sg_n = acc_sg_m
	dat_sg_n = acc_sg_m
	ins_sg_n = acc_sg_m

	# Plural
	nom_pl_m = acc_sg_m
	acc_pl_m = acc_sg_m
	gen_pl_m = stem1 "ra" "," stem2 "ena"
	dat_pl_m = stem2 "um"
	ins_pl_m = dat_pl_m

	nom_pl_f = nom_pl_m
	acc_pl_f = acc_pl_m
	gen_pl_f = gen_pl_m
	dat_pl_f = dat_pl_m
	ins_pl_f = ins_pl_m

	nom_pl_n = nom_sg_m
	acc_pl_n = acc_pl_m
	gen_pl_n = gen_pl_m
	dat_pl_n = dat_pl_m
	ins_pl_n = ins_pl_m

	decline_adj($1, "weak", nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m,
		nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f,
		nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n,
		nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m,
		nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f,
		nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n)
}

/ang-decl-adj\|/ {
	adj_strong()
	adj_weak()
}

/ang-decl-adj-con\|/ {
	get_basic_vars()

	pos3 = pos_param(3)

	nomsg = named_param("nomsg")
	altnomsg = named_param("altnomsg")
	short = named_param("short")
	alt3 = named_param("alt3")
	alt4 = named_param("alt4")

	stem1 = (alt1 ? alt1 : pos1) pos2 pos3
	stem2 = (alt4 ? alt4 : pos4 ? pos4 : alt1 ? alt1 : pos1) pos3
	stem3 = (alt4 ? alt4 : pos4 ? pos4 : alt1 ? alt1 : pos1) pos2 pos3

	# Strong Declension

	# Singular
	nom_sg_m = (altnomsg ? altnomsg : nomsg ? nomsg : alt1 ? alt1 : pos1) pos2 pos3
	acc_sg_m = stem1 "ne"
	gen_sg_m = stem2 "es" "," stem3 "es"
	dat_sg_m = stem2 "um" "," stem3 "um"
	ins_sg_m = stem2 "e"  "," stem3 "e"

	nom_sg_f = short ? (stem2 "u") : nom_sg_m
	acc_sg_f = stem2 "e" "," stem3 "e"
	gen_sg_f = stem3 "re"
	dat_sg_f = gen_sg_f
	ins_sg_f = gen_sg_f

	nom_sg_n = nom_sg_m
	acc_sg_n = acc_sg_m
	gen_sg_n = gen_sg_m
	dat_sg_n = dat_sg_m
	ins_sg_n = ins_sg_m

	#Plural
	nom_pl_m = stem2 "es" "," stem3 "es"
	acc_pl_m = nom_pl_m
	gen_pl_m = stem1 "ra"
	dat_pl_m = dat_sg_m
	ins_pl_m = dat_pl_m

	nom_pl_f = stem2 "a" "," stem2 "e" "," stem3 "a" "," stem3 "e"
	acc_pl_f = nom_pl_f
	gen_pl_f = gen_pl_m
	dat_pl_f = dat_pl_m
	ins_pl_f = ins_pl_m

	nom_pl_n = short ? (stem2 "u" "," stem3 "u") : nom_sg_m
	acc_pl_n = nom_pl_f
	gen_pl_n = gen_pl_m
	dat_pl_n = dat_pl_m
	ins_pl_n = ins_pl_m

	decline_adj($1, "strong", nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m,
		nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f,
		nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n,
		nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m,
		nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f,
		nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n)

	# Weak declension

	# Singular
	nom_sg_m = stem2 "a" "," stem3 "a"
	acc_sg_m = stem2 "an" "," stem3 "an"
	gen_sg_m = acc_sg_m
	dat_sg_m = acc_sg_m
	ins_sg_m = acc_sg_m

	nom_sg_f = stem2 "e" "," stem3 "e"
	acc_sg_f = acc_sg_m
	gen_sg_f = acc_sg_m
	dat_sg_f = acc_sg_m
	ins_sg_f = acc_sg_m

	nom_sg_n = nom_sg_m
	acc_sg_n = nom_sg_m
	gen_sg_n = acc_sg_m
	dat_sg_n = acc_sg_m
	ins_sg_n = acc_sg_m

	#Plural
	nom_pl_m = acc_sg_m
	acc_pl_m = acc_sg_m
	gen_pl_m = stem1 "ra" "," stem2 "ena" "," stem3 "ena"
	dat_pl_m = stem2 "um" "," stem3 "um"
	ins_pl_m = dat_pl_m

	nom_pl_f = nom_pl_m
	acc_pl_f = acc_pl_m
	gen_pl_f = gen_pl_m
	dat_pl_f = dat_pl_m
	ins_pl_f = ins_pl_m

	nom_pl_n = nom_pl_m
	acc_pl_n = nom_pl_m
	gen_pl_n = gen_pl_m
	dat_pl_n = dat_pl_m
	ins_pl_n = ins_pl_m

	decline_adj($1, "weak", nom_sg_m, acc_sg_m, gen_sg_m, dat_sg_m, ins_sg_m,
		nom_sg_f, acc_sg_f, gen_sg_f, dat_sg_f, ins_sg_f,
		nom_sg_n, acc_sg_n, gen_sg_n, dat_sg_n, ins_sg_n,
		nom_pl_m, acc_pl_m, gen_pl_m, dat_pl_m, ins_pl_m,
		nom_pl_f, acc_pl_f, gen_pl_f, dat_pl_f, ins_pl_f,
		nom_pl_n, acc_pl_n, gen_pl_n, dat_pl_n, ins_pl_n)
}

/ang-decl-adj-strong/ {
	adj_strong()
}

/ang-decl-adj-weak/ {
	adj_weak()
}


