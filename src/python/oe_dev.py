"""Development file to test different NLTK taggers using cross-volidation."""

from train_pos_tagger import make_pos_model

from nltk import word_tokenize

import os
import pickle
import time
import sys

if __name__ == "__main__":
    model_type = sys.argv[1]
    num_folds = int(sys.argv[2])

    tot_acc = 0.0
    for cv in range(0, num_folds):
        os.system('scripts/split_dataset.bash corpora/oe.pos')
        now = time.time()
        _, acc = make_pos_model(model_type, 'tmp/oe_train.pos', 'tmp/oe_test.pos')
        print("CV fold {0} accuracy = {1:.3} in {2:.3f} seconds".format(cv + 1, acc, time.time() - now))
        tot_acc += acc

    if num_folds > 0:
        print("{2}-fold validation of model {0} = {1:.3f}".format(model_type, tot_acc / num_folds, num_folds))
        os.system('rm -rf ./tmp')

    # validate on unseen text
    tagger, test_acc = make_pos_model(model_type, 'corpora/oe_train.pos', 'corpora/oe_test.pos')
    print("Test accuracy of model {0} on unseen text  = {1:.3f}".format(model_type, test_acc))

    # time tagging of Beowulf by the trained tagger
    with open('texts/oe/beowulf.txt') as untagged_text_file:
        untagged_text = untagged_text_file.read()
        tokens = word_tokenize(untagged_text)
        now = time.time()
        tagged_text = tagger.tag(tokens)
        print("Time for model {0} to tag Beowulf = {1:.3f}".format(model_type, time.time() - now))
