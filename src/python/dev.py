"""Development file to test different NLTK taggers using cross-volidation."""

from train_morpho_tagger import make_morpho_model

from nltk import word_tokenize

import os
import time
import sys

if __name__ == "__main__":
    language = sys.argv[1]
    tag = sys.argv[2]
    model_type = sys.argv[3]
    num_folds = int(sys.argv[4])
    untagged = sys.argv[5]

    tot_acc = 0.0
    for cv in range(0, num_folds):
        os.system('scripts/split_dataset.bash corpora/{0}/{0}.{1}'.format(language, tag))
        now = time.time()
        _, acc, kappa, _  = make_morpho_model(language, model_type, tag, 'tmp/{0}_train.{1}'.format(language, tag), 'tmp/{0}_test.{1}'.format(language, tag))
        print("CV fold {0} accuracy = {1:.3} kappa = {2:.3f} in {3:.3f} seconds".format(cv + 1, acc, kappa, time.time() - now))
        tot_acc += acc

    if num_folds > 0:
        print("{2}-fold validation of model {0} = {1:.3f}".format(model_type, tot_acc / num_folds, num_folds))
        os.system('rm -rf ./tmp')

    # validate on unseen text
    tagger, test_acc, kappa, cm = make_morpho_model(language, model_type, tag, 'corpora/{0}/{0}_train.{1}'.format(language, tag), 'corpora/{0}/{0}_test.{1}'.format(language, tag))
    print("Test of model {0} for feature {1} on unseen text:\n\taccuracy = {2:.3f}\n\tkappa = {3:.3f}".format(model_type, tag, test_acc, kappa))
    print("\nConfusion matrix (rows = gold):")
    print(cm)

    # time tagging untagged text by the trained tagger
    with open(untagged) as untagged_text_file:
        untagged_text = untagged_text_file.read()
        tokens = word_tokenize(untagged_text)
        now = time.time()
        tagged_text = tagger.tag(tokens)
        duration = time.time() - now

        print("\nTime for model {0} to tag {3} = {1:.3f} secs at {2:.3f} words/sec".format(model_type, duration, len(tokens)/duration, untagged))
