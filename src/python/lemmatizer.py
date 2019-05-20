from difflib import SequenceMatcher
import re
import math
import time
import Levenshtein
import numpy as np
import multiprocessing as mp


class LemmatizationRule:
    def __init__(self, form_template, lemma_template):
        self.lemma_template = lemma_template
        self.concreteness = len(form_template[1 : len(form_template) - 1].replace('([^ ]+)', ''))
        self.form_template = re.compile(form_template)

    def apply(self, form):
        form = form.lower()
        return re.sub(self.form_template, self.lemma_template, form)

    def match(self, form):
        return len(form) - self.concreteness if self.form_template.match(form.lower()) else 0

    def __call__(self, form):
        return self.apply(form)

    def __str__(self):
        return "lemma-rule {0} -> {1}".format(self.form_template, self.lemma_template)

    __repr__ = __str__

    def __eq__(self, other):
        return self.form_template == other.form_template and self.lemma_template == other.lemma_template

    def __hash__(self):
        return hash(repr(self))

    @staticmethod
    def create(w1, w2):
        w1 = w1.lower()
        w2 = w2.lower()
        matcher = SequenceMatcher(None, w1, w2)

        blocks = matcher.get_matching_blocks()

        dx, dy = 0, 0
        for i, match in enumerate(blocks[:-1]):
            w1 = w1[:match.a - dx] + '([^ ]+)' + w1[match.a + match.size - dx:]
            w2 = w2[:match.b - dy] + '\\' + str(i + 1) + w2[match.b + match.size - dy:]
            dx += match.size - 7
            dy += match.size - 2

        return LemmatizationRule('^' + w1 + '$', w2)


class Lemmatizer:
    def __init__(self):
        self._train('data/oe.lemmas_inv')
        self._load_counts('data/oe.counts')

    def _train(self, training_file):
        self.rules = []
        self.dictionary = {}

        with open(training_file) as f:
            for line in f.read().splitlines():
                w = line.split()
                if len(w) == 2:
                    form, lemma = line.split()
                    self.rules.append(LemmatizationRule.create(form, lemma))
                    lemmas = self.dictionary.get(form, [])
                    lemmas.append(lemma)
                    self.dictionary[form] = lemmas
        self.rules = list(set(self.rules))

    def _load_counts(self, path):
        self.type_counts = {}
        with open(path) as infile:
            lines = infile.read().splitlines()
            for line in lines:
                count, word = line.split()
                self.type_counts[word] = int(count)

    def relative_frequency(self, word):
        """Computes the log relative frequency for a word form"""

        count = self.type_counts.get(word, 0)
        return math.log(count/len(self.type_counts)) if count > 0 else 0


    def lemmatize(self, form, tolerance = 1):
        form = form.lower()

        rule_scores = [(rule, rule.match(form)) for rule in self.rules]
        best_scores = [x[1] for x in rule_scores if x[1] > 0]
        best_score = min(best_scores)

        candidates =  filter(lambda x: x[1] > 0 and x[1] <= best_score + tolerance, rule_scores)

        lemmas = list(set([x[0](form) for x in candidates]))
        attested_freqs = [(lemma, self.relative_frequency(lemma)) for lemma in lemmas]
        non_zero_freqs = [(lemma, freq) for (lemma, freq) in attested_freqs if freq != 0]
        if len(non_zero_freqs) > 0:
            sorted_freqs = sorted(non_zero_freqs, key = lambda x: x[1], reverse=True)
            return [sorted_freqs[0][0]]
        else:
            ratios = [Levenshtein.ratio(form, lemma) for lemma in lemmas]
            return [lemmas[i] for i, ratio in enumerate(ratios) if ratio == max(ratios)]

    def _evaluate_form(self, form):
        if [form] == self.dictionary[form]:
            return -1

        lemmas = self.lemmatize(form.lower(), tolerance = 2)
        target_lemmas = self.dictionary[form]
        for lemma in lemmas:
            if lemma in target_lemmas:
                return 1
        return 0


    def evaluate(self):
        score = 0
        total = 0

        start_time = time.time()

        pool = mp.Pool()
        scores = pool.map(self._evaluate_form, list(self.dictionary.keys()))

        print('eval time: ', time.time() - start_time)

        return scores

    def _evaluate_match_form(self, form):
        rule_scores = [(rule, rule.match(form)) for rule in self.rules]
        return 1


    def evaluate_matching(self):
        start_time = time.time()

        #pool = mp.Pool()
        #scores = pool.map(self._evaluate_match_form, list(self.dictionary.keys()))
        scores = [self._evaluate_match_form(form) for form in self.dictionary.keys()]
        print('eval time: ', time.time() - start_time)

        return scores

            

    


