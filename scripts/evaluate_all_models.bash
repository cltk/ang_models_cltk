#!/bin/bash

language=$1
tag=${2:-"pos"}
model=${2:-"perceptron"}
cv_folds=${3:-"10"}

source conf/$language

for model in unigram backoff crf perceptron; do
	echo "---------- $model ----------"
	python src/python/dev.py $language $tag $model $cv_folds texts/$language/$untagged_text
	echo ""
done