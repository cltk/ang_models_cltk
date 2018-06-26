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


Training the Tagger
===================

Saving the Tagger
=================

Loading the Tagger
==================
