#!/bin/bash


for model in unigram backoff crf perceptron; do
	echo "---------- $model ----------"
	python src/python/oe_dev.py $model 10
	echo ""
done