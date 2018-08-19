#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."
# create directory for binary models
mkdir -p taggers/pos
# create directory for storing corpora
mkdir -p corpora
cd corpora

# (re-)download the ISWOC corpus
rm -rf iswoc-treebank
git clone -q git@github.com:iswoc/iswoc-treebank.git
cd iswoc-treebank
rm -rf .git
cd ..

# parse and concatenate OE files
> oe.pos

for xmlfile in æls.xml apt.xml chrona.xml wscp.xml or.xml ; do
	cat iswoc-treebank/$xmlfile | python $SCRIPT_DIR/../src/python/xml2nltk.py $1 >> oe.pos
done

NUM_TOKENS=`wc oe.pos | awk '{print $2}'`
echo "Old English corpus has $NUM_TOKENS tokens."

# build static train and test sets
> oe_train.pos
for xmlfile in æls.xml apt.xml chrona.xml wscp.xml; do
	cat iswoc-treebank/$xmlfile | python $SCRIPT_DIR/../src/python/xml2nltk.py $1 >> oe_train.pos
done
> oe_test.pos
cat iswoc-treebank/or.xml | python $SCRIPT_DIR/../src/python/xml2nltk.py $1 >> oe_test.pos






