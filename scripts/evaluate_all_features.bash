#!/bin/bash

language=$1
model=${2:-"perceptron"}
cv_folds=${3:-"10"}

source conf/$language

# NB: skipping voice because there's zero variance
for feature in pos person number tense mood gender case degree strength inflection; do
	echo "---------- $feature ----------"
	python src/python/dev.py $language $feature $model $cv_folds texts/$language/$untagged_text
	echo ""
done