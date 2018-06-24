# English Models

Trained POS tagger for Old English (OG) and Middle English (ME).

Training Set and Citations
==========================

Building the Training Set
==========================

Old English
-----------

To download the ISWOC corpus and construct a tagged corpus for training the POS tagger, issue:

```bash
./scripts/make_oe_corpus.bash
```
from the `english_models_cltk` directory.

This will yield a file `oe.conll` in the `corpora` directory.  
To build the training file for the tagger, issue:

```bash
./scripts/conll2nltk.awk corpora/oe.conll > corpora/oe.pos
```

Training the Tagger
===================

Saving the Tagger
=================

Loading the Tagger
==================
