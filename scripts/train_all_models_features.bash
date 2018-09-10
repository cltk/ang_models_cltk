#!/bin/bash

for feature in pos person number tense mood gender case degree strength inflection; do
	for model in unigram backoff crf perceptron; do
		echo "---------- $feature $model ----------"
		python src/python/train.py -m $model -f $feature -v
	done
done