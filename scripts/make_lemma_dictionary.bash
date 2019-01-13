#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: make_lemma_dictionary.bash [corpus name, e.g. oe or latin] [wiktionary dump file]"
    exit 1
fi


script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$script_dir/.."

language=$1
wiktionary_dump=$2

lemma_file=$script_dir/../data/$language.lemmas
bzcat $wiktionary_dump | $script_dir/extract_forms_from_wiktionary.awk | gawk -vno_pos=1 -f $script_dir/apply_wiktionary_templates.awk > $lemma_file

# pull in the configuration for the corpus
source conf/$language

# create directory for storing corpora
mkdir -p corpora/$language
cd corpora/$language

# (re-)download the ISWOC corpus
rm -rf $corpus_name
git clone -q --depth 1 $corpus_url
cd $corpus_name
rm -rf .git
cd ..

# now extract the lemmas

> $language.lemmas
for xmlfile in "${corpus_all_files[@]}" ; do
	python $script_dir/../src/python/proiel_lemmas.py -f $lemma_file $corpus_name/$xmlfile > $lemma_file.tmp
	mv $lemma_file.tmp $lemma_file
done


num_lemmas=`wc -l $lemma_file`
echo "${language_name} corpus has ${num_lemmas} lemmas."






