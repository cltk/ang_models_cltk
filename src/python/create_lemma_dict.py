"""
Creates Old English inverted index for lemmatization task.
"""

import os
import pprint
import codecs


if __name__ == "__main__":

    lemma_dict = {}

    with codecs.open("data/oe.lemmas", "r", encoding="utf-8") as infile:
        lines = infile.read().splitlines()
        for line in lines:
            forms = line.split("\t")

            lemma = forms[0]
            for form_seq in forms:
                indiv_forms = form_seq.split(",")
                for form in indiv_forms:
                    form = form.lower()
                    lemma_list = lemma_dict.get(form, [])
                    lemma_list.append(lemma)
                    lemma_dict[form] = lemma_list

    for form in lemma_dict.keys():
        lemma_dict[form] = list(set(lemma_dict[form]))

    pp = pprint.PrettyPrinter()
    print("inverted_index = ", end="")
    pp.pprint(lemma_dict)
