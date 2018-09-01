#!/bin/bash

model=${1:-"perceptron"}
cv_folds=${2:-"10"}

# NB: skipping voice because there's zero variance
for feature in pos person number tense mood gender case degree strength inflection; do
	echo "---------- $feature ----------"
	python src/python/oe_dev.py $feature $model $cv_folds
	echo ""
done