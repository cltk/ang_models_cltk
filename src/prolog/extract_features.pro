:- use_module(library(sgml)).
:- use_module(library(xpath)).

write_word(Out, word(SentenceId, Form, POS, Morphology)) :-
	format(Out, '~w\t~w\t~w\t~w\t~n', [SentenceId, Form, POS, Morphology]).

extract_morphology(Source, Words) :-
	load_xml(Source, AllContent, [space(remove)]),
	findall(word(SentenceId, Form, POS, Morphology), 
		(xpath(AllContent, //sentence(@id=SentenceId)/token,TokenElement),
			TokenElement = element(token, TokenAttributes, _),
			member(form=Form, TokenAttributes),
			member('part-of-speech'=POS, TokenAttributes),
			member(morphology=Morphology, TokenAttributes)),
		Words).

process_oe_corpus(Out, CorpusName) :-
	format(atom(Source), 'corpora/iswoc-treebank/~w.xml', CorpusName),
	extract_morphology(Source, Words),
	maplist(write_word(Out), Words).

process_oe_corpora(OutFile) :-
	open(OutFile, write, Out),
	Corpora = ['æls', 'apt', 'chrona', 'or', 'wscp'],
	maplist(process_oe_corpus(Out), Corpora),
	close(Out).