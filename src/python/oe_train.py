"""Train cltk morphological models from a training set and save them in the model repository."""

from train_morpho_tagger import make_morpho_model

from nltk import word_tokenize
from nltk.tag import CRFTagger

import os
import sys
import pickle
import argparse

arg_parser = argparse.ArgumentParser(description='Train morphological tagger(s) for Old English.')
arg_parser.add_argument('-u', '--untagged_text_file', default='texts/oe/beowulf.txt', help='untagged text for testing')
arg_parser.add_argument('-v', '--verbose', default=False, action='store_true')
model_types = ['unigram', 'bigram', 'trigram', 'backoff', 'crf', 'perceptron', 'all']
arg_parser.add_argument('-m', '--model_type', choices=model_types, help='model type to train')
features = ['pos', 'person', 'number', 'tense', 'mood', 'gender', 'case', 'degree', 'strength', 'inflection']
arg_parser.add_argument('-f', '--feature', choices=features, help='Morphological feature to train', default='pos')


def train_and_save_tagger(model_type, feature, untagged_text, verbose = False):
    training_file = 'corpora/oe_train.' + feature
    tagger, acc, _, _ = make_morpho_model(model_type, feature, training_file)

    model_file = 'taggers/{1}/{0}.pickle'.format(model_type, feature)
    if model_type != 'crf': #annoying hack because the crf model saves itself.
        with open(model_file, 'wb') as f:
            pickle.dump(tagger, f)

    # check the model file by reloading it and using it to tag sample text
    if model_type != 'crf':
        with open(model_file, 'rb') as f:
            tagger2 = pickle.load(f)
    else:
        tagger2 = CRFTagger()
        tagger2.set_model_file(model_file)

    tagged_text = tagger2.tag(untagged_text)

    if verbose == True:
        print("Model {0} for feature {1} saved at {2}. Training accuracy = {3:.3f}".format(model_type, feature, model_file, acc))
        print("Sample tagging output: {0}".format(tagged_text[:10]))

if __name__ == "__main__":
    args = arg_parser.parse_args(sys.argv[1:])

    with open(args.untagged_text_file, 'r') as f:
        untagged_text = word_tokenize(f.read())

    if args.model_type == 'all':
        for model_type in model_types[:-1]:
            train_and_save_tagger(model_type, args.feature, untagged_text, args.verbose)
    else:
        train_and_save_tagger(args.model_type, args.feature, untagged_text, args.verbose)
