import sys, re
import xml.etree.ElementTree as ET



if __name__ == '__main__':
	root = ET.parse(sys.stdin).getroot()

	for sentence in root.iter('s'):
		for latin in sentence.iterfind('foreign'):
			sentence.remove(latin)

		content = "".join(sentence.itertext())

		if content != '' and content != ' ':
			print(content) 