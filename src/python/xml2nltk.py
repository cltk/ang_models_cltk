import sys, re
import xml.etree.ElementTree as ET
import argparse

arg_parser = argparse.ArgumentParser(description='Convert PROEL-tagged ISWOC corpus of Old English from XML to NLTK format.')
arg_parser.add_argument('-p', '--pos', default=False, action='store_true', help='Output POS tags only.')

if __name__ == '__main__':
	args = arg_parser.parse_args(sys.argv[1:])

	root = ET.parse(sys.stdin).getroot()

	for sentence in root.iter('sentence'):
		for token in sentence.iter('token'):
			if token.attrib.get('empty-token-sort'):
				continue
			form = token.attrib['form']
			form = form.replace(' ', '.')
			pos = token.attrib['part-of-speech']
			morpho = token.attrib['morphology']

			if args.pos == True:
				print("{0}/{1} ".format(form, pos), end='')
			else:
				print("{0}/{1}{2} ".format(form, pos, morpho), end='')
		print('')
