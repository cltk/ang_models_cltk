#!/bin/bash

tag=${1:-"pos"}

for model in unigram backoff crf perceptron; do
	echo "---------- $model ----------"
	python src/python/oe_dev.py $tag $model 10
	echo ""
done