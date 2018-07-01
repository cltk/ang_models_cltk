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

# concatenate the OE files
cat æls.conll apt.conll chrona.conll or.conll wscp.conll > oe.conll
NUM_TOKENS=`wc -l	 oe.conll | cut -f1 -d' '`
echo "Old English corpus has $NUM_TOKENS tokens."
$SCRIPT_DIR/conll2nltk.awk oe.conll > ../oe.pos

# build static train and test sets
cat æls.conll apt.conll chrona.conll wscp.conll > oe_train.conll
cp  or.conll oe_test.conll
$SCRIPT_DIR/conll2nltk.awk oe_train.conll > ../oe_train.pos
$SCRIPT_DIR/conll2nltk.awk oe_test.conll  > ../oe_test.pos





