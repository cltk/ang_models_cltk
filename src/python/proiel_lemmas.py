import sys, re
import xml.etree.ElementTree as ET
import argparse

arg_parser = argparse.ArgumentParser(description='Extract lemmas from a PROIEL corpus, optionally merging with an existing file of lemmas.')
arg_parser.add_argument('-f', '--lemma_file', default=None, help='File of existing lemmas and forms')
arg_parser.add_argument('xml_files', nargs="*")

if __name__ == '__main__':
	args = arg_parser.parse_args(sys.argv[1:])

	lemmas = {}

	if args.lemma_file:
		with open(args.lemma_file, 'r') as infile:
			rows = infile.read().splitlines()
			for row in rows:
				tokens = row.split('\t')
				lemma = tokens[0].lower()
				forms = lemmas.get(lemma, [])
				forms += tokens[1:]
				lemmas[lemma] = forms


	for xml_file in args.xml_files:
		root = ET.parse(xml_file).getroot()

		for sentence in root.iter('sentence'):
			for token in sentence.iter('token'):
				if token.attrib.get('empty-token-sort'):
					continue

				form = token.attrib['form']
				form = form.replace(' ', '.')
				form = form.replace('\xa0', '.') # hack for crazy space encoding in some PROIEL files

				lemma = token.attrib['lemma'].lower()
				forms = lemmas.get(lemma, [])
				forms.append(form)
				lemmas[lemma] = forms

	for lemma in lemmas.keys():
		print (lemma + "\t" + "\t".join(set(lemmas[lemma])))
