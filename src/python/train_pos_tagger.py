"""Functions to train NLTK POS taggers"""

from nltk.corpus.reader import TaggedCorpusReader
from nltk.tag import UnigramTagger
from nltk.tag import BigramTagger
from nltk.tag import CRFTagger
from nltk.tag import TrigramTagger
from nltk.tag import PerceptronTagger

import numpy as np
import pandas as pd
from sklearn.metrics import confusion_matrix


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

def compute_baseline(tagged_words):
    tags = [tag for word, tag in tagged_words]
    unique_tags, counts = np.unique(tags, return_counts=True)
    return np.max(counts) / len(tagged_words)

def conf_matrix(tagger, words, tagged_words):
    predicted_tags = [tag if tag != None else 'None' for _, tag in tagger.tag(words)]
    gold_tags = [tag for _, tag in tagged_words]
    labels = np.unique(gold_tags)
    cm = confusion_matrix(gold_tags, predicted_tags, labels=labels)
    return pd.DataFrame(cm, index = labels, columns = labels)
    

def make_pos_model(model_type, train_file, test_file = None):
    test_file = train_file if test_file == None else test_file

    reader_train = TaggedCorpusReader('.', train_file)
    reader_test  = TaggedCorpusReader('.', test_file)
    train_sents = reader_train.tagged_sents()
    test_sents = reader_test.tagged_sents()

    tagger = train_tagger(model_type, train_sents)

    acc = tagger.evaluate(test_sents)
    baseline = compute_baseline(reader_test.tagged_words())
    kappa = (acc - baseline) / (1 - baseline)

    cm = conf_matrix(tagger, reader_test.words(), reader_test.tagged_words())

    return (tagger, acc, kappa, cm)
