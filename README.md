# Old English Models

Trained morphological taggers for Old English (OE)

Training Set and Citations
==========================

Bech, Kristin and Kristine Eide. 2014. The ISWOC corpus. Department of Literature, Area Studies and European Languages, University of Oslo. http://iswoc.github.io.

Building the Training Set
==========================

To download the ISWOC corpus and construct a tagged corpus for training the morphological tagger, issue from the `english_models_cltk` directory:

```bash
$ ./scripts/make_oe_corpus.bash
```

This will yield files `oe.$FEATURE`, where $FEATURE is one of `{pos person number tense mood voice gender case degree strength inflection}`, in the `corpora` subdirectory. It will also produce files `oe_train.$FEATURE` and `oe_test.$FEATURE`.  The latter are built from Orosius' history, while the former contain the rest of the texts in the ISWOC corpus.  Validating on an unseen text provides a more realistic estimate of the tagger's accuracy on novel texts.

The POS and morphological tag scheme is given by the following XML snippet:

```XML
	<parts-of-speech>
      <value tag="A-" summary="adjective"/>
      <value tag="Df" summary="adverb"/>
      <value tag="S-" summary="article"/>
      <value tag="Ma" summary="cardinal numeral"/>
      <value tag="Nb" summary="common noun"/>
      <value tag="C-" summary="conjunction"/>
      <value tag="Pd" summary="demonstrative pronoun"/>
      <value tag="F-" summary="foreign word"/>
      <value tag="Px" summary="indefinite pronoun"/>
      <value tag="N-" summary="infinitive marker"/>
      <value tag="I-" summary="interjection"/>
      <value tag="Du" summary="interrogative adverb"/>
      <value tag="Pi" summary="interrogative pronoun"/>
      <value tag="Mo" summary="ordinal numeral"/>
      <value tag="Pp" summary="personal pronoun"/>
      <value tag="Pk" summary="personal reflexive pronoun"/>
      <value tag="Ps" summary="possessive pronoun"/>
      <value tag="Pt" summary="possessive reflexive pronoun"/>
      <value tag="R-" summary="preposition"/>
      <value tag="Ne" summary="proper noun"/>
      <value tag="Py" summary="quantifier"/>
      <value tag="Pc" summary="reciprocal pronoun"/>
      <value tag="Dq" summary="relative adverb"/>
      <value tag="Pr" summary="relative pronoun"/>
      <value tag="G-" summary="subjunction"/>
      <value tag="V-" summary="verb"/>
      <value tag="X-" summary="unassigned"/>
    </parts-of-speech>
    <morphology>
      <field tag="person">
        <value tag="1" summary="first person"/>
        <value tag="2" summary="second person"/>
        <value tag="3" summary="third person"/>
        <value tag="x" summary="uncertain person"/>
      </field>
      <field tag="number">
        <value tag="s" summary="singular"/>
        <value tag="d" summary="dual"/>
        <value tag="p" summary="plural"/>
        <value tag="x" summary="uncertain number"/>
      </field>
      <field tag="tense">
        <value tag="p" summary="present"/>
        <value tag="i" summary="imperfect"/>
        <value tag="r" summary="perfect"/>
        <value tag="s" summary="resultative"/>
        <value tag="a" summary="aorist"/>
        <value tag="u" summary="past"/>
        <value tag="l" summary="pluperfect"/>
        <value tag="f" summary="future"/>
        <value tag="t" summary="future perfect"/>
        <value tag="x" summary="uncertain tense"/>
      </field>
      <field tag="mood">
        <value tag="i" summary="indicative"/>
        <value tag="s" summary="subjunctive"/>
        <value tag="m" summary="imperative"/>
        <value tag="o" summary="optative"/>
        <value tag="n" summary="infinitive"/>
        <value tag="p" summary="participle"/>
        <value tag="d" summary="gerund"/>
        <value tag="g" summary="gerundive"/>
        <value tag="u" summary="supine"/>
        <value tag="x" summary="uncertain mood"/>
        <value tag="y" summary="finiteness unspecified"/>
        <value tag="e" summary="indicative or subjunctive"/>
        <value tag="f" summary="indicative or imperative"/>
        <value tag="h" summary="subjunctive or imperative"/>
        <value tag="t" summary="finite"/>
      </field>
      <field tag="voice">
        <value tag="a" summary="active"/>
        <value tag="m" summary="middle"/>
        <value tag="p" summary="passive"/>
        <value tag="e" summary="middle or passive"/>
        <value tag="x" summary="unspecified"/>
      </field>
      <field tag="gender">
        <value tag="m" summary="masculine"/>
        <value tag="f" summary="feminine"/>
        <value tag="n" summary="neuter"/>
        <value tag="p" summary="masculine or feminine"/>
        <value tag="o" summary="masculine or neuter"/>
        <value tag="r" summary="feminine or neuter"/>
        <value tag="q" summary="masculine, feminine or neuter"/>
        <value tag="x" summary="uncertain gender"/>
      </field>
      <field tag="case">
        <value tag="n" summary="nominative"/>
        <value tag="a" summary="accusative"/>
        <value tag="o" summary="oblique"/>
        <value tag="g" summary="genitive"/>
        <value tag="c" summary="genitive or dative"/>
        <value tag="e" summary="accusative or dative"/>
        <value tag="d" summary="dative"/>
        <value tag="b" summary="ablative"/>
        <value tag="i" summary="instrumental"/>
        <value tag="l" summary="locative"/>
        <value tag="v" summary="vocative"/>
        <value tag="x" summary="uncertain case"/>
        <value tag="z" summary="no case"/>
      </field>
      <field tag="degree">
        <value tag="p" summary="positive"/>
        <value tag="c" summary="comparative"/>
        <value tag="s" summary="superlative"/>
        <value tag="x" summary="uncertain degree"/>
        <value tag="z" summary="no degree"/>
      </field>
      <field tag="strength">
        <value tag="w" summary="weak"/>
        <value tag="s" summary="strong"/>
        <value tag="t" summary="weak or strong"/>
      </field>
      <field tag="inflection">
        <value tag="n" summary="non-inflecting"/>
        <value tag="i" summary="inflecting"/>
      </field>
    </morphology>
 ```


Running Unit Tests
==================

First, install the nltk and import the `punkt` model (`import nltk; nltk.download()`). To ensure that the system is sound, then run:

```bash
$ python test/python/test_train_morpho_tagger.py
```


Evaluating the Tagging Models
=============================

The following script will train four POS (only) tagging models: Unigram, Backoff (Trigram, Bigram, Unigram), Conditional Random Field (CRF), and Averaged Perceptron.

Note: you need to have an installation of `shuf` (Linux) or `gshuf` (Mac; `brew install coreutils`).

```bash
$ ./scripts/evaluate_all_models.bash
```

For each model,
1.  Ten-fold cross validation is run on the whole corpus, where in each fold about 10% of the corpus is randomly selected as a test set, while the rest is used for training the tagger.
2.  The tagger is trained on `corpora/oe_train.pos` and evaluated on `oe_test.pos`.
3.	The tagging speed of the trained tagger is measured as the time taken to tag the text of Beowulf.

For each model trained, the script outputs the average acccuracy for the cross-validation folds, and the test accuracy and Cohen's kappa on the test set.  A confusion matrix for the test set is also produced, for error analysis.

Sample output:
```
---------- unigram ----------
CV fold 1 accuracy = 0.806 kappa = 0.757 in 0.757 seconds
CV fold 2 accuracy = 0.82 kappa = 0.773 in 0.773 seconds
CV fold 3 accuracy = 0.828 kappa = 0.784 in 0.784 seconds
CV fold 4 accuracy = 0.803 kappa = 0.753 in 0.753 seconds
CV fold 5 accuracy = 0.813 kappa = 0.767 in 0.767 seconds
CV fold 6 accuracy = 0.81 kappa = 0.763 in 0.763 seconds
CV fold 7 accuracy = 0.817 kappa = 0.773 in 0.773 seconds
CV fold 8 accuracy = 0.833 kappa = 0.791 in 0.791 seconds
CV fold 9 accuracy = 0.814 kappa = 0.769 in 0.769 seconds
CV fold 10 accuracy = 0.829 kappa = 0.784 in 0.784 seconds
10-fold validation of model unigram = 0.817
Test of model unigram for feature pos on unseen text:
        accuracy = 0.687
        kappa = 0.627

Confusion matrix (rows = gold):
    A-   C-   DF  DU  G-   NB  NE   PD  PI   PP  PS  PX  PY   R-   V-
A-  34    0    2   0   0    1   0    0   0    0   0   0   0    0    0
C-   0  115    0   0   2    0   0    0   0    2   0   0   0    0    0
DF   0    0  119   0   2    0   0    7   0    0   0   0   0    2    0
DU   0    0    0   2   0    0   0    0   0    0   0   0   0    0    0
G-   0    0    8   0  56    0   0    8   0    0   0   0   0    5    0
NB   0    0    0   0   0  139   0    0   0    0   0   1   0    0    0
NE   0    0    0   0   0    0   9    0   0    0   0   0   0    0    0
PD   0    0   14   0  31    0   0  104   0    0   0   0   0    0    0
PI   0    0    0   0   2    0   0    0   1    0   0   0   0    0    0
PP   0    0    0   0   0    0   0    0   0  130   2   0   0    0    0
PS   0    0    0   0   0    0   0    0   0    0  28   0   0    0    1
PX   0    0    0   0   0    6   0    0   0    0   0   5   0    0    0
PY   0    1    0   0   0    1   0    0   0    0   0   0  88    0    0
R-   0    0    5   0   0    0   0    0   0    0   0   0   4  160    0
V-   0    0    0   0   0    0   0    0   0    0   0   0   0    9  178

Time for model unigram to tag Beowulf = 0.039

---------- backoff ----------
CV fold 1 accuracy = 0.834 kappa = 0.795 in 0.795 seconds
CV fold 2 accuracy = 0.833 kappa = 0.791 in 0.791 seconds
CV fold 3 accuracy = 0.825 kappa = 0.781 in 0.781 seconds
CV fold 4 accuracy = 0.832 kappa = 0.790 in 0.790 seconds
CV fold 5 accuracy = 0.815 kappa = 0.771 in 0.771 seconds
CV fold 6 accuracy = 0.826 kappa = 0.782 in 0.782 seconds
CV fold 7 accuracy = 0.833 kappa = 0.793 in 0.793 seconds
CV fold 8 accuracy = 0.837 kappa = 0.795 in 0.795 seconds
CV fold 9 accuracy = 0.824 kappa = 0.781 in 0.781 seconds
CV fold 10 accuracy = 0.832 kappa = 0.790 in 0.790 seconds
10-fold validation of model backoff = 0.829
Test of model backoff for feature pos on unseen text:
        accuracy = 0.701
        kappa = 0.644

Confusion matrix (rows = gold):
    A-   C-   DF  DU  G-   NB  NE   PD  PI   PP  PS  PX  PY   R-   V-
A-  34    0    2   0   0    1   0    0   0    0   0   0   0    0    0
C-   0  115    0   0   2    0   0    0   0    2   0   0   0    0    0
DF   0    0  118   0   6    0   0    4   0    0   0   0   0    2    0
DU   0    0    0   2   0    0   0    0   0    0   0   0   0    0    0
G-   0    0    1   0  60    0   0   13   0    0   0   0   0    3    0
NB   0    0    0   0   0  140   0    0   0    0   0   0   0    0    0
NE   0    0    0   0   0    0   9    0   0    0   0   0   0    0    0
PD   0    0    7   0  17    0   0  125   0    0   0   0   0    0    0
PI   0    0    0   0   2    0   0    0   1    0   0   0   0    0    0
PP   0    0    0   0   0    0   0    0   0  130   2   0   0    0    0
PS   0    0    0   0   0    0   0    0   0    1  27   0   0    0    1
PX   0    0    0   0   0    4   0    0   0    0   0   7   0    0    0
PY   0    1    0   0   0    1   0    0   0    0   0   0  88    0    0
R-   0    0    4   0   1    0   0    0   0    0   0   0   4  158    2
V-   0    0    0   0   0    0   0    0   0    0   0   0   0    7  180

Time for model backoff to tag Beowulf = 0.127

---------- crf ----------
CV fold 1 accuracy = 0.895 kappa = 0.869 in 0.869 seconds
CV fold 2 accuracy = 0.901 kappa = 0.878 in 0.878 seconds
CV fold 3 accuracy = 0.896 kappa = 0.871 in 0.871 seconds
CV fold 4 accuracy = 0.895 kappa = 0.870 in 0.870 seconds
CV fold 5 accuracy = 0.894 kappa = 0.870 in 0.870 seconds
CV fold 6 accuracy = 0.907 kappa = 0.885 in 0.885 seconds
CV fold 7 accuracy = 0.901 kappa = 0.875 in 0.875 seconds
CV fold 8 accuracy = 0.91 kappa = 0.889 in 0.889 seconds
CV fold 9 accuracy = 0.9 kappa = 0.874 in 0.874 seconds
CV fold 10 accuracy = 0.897 kappa = 0.873 in 0.873 seconds
10-fold validation of model crf = 0.900
Test of model crf for feature pos on unseen text:
        accuracy = 0.827
        kappa = 0.794

Confusion matrix (rows = gold):
    A-   C-   DF  DU  G-   NB  NE   PD  PI   PP  PS  PX  PY   R-   V-
A-  28    0    1   0   0   22   0    0   0    0   1   0   5    0   21
C-   0  115    0   0   2    1   0    0   0    2   0   0   0    0    1
DF   2    0  121   0   2    8   3    0   0    0   0   0   4    2   22
DU   0    0    0   2   0    0   0    0   0    0   0   0   0    0    0
G-   0    1    7   0  50    1   0    7   0    3   0   0   0    3    6
NB   7    0    2   0   0  231   0    1   0    2   3   0   1    1   16
NE   1    0    6   0   0    4  82    0   0    1   0   0   0    3    0
PD   1    0    9   0   4    1   2  132   0    0   0   0   0    0    2
PI   0    0    2   0   0    0   0    0   1    0   0   0   0    0    0
PP   1    0    0   0   0    3   0    0   0  126   2   0   0    0    0
PS   0    0    0   0   0    0   0    1   0    0  28   0   0    0    0
PX   0    0    0   0   0    6   0    0   0    0   0   3   0    0    2
PY   8    0    3   0   0   14  15    0   0    0   1   0  78    3    3
R-   0    0    4   0   0    3   0    0   0    0   0   0   4  156    7
V-   1    0    0   0   0   20   0    0   0    1   0   0   1    3  246

Time for model crf to tag Beowulf = 0.350

---------- perceptron ----------
CV fold 1 accuracy = 0.924 kappa = 0.904 in 0.904 seconds
CV fold 2 accuracy = 0.925 kappa = 0.905 in 0.905 seconds
CV fold 3 accuracy = 0.923 kappa = 0.904 in 0.904 seconds
CV fold 4 accuracy = 0.929 kappa = 0.911 in 0.911 seconds
CV fold 5 accuracy = 0.916 kappa = 0.896 in 0.896 seconds
CV fold 6 accuracy = 0.93 kappa = 0.912 in 0.912 seconds
CV fold 7 accuracy = 0.928 kappa = 0.910 in 0.910 seconds
CV fold 8 accuracy = 0.919 kappa = 0.900 in 0.900 seconds
CV fold 9 accuracy = 0.918 kappa = 0.897 in 0.897 seconds
CV fold 10 accuracy = 0.931 kappa = 0.914 in 0.914 seconds
10-fold validation of model perceptron = 0.924
Test of model perceptron for feature pos on unseen text:
        accuracy = 0.857
        kappa = 0.830

Confusion matrix (rows = gold):
    A-   C-   DF  DU  G-   NB  NE   PD  PI   PP  PS  PX  PY   R-   V-
A-  34    0    2   0   0   17   1    0   0    0   0   0   2    0   22
C-   0  117    1   0   2    1   0    0   0    0   0   0   0    0    0
DF   4    1  127   0   4    8   1    6   0    0   0   0   1    0   12
DU   0    0    0   2   0    0   0    0   0    0   0   0   0    0    0
G-   0    0    4   0  59    1   0    9   2    0   0   0   0    2    1
NB   2    0    2   0   1  244   0    1   0    0   0   1   2    0   11
NE   0    0    2   0   1    7  87    0   0    0   0   0   0    0    0
PD   1    0   10   0   6    1   0  133   0    0   0   0   0    0    0
PI   0    2    0   0   0    0   0    0   1    0   0   0   0    0    0
PP   1    0    0   0   0    3   0    0   0  126   2   0   0    0    0
PS   0    0    1   0   0    0   0    0   0    1  27   0   0    0    0
PX   0    0    0   0   0    4   0    0   0    0   0   7   0    0    0
PY   7    0    1   0   0   20  15    1   0    0   0   0  77    0    4
R-   1    0    3   0   0    4   2    0   0    0   0   0   4  160    0
V-   2    0    0   0   1   18   0    0   0    0   0   0   1    6  244

Time for model perceptron to tag Beowulf = 1.886
```

We see that the Perceptron tagger is the most accurate but also slowest. 

Training Taggers
=================

The python module at `src/python/oe_train.py` is used to train POS taggers.  

For help on using the script, use:

```bash
usage: oe_train.py [-h] [-u UNTAGGED_TEXT_FILE] [-v]
                   [-m {unigram,bigram,trigram,backoff,crf,perceptron,all}]
                   [-f {pos,person,number,tense,mood,gender,case,degree,strength,inflection}]

Train morphological tagger(s) for Old English.

optional arguments:
  -h, --help            show this help message and exit
  -u UNTAGGED_TEXT_FILE, --untagged_text_file UNTAGGED_TEXT_FILE
                        untagged text for testing
  -v, --verbose
  -m {unigram,bigram,trigram,backoff,crf,perceptron,all}, 
  --model_type {unigram,bigram,trigram,backoff,crf,perceptron,all}
                        model type to train
  -f {pos,person,number,tense,mood,gender,case,degree,strength,inflection}, 
  --feature {pos,person,number,tense,mood,gender,case,degree,strength,inflection}
                        Morphological feature to train
```

In the simplest case, all supported models are trained on the POS feature and stored in `taggers/pos`. Unless the `-v` flag is set, the script is silent.

```bash
python src/python/oe_train.py all

ls -l taggers/pos
total 6296
-rwxrwxrwx 1 jds jds  198414 Jun 29 01:11 backoff.pickle
-rwxrwxrwx 1 jds jds  466397 Jun 29 01:11 bigram.pickle
-rwxrwxrwx 1 jds jds  552396 Jun 29 01:11 crf.pickle
-rwxrwxrwx 1 jds jds 4294112 Jun 29 01:12 perceptron.pickle
-rwxrwxrwx 1 jds jds  764556 Jun 29 01:11 trigram.pickle
-rwxrwxrwx 1 jds jds  163393 Jun 29 01:11 unigram.pickle
```

With `-v` set, the output lists the location of the saved tagger and a sample of its output:

```bash
python src/python/oe_train.py crf -v
Model crf saved at taggers/pos/crf.pickle.  Training accuracy = 0.925
Sample tagging output: [('Hwæt', 'I-'), ('!', 'C-'), ('We', 'NE'), ('Gardena', 'NE'), ('in', 'R-'), ('geardagum', 'NB'), (',', 'C-'), ('þeodcyninga', 'NB'), (',', 'C-'), ('þrym', 'PY')]
```

To train a tagger for a different feature, use the `-f` command-line argument:

```bash
python src/python/oe_train.py -m perceptron -f case -v
Model perceptron for feature case saved at taggers/case/perceptron.pickle. Training accuracy = 0.983
Sample tagging output: [('Hwæt', 'A'), ('!', '-'), ('We', 'N'), ('Gardena', '-'), ('in', '-'), ('geardagum', 'D'), (',', '-'), ('þeodcyninga', 'G'), (',', 'G'), ('þrym', 'G')]
```

Loading the Tagger
==================

[point to CLTK documentation elsewhere?]