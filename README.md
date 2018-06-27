# English Models

Trained POS tagger for Old English (OG) and Middle English (ME).

Training Set and Citations
==========================

Building the Training Set
==========================

Old English
-----------

To download the ISWOC corpus and construct a tagged corpus for training the POS tagger, issue from the `english_models_cltk` directory:

```bash
./scripts/make_oe_corpus.bash
```

This will yield a file `oe.pos` in the `corpora` subdirectory.  
It will also produce files `oe_train.pos` and `oe_test.pos`.  The latter is just Orosius' history, while the former contains the rest of the texts in the ISWOC corpus.  Validating on an unseen text provides a more realistic estimate of the tagger's accuracy on novel texts.


Evaluating the Tagging Models
=============================

The following script will train four POS tagging models: Unigram, Backoff (Trigram, Bigram, Unigram), Conditional Random Field (CRF), and Averaged Perceptron.

```bash
./scripts/evaluate_all_models.bash
```

For each model,
1.  Ten-fold cross validation is run on the whole corpus, where in each fold about 10% of the corpus is randomly selected as a test set, while the rest is used for training the tagger.
2.  The tagger is trained on `corpora/oe_train.pos` and evaluated on `oe_test.pos`.
3.	The tagging speed of the trained tagger is measured as the time taken to tag the text of Beowulf.

Sample output:

```---------- unigram ----------
CV fold 1 accuracy = 0.824 in 0.175 seconds
CV fold 2 accuracy = 0.826 in 0.164 seconds
CV fold 3 accuracy = 0.824 in 0.189 seconds
CV fold 4 accuracy = 0.815 in 0.157 seconds
CV fold 5 accuracy = 0.821 in 0.182 seconds
CV fold 6 accuracy = 0.828 in 0.161 seconds
CV fold 7 accuracy = 0.817 in 0.184 seconds
CV fold 8 accuracy = 0.816 in 0.194 seconds
CV fold 9 accuracy = 0.811 in 0.184 seconds
CV fold 10 accuracy = 0.813 in 0.187 seconds
10-fold validation of model unigram = 0.820
Test accuracy of model unigram on unseen text  = 0.685
Time for modhel unigram to tag Beowulf = 0.020

---------- backoff ----------
CV fold 1 accuracy = 0.828 in 0.530 seconds
CV fold 2 accuracy = 0.847 in 0.512 seconds
CV fold 3 accuracy = 0.825 in 0.527 seconds
CV fold 4 accuracy = 0.833 in 0.520 seconds
CV fold 5 accuracy = 0.831 in 0.514 seconds
CV fold 6 accuracy = 0.832 in 0.509 seconds
CV fold 7 accuracy = 0.829 in 0.510 seconds
CV fold 8 accuracy = 0.833 in 0.525 seconds
CV fold 9 accuracy = 0.827 in 0.574 seconds
CV fold 10 accuracy = 0.828 in 0.539 seconds
10-fold validation of model backoff = 0.831
Test accuracy of model backoff on unseen text  = 0.700
Time for modhel backoff to tag Beowulf = 0.056

---------- crf ----------
CV fold 1 accuracy = 0.899 in 2.886 seconds
CV fold 2 accuracy = 0.902 in 3.062 seconds
CV fold 3 accuracy = 0.905 in 3.033 seconds
CV fold 4 accuracy = 0.896 in 2.955 seconds
CV fold 5 accuracy = 0.891 in 2.919 seconds
CV fold 6 accuracy = 0.898 in 2.894 seconds
CV fold 7 accuracy = 0.9 in 3.131 seconds
CV fold 8 accuracy = 0.9 in 3.072 seconds
CV fold 9 accuracy = 0.901 in 3.041 seconds
CV fold 10 accuracy = 0.912 in 2.922 seconds
10-fold validation of model crf = 0.900
Test accuracy of model crf on unseen text  = 0.827
Time for modhel crf to tag Beowulf = 0.173

---------- perceptron ----------
CV fold 1 accuracy = 0.924 in 5.726 seconds
CV fold 2 accuracy = 0.921 in 5.829 seconds
CV fold 3 accuracy = 0.932 in 5.830 seconds
CV fold 4 accuracy = 0.921 in 5.854 seconds
CV fold 5 accuracy = 0.915 in 5.813 seconds
CV fold 6 accuracy = 0.922 in 5.810 seconds
CV fold 7 accuracy = 0.922 in 6.039 seconds
CV fold 8 accuracy = 0.925 in 6.144 seconds
CV fold 9 accuracy = 0.92 in 6.065 seconds
CV fold 10 accuracy = 0.922 in 6.352 seconds
10-fold validation of model perceptron = 0.922
Test accuracy of model perceptron on unseen text  = 0.840
Time for modhel perceptron to tag Beowulf = 0.990
```

We see that the Perceptron tagger is the most accurate but also slowest.  The CRF tagger seems to offer the best balance of speed and accuracy.

Saving the Tagger
=================

Loading the Tagger
==================
