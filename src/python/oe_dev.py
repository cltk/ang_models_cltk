"""Train cltk POS models from a training set and save them in the model repository."""

from nltk.corpus.reader import TaggedCorpusReader
from nltk.tag import UnigramTagger
from nltk.tag import BigramTagger
from nltk.tag import CRFTagger
from nltk.tag import TrigramTagger

import os
import pickle
import time
import sys
from random import shuffle

def train_tagger(model_type, train_sents):
    if model_type == 'unigram':
        tagger = UnigramTagger(train_sents)
    elif model_type == 'bigram':
        tagger = BigramTagger(train_sents)
    elif model_type == 'trigram':
        tagger = TrigramTagger(train_sents)
    elif model_type == 'backoff':
        tagger1 = UnigramTagger(train_sents)
        tagger2 = BigramTagger(train_sents, backoff=tagger1)
        tagger = TrigramTagger(train_sents, backoff=tagger2)
    elif model_type == 'crf':
        tagger = CRFTagger()
        tagger.train(train_sents, 'taggers/pos/crf.pickle')

    return tagger


def make_pos_model(train_file, test_file, model_type):
    reader_train = TaggedCorpusReader('.', train_file)
    reader_test  = TaggedCorpusReader('.', test_file)
    train_sents = reader_train.tagged_sents()
    test_sents = reader_test.tagged_sents()

    tagger = train_tagger(model_type, train_sents)

    print('Test Accuracy:', tagger.evaluate(test_sents))

if __name__ == "__main__":
    make_pos_model(sys.argv[1], sys.argv[2], sys.argv[3])
