"""Train cltk POS models from a training set and save them in the model repository."""

from train_pos_tagger import make_pos_model

from nltk import word_tokenize
from nltk.tag import CRFTagger

import os
import sys
import pickle
import argparse

arg_parser = argparse.ArgumentParser(description='Train POS tagger(s) for Old English.')
arg_parser.add_argument('-f', '--training_file', default='corpora/oe.pos', help='training file')
arg_parser.add_argument('-u', '--untagged_text_file', default='texts/oe/beowulf.txt', help='untagged text for testing')
arg_parser.add_argument('-v', '--verbose', default=False, action='store_true')
model_types = ['unigram', 'bigram', 'trigram', 'backoff', 'crf', 'perceptron', 'all']
arg_parser.add_argument('model_type', choices=model_types, help='POS model type to train')

def train_and_save_tagger(model_type, training_file, untagged_text, verbose = False):
    tagger, acc = make_pos_model(model_type, training_file)

    model_file = 'taggers/pos/{0}.pickle'.format(model_type)
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
        print("Model {0} saved at {1}.  Training accuracy = {2:.3f}".format(model_type, model_file, acc))
        print("Sample tagging output: {0}".format(tagged_text[:10]))

if __name__ == "__main__":
    args = arg_parser.parse_args(sys.argv[1:])

    with open(args.untagged_text_file, 'r') as f:
        untagged_text = word_tokenize(f.read())
    
    if args.model_type == 'all':
        for model_type in model_types[:-1]:
            train_and_save_tagger(model_type, args.training_file, untagged_text, args.verbose)
    else:
        train_and_save_tagger(args.model_type, args.training_file, untagged_text, args.verbose)
