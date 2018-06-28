import unittest
import sys
sys.path.append('src/python/')

from train_pos_tagger import train_tagger, make_pos_model

from nltk.corpus.reader import TaggedCorpusReader
from nltk import word_tokenize

class TestTrainPOSTagger(unittest.TestCase):

	def setUp(self):
		reader = TaggedCorpusReader('./corpora', 'oe_train.pos')
		self.sents =  reader.tagged_sents()

	def test_train_tagger(self):
		tagger = train_tagger("unigram", self.sents)
		tagged_text = tagger.tag(word_tokenize('Hwæt! We Gardena in geardagum,'))
		self.assertEqual(tagged_text, [('Hwæt', 'I-'), ('!', None), ('We', 'PP'), \
			('Gardena', None), ('in', 'DF'), ('geardagum', None), (',', None)])

	def test_make_pos_model(self):
		tagger, _ = make_pos_model('crf', 'corpora/oe_train.pos')
		tagged_text = tagger.tag(word_tokenize('Hwæt! We Gardena in geardagum,'))
		self.assertEqual(tagged_text, [('Hwæt', 'I-'), ('!', 'C-'), ('We', 'NE'), \
			('Gardena', 'NE'), ('in', 'R-'), ('geardagum', 'NB'), (',', 'C-')])


if __name__ == '__main__':
    unittest.main()