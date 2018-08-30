#!/bin/bash

OS=`uname -s`
if [ "$OS" = "Darwin" ]
then
	# Note: mac has `gshuf`, obtained with `brew install coreutils`
	SHUF="/usr/local/bin/gshuf"
else
	SHUF=`which shuf`
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

mkdir -p tmp
EXT=${1##*.}
DATA_FILE=`basename "$1" .$EXT`
SHUFFLED_FILE=tmp/${DATA_FILE}_shuf.$EXT
TRAIN_FILE=tmp/${DATA_FILE}_train.$EXT
TEST_FILE=tmp/${DATA_FILE}_test.$EXT

NUM_SENTS=`wc -l $1 | awk '{print $1}'`
let NUM_TEST_SENTS=NUM_SENTS/10
let TRAIN_START_LINE=NUM_TEST_SENTS+1

$SHUF $1 > $SHUFFLED_FILE
head -$NUM_TEST_SENTS $SHUFFLED_FILE > $TEST_FILE
tail -n +$TRAIN_START_LINE $SHUFFLED_FILE > $TRAIN_FILE
