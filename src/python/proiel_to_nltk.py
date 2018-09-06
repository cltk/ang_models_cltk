import sys, re
import xml.etree.ElementTree as ET
import argparse

arg_parser = argparse.ArgumentParser(description='Convert PROEL-tagged corpus from XML to NLTK POS tagger format.')
arg_parser.add_argument('-p', '--pos', default=False, action='store_true', help='Output POS tags.')
arg_parser.add_argument('-o', '--person', default=False, action='store_true', help='Output person tags.')
arg_parser.add_argument('-n', '--number', default=False, action='store_true', help='Output number tags.')
arg_parser.add_argument('-t', '--tense', default=False, action='store_true', help='Output tense tags.')
arg_parser.add_argument('-m', '--mood', default=False, action='store_true', help='Output mood tags.')
arg_parser.add_argument('-v', '--voice', default=False, action='store_true', help='Output voice tags.')
arg_parser.add_argument('-g', '--gender', default=False, action='store_true', help='Output gender tags.')
arg_parser.add_argument('-c', '--case', default=False, action='store_true', help='Output case tags.')
arg_parser.add_argument('-d', '--degree', default=False, action='store_true', help='Output degree tags.')
arg_parser.add_argument('-s', '--strength', default=False, action='store_true', help='Output strength tags.')
arg_parser.add_argument('-i', '--inflection', default=False, action='store_true', help='Output inflection tags.')



if __name__ == '__main__':
	args = arg_parser.parse_args(sys.argv[1:])

	root = ET.parse(sys.stdin).getroot()

	for sentence in root.iter('sentence'):
		for token in sentence.iter('token'):
			if token.attrib.get('empty-token-sort'):
				continue

			form = token.attrib['form']
			form = form.replace(' ', '.')
			form = form.replace('\xa0', '.') # hack for crazy space encoding in some PROIEL files

			pos = token.attrib['part-of-speech']
			morpho = token.attrib['morphology']

			if args.pos == True:
				tag = pos
			elif args.person == True:
				tag = morpho[0]
			elif args.number == True:
				tag = morpho[1]
			elif args.tense == True:
				tag = morpho[2]
			elif args.mood == True:
				tag = morpho[3]
			elif args.voice == True:
				tag = morpho[4]
			elif args.gender == True:
				tag = morpho[5]
			elif args.case == True:
				tag = morpho[6]
			elif args.degree == True:
				tag = morpho[7]
			elif args.strength == True:
				tag = morpho[8]
			elif args.inflection == True:
				tag = morpho[9]
			else: 
				tag = pos + morpho

			print("{0}/{1} ".format(form, tag), end='')

		print('')
