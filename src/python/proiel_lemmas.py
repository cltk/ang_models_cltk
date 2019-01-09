import sys, re
import xml.etree.ElementTree as ET



if __name__ == '__main__':
	root = ET.parse(sys.stdin).getroot()
	lemmas = {}

	for sentence in root.iter('sentence'):
		for token in sentence.iter('token'):
			if token.attrib.get('empty-token-sort'):
				continue

			form = token.attrib['form']
			form = form.replace(' ', '.')
			form = form.replace('\xa0', '.') # hack for crazy space encoding in some PROIEL files

			lemma = token.attrib['lemma']
			forms = lemmas.get(lemma, [])
			forms.append(form)
			lemmas[lemma] = forms

	for lemma in lemmas.keys():
		print (lemma + "\t" + "\t".join(set(lemmas[lemma])))
