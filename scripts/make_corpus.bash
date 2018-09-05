#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: make_corpus.bash [corpus name, e.g. oe or latin]"
    exit 1
fi


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$script_dir/.."

language=$1

# pull in the configuration for the corpus
source conf/$language

# create directories for binary models
for tag in pos person number tense mood voice gender case degree strength inflection; do
	mkdir -p taggers/$language/$tag
done

# create directory for storing corpora
mkdir -p corpora/$language
cd corpora/$language

# (re-)download the ISWOC corpus
rm -rf $corpus_name
git clone -q --depth 1 $corpus_url
cd $corpus_name
rm -rf .git
cd ..


# parse and concatenate OE files
for tag in pos person number tense mood voice gender case degree strength inflection; do
	> $language.$tag

	for xmlfile in "${corpus_all_files[@]}" ; do
		cat $corpus_name/$xmlfile | python $script_dir/../src/python/proiel_to_nltk.py --$tag >> $language.$tag
	done

	# build static training set ...
	> ${language}_train.$tag
	for xmlfile in "${corpus_training_files[@]}" ; do
		cat $corpus_name/$xmlfile | python $script_dir/../src/python/proiel_to_nltk.py --$tag >> ${language}_train.$tag
	done

	# and the test set.
	> ${language}_test.$tag
	for xmlfile in "${corpus_test_files[@]}" ; do
		cat $corpus_name/$xmlfile | python $script_dir/../src/python/proiel_to_nltk.py --$tag >> ${language}_test.$tag
	done
done

num_tokens=`wc oe.pos | awk '{print $2}'`
echo "${language_name} corpus has ${num_tokens} tokens."






