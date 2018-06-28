"""Functions t o train NLTK POS taggers"""

from nltk.corpus.reader import TaggedCorpusReader
from nltk.tag import UnigramTagger
from nltk.tag import BigramTagger
from nltk.tag import CRFTagger
from nltk.tag import TrigramTagger
from nltk.tag import PerceptronTagger


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