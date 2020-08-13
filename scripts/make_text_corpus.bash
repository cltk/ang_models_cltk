#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: make_text_corpus.bash [language name, e.g. oe or latin] [directory of unpacked Dictionary of Old English]"
    exit 1
fi

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$script_dir/.."

language=$1
doe_dir=$2

cat $doe_dir/0163/oecorp/seg* | $script_dir/fix_doe.awk > ./texts/oe/oe_all.txt
cat texts/oe/beowulf.txt >> ./texts/oe/oe_all.txt
awk '{gsub(/\/[^ ]+/,""); print }' corpora/oe/oe.all_features >> ./texts/oe/oe_all.txt

# build table of token counts per type
awk '{gsub(/[.,;?!]/, ""); gsub(/ /, "\n");print tolower($0)}' texts/oe/oe_all.txt |sort|uniq -c > data/ang_unigrams.txt

num_tokens=`wc texts/oe/oe_all.txt | awk '{print $2}'`
num_types=`wc -l data/oe.counts | awk '{print $1}'`
echo "Old English text contains $num_types types and $num_tokens tokens."
