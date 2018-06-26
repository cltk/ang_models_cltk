"""Development file to test different NLTK taggers using cross-volidation."""

from nltk.corpus.reader import TaggedCorpusReader
from nltk.tag import UnigramTagger
from nltk.tag import BigramTagger
from nltk.tag import CRFTagger
from nltk.tag import TrigramTagger
from nltk.tag import PerceptronTagger

import os
import pickle
import time
import sys

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
    elif model_type == 'perceptron':
        tagger = PerceptronTagger(load=False)
        tagger.train(train_sents)

    return tagger


def make_pos_model(train_file, test_file, model_type):
    reader_train = TaggedCorpusReader('.', train_file)
    reader_test  = TaggedCorpusReader('.', test_file)
    train_sents = reader_train.tagged_sents()
    test_sents = reader_test.tagged_sents()

    tagger = train_tagger(model_type, train_sents)

    return tagger.evaluate(test_sents)

if __name__ == "__main__":
    model_type = sys.argv[1]

    tot_acc = 0.0
    for cv in range(0, 10):
        os.system('scripts/split_dataset.bash corpora/oe.pos')
        now = time.time()
        acc = make_pos_model('tmp/oe_train.pos', 'tmp/oe_test.pos', model_type)
        print("CV fold {0} accuracy = {1:.3} in {2:.3f} seconds".format(cv + 1, acc, time.time() - now))
        tot_acc += acc


    print("10-fold validation of model {0} = {1:.3f}".format(model_type, tot_acc/10))
    os.system('rm -rf ./tmp')

    test_acc = make_pos_model('corpora/oe_train.pos', 'corpora/oe_test.pos', model_type)
    print("Test accuracy on unseen text of model {0} = {1:.3f}".format(model_type, test_acc))
