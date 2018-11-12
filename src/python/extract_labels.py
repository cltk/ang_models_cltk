import sys, re
import xml.etree.ElementTree as ET


if __name__ == '__main__':
	root = ET.parse(sys.stdin).getroot()

	labels = {}

	for parts_of_speech in root.iter('parts-of-speech'):
		labels['pos'] = {}

		for value in parts_of_speech.iter('value'):
			tag = value.attrib['tag']
			label = value.attrib['summary']
			labels['pos'][tag] = label

	for field in root.iter('field'):
		feature = field.attrib['tag']
		labels[feature] = {}

		for value in parts_of_speech.iter('value'):
			tag = value.attrib['tag']
			label = value.attrib['summary']
			labels[feature][tag] = label


print(labels)
