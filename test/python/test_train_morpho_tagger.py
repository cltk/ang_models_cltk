import unittest
import sys
sys.path.append('src/python/')

from train_morpho_tagger import train_tagger, make_morpho_model

from nltk.corpus.reader import TaggedCorpusReader
from nltk import word_tokenize

class TestTrainTagger(unittest.TestCase):

	def setUp(self):
		reader = TaggedCorpusReader('./corpora', 'oe_train.pos')
		self.sents =  reader.tagged_sents()

	def test_train_tagger(self):
		tagger = train_tagger('unigram', 'pos', self.sents)
		tagged_text = tagger.tag(word_tokenize('Hwæt! We Gardena in geardagum,'))
		self.assertEqual(tagged_text, [('Hwæt', 'I-'), ('!', None), ('We', 'PP'), \
			('Gardena', None), ('in', 'DF'), ('geardagum', None), (',', None)])

	def test_make_morpho_model(self):
		tagger, _, _, _ = make_morpho_model('crf', 'pos', 'corpora/oe_train.pos')
		tagged_text = tagger.tag(word_tokenize('Hwæt! We Gardena in geardagum,'))
		self.assertEqual(tagged_text, [('Hwæt', 'I-'), ('!', 'C-'), ('We', 'NE'), \
			('Gardena', 'NE'), ('in', 'R-'), ('geardagum', 'NB'), (',', 'C-')])


if __name__ == '__main__':
    unittest.main()