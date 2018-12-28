from cltk.corpus.utils.importer import CorpusImporter

latin_corpus_importer = CorpusImporter('latin')
oe_corpus_importer = CorpusImporter('old_english')

latin_corpus_importer.import_corpus('latin_text_latin_library')
latin_corpus_importer.import_corpus('latin_models_cltk')

oe_corpus_importer.import_corpus('old_english_models_cltk')

