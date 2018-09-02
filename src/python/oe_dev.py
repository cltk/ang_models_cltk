"""Development file to test different NLTK taggers using cross-volidation."""

from train_morpho_tagger import make_morpho_model

from nltk import word_tokenize

import os
import time
import sys

if __name__ == "__main__":
    tag = sys.argv[1]
    model_type = sys.argv[2]
    num_folds = int(sys.argv[3])

    tot_acc = 0.0
    for cv in range(0, num_folds):
        os.system('scripts/split_dataset.bash corpora/oe.' + tag)
        now = time.time()
        _, acc, kappa, _  = make_morpho_model(model_type, tag, 'tmp/oe_train.' + tag, 'tmp/oe_test.' + tag)
        print("CV fold {0} accuracy = {1:.3} kappa = {2:.3f} in {2:.3f} seconds".format(cv + 1, acc, kappa, time.time() - now))
        tot_acc += acc

    if num_folds > 0:
        print("{2}-fold validation of model {0} = {1:.3f}".format(model_type, tot_acc / num_folds, num_folds))
        os.system('rm -rf ./tmp')

    # validate on unseen text
    tagger, test_acc, kappa, cm = make_morpho_model(model_type, tag, 'corpora/oe_train.' + tag, 'corpora/oe_test.' + tag)
    print("Test of model {0} for feature {1} on unseen text:\n\taccuracy = {2:.3f}\n\tkappa = {3:.3f}".format(model_type, tag, test_acc, kappa))
    print("\nConfusion matrix (rows = gold):")
    print(cm)

    # time tagging of Beowulf by the trained tagger
    with open('texts/oe/beowulf.txt') as untagged_text_file:
        untagged_text = untagged_text_file.read()
        tokens = word_tokenize(untagged_text)
        now = time.time()
        tagged_text = tagger.tag(tokens)
        print("\nTime for model {0} to tag Beowulf = {1:.3f}".format(model_type, time.time() - now))
