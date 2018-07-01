#!/bin/bash

OS=`uname -s`
if [ "$OS" = "Darwin" ]
then
	SHUF="/usr/local/bin/gshuf"
else
	SHUF=`which shuf`
fi

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/.."

mkdir -p tmp
DATA_FILE=`basename "$1" .pos`
SHUFFLED_FILE=tmp/${DATA_FILE}_shuf.pos
TRAIN_FILE=tmp/${DATA_FILE}_train.pos
TEST_FILE=tmp/${DATA_FILE}_test.pos

NUM_SENTS=`wc -l $1 | awk '{print $1}'`
let NUM_TEST_SENTS=NUM_SENTS/10
let TRAIN_START_LINE=NUM_TEST_SENTS+1

$SHUF $1 > $SHUFFLED_FILE
head -$NUM_TEST_SENTS $SHUFFLED_FILE > $TEST_FILE
tail -n +$TRAIN_START_LINE $SHUFFLED_FILE > $TRAIN_FILE
