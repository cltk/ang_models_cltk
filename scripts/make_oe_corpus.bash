#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

# create directories for binary models
for tag in pos person number tense mood voice gender case degree strength inflection; do
	mkdir -p taggers/$tag
done

# create directory for storing corpora
mkdir -p corpora
cd corpora

# (re-)download the ISWOC corpus
rm -rf iswoc-treebank
git clone --depth 1 -q git@github.com:iswoc/iswoc-treebank.git
cd iswoc-treebank
rm -rf .git
cd ..

# parse and concatenate OE files
for tag in pos person number tense mood voice gender case degree strength inflection; do
	> oe.$tag

	for xmlfile in æls.xml apt.xml chrona.xml wscp.xml or.xml ; do
		cat iswoc-treebank/$xmlfile | python $SCRIPT_DIR/../src/python/proiel_to_nltk.py --$tag >> oe.$tag
	done

	# build static train and test sets
	> oe_train.$tag
	for xmlfile in æls.xml apt.xml chrona.xml wscp.xml; do
		cat iswoc-treebank/$xmlfile | python $SCRIPT_DIR/../src/python/proiel_to_nltk.py --$tag >> oe_train.$tag
	done
	> oe_test.$tag
	cat iswoc-treebank/or.xml | python $SCRIPT_DIR/../src/python/proiel_to_nltk.py --$tag >> oe_test.$tag
done

NUM_TOKENS=`wc oe.pos | awk '{print $2}'`
echo "Old English corpus has $NUM_TOKENS tokens."






