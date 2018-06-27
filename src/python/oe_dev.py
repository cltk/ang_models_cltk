"""Development file to test different NLTK taggers using cross-volidation."""

from nltk import word_tokenize
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

    return (tagger, tagger.evaluate(test_sents))

if __name__ == "__main__":
    model_type = sys.argv[1]
    num_folds = int(sys.argv[2])

    os.system('mkdir -p taggers/pos')

    tot_acc = 0.0
    for cv in range(0, num_folds):
        os.system('scripts/split_dataset.bash corpora/oe.pos')
        now = time.time()
        _, acc = make_pos_model('tmp/oe_train.pos', 'tmp/oe_test.pos', model_type)
        print("CV fold {0} accuracy = {1:.3} in {2:.3f} seconds".format(cv + 1, acc, time.time() - now))
        tot_acc += acc

    if num_folds > 0:
        print("{2}-fold validation of model {0} = {1:.3f}".format(model_type, tot_acc / num_folds, num_folds))
        os.system('rm -rf ./tmp')

    # validate on unseen text
    tagger, test_acc = make_pos_model('corpora/oe_train.pos', 'corpora/oe_test.pos', model_type)
    print("Test accuracy of model {0} on unseen text  = {1:.3f}".format(model_type, test_acc))

    # time tagging of Beowulf by the trained tagger
    with open('corpora/oe/beowulf.txt') as untagged_text_file:
        untagged_text = untagged_text_file.read()
        tokens = word_tokenize(untagged_text)
        now = time.time()
        tagger.tag(tokens)
        print("Time for model {0} to tag Beowulf = {1:.3f}".format(model_type, time.time() - now))
