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
	writeln("Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."),
	cadastra_no_ranking(Nome, UltimaPontuacao),
	main,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	getTotalQuestoes(TotalQuestoes),
	random_between(0, TotalQuestoes, Rand),
	getQuestao(Rand, Q),
	exibeQuestao(Q),
	get_time(exibiu),
	append(QuestoesSorteadas, [Rand], QuestoesSorteadas1),
	read(Alternativa),
	string_lower(Alternativa, Alternativa1),
	(Alternativa1 =:= "e" -> exibeDica(Q),
				read(Alternativa2),
				get_time(respondeu),
				string_lower(Alternativa2, Alternativa3),
				timediff(exibiu, respondeu, dif),
				respondeQuestao(Q, Alternativa3), Pontuacao, DiffTempo, True, PontuacaoAtual);

				get_time(respondeu),
				timediff(exibiu, respondeu, dif),
				respondeQuestao(Q, Alternativa1, Pontuacao, DiffTempo, False, PontuacaoAtual),
				(Pontuacao >= Apex -> inicia_jogo(Nome, Pontuacao, Pontuacao, QuestoesSorteadas1));
				inicia_jogo(Nome, Pontuacao, Apex, QuestoesSorteadas1).
				).


timediff(DT1, DT2, Secs) :-
        date_time_stamp(DT1, TS1),
        date_time_stamp(DT2, TS2),
        Secs is TS2 - TS1.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, TeveDica, PontuacaoAtual) :-
	DiffTempo >= 15,
	PontuacaoActual is Pontuacao - 20.
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
	PontuacaoAtual is ((-1) * (20 + DiffTempo)) + Pontuacao.
respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo, False, PontuacaoAtual) :-
	getGabarito(Q, G),
	G =\= Alternativa,
	PontuacaoAtual is (-1) * (20 + DiffTempo) + Pontuacao.




