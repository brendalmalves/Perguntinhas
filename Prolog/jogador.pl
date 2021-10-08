:- module('jogador', [iniciaJogo/0]).
:- use_module(ranking).
:- use_module(perguntinha).
:- use_module(menu).
:- encoding(utf8).

iniciaJogo :- 
	writeln("Digite seu nome com até 15 caracteres: "),
	read_line_to_string(user_input, Nome), 
	string_length(Nome, X),
	X =< 15 -> inicia_jogo(Nome, 0, 0, []), nl;
	write("Seu nome é maior que 15 caracteres, tente novamente."), nl, iniciaJogo, nl.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	UltimaPontuacao < 0,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	getTotalQuestoes(TotalQuestoes),
	TotalQuestoes =:= 0,
	writeln("Ainda não há questões cadastradas no sistema."),
	main,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	length(QuestoesSorteadas, Len),
	getTotalQuestoes(TotalQuestoes),
	Len =:= TotalQuestoes,
	writeln("Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."), nl,
	cadastra_no_ranking(Nome, UltimaPontuacao),
	main,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	getTotalQuestoes(TotalQuestoes),
	random_between(0, TotalQuestoes, Rand),
	getQuestao(Rand, Q),
	exibeQuestao(Q),
	get_time(Exibiu),
	append(QuestoesSorteadas, [Rand], QuestoesSorteadas1),
	read(Alternativa),
	string_lower(Alternativa, Alternativa1),
	(Alternativa1 =:= "e" 
		-> 
		exibeDica(Q),
		read(Alternativa2),
		get_time(Respondeu),
		string_lower(Alternativa2, Alternativa3),
		timediff(Exibiu, Respondeu, DiffTempo),
		respondeQuestao(Q, Alternativa3, UltimaPontuacao, DiffTempo, True, PontuacaoAtual)
		;
		get_time(Respondeu),
		timediff(Exibiu, Respondeu, DiffTempo),
		respondeQuestao(Q, Alternativa1, UltimaPontuacao, DiffTempo, False, PontuacaoAtual),
			(PontuacaoAtual >= Apex 
				-> 
				inicia_jogo(Nome, PontuacaoAtual, PontuacaoAtual, QuestoesSorteadas1)
				;
				inicia_jogo(Nome, PontuacaoAtual, Apex, QuestoesSorteadas1))
).


timediff(Stamp1, Stamp2, Secs) :-
	Secs is Stamp2 - Stamp1.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, TeveDica, PontuacaoAtual) :-
	DiffTempo >= 15,
	PontuacaoAtual is Pontuacao - 20.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, True, PontuacaoAtual) :-
	getGabarito(Q, G),
	G =:= Alternativa,
	PontuacaoAtual is 20 - 5 - DiffTempo + Pontuacao.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, False, PontuacaoAtual) :-
	getGabarito(Q, G),
	G =:= Alternativa,
	PontuacaoAtual is 20 - DiffTempo + Pontuacao.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, True, PontuacaoAtual) :-
	getGabarito(Q, G),
	G =\= Alternativa,
	Aux is (-1) * (20 + DiffTempo),
	PontuacaoAtual is Aux + Pontuacao.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, False, PontuacaoAtual) :-
	getGabarito(Q, G),
	G =\= Alternativa,
	PontuacaoAtual is (-1) * (20 + DiffTempo) + Pontuacao.




