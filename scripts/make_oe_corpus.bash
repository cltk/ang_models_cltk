#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."
mkdir -p corpora
cd corpora

# (re-)download the ISWOC corpus
rm -rf iswoc-treebank
git clone -q git@github.com:iswoc/iswoc-treebank.git
cd iswoc-treebank
rm -rf .git

# concatenate the OE files
cat æls.conll apt.conll chrona.conll or.conll wscp.conll > ../oe.conll
NUM_TOKENS=`wc -l ../oe.conll | cut -f1 -d' '`
echo "Old English corpus has $NUM_TOKENS tokens."

