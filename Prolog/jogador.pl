:- use_module(ranking).
:- use_module(Menu).

setup_bd :-
	consult('./data/bd_jogador.pl').

iniciaJogo :- 
	setup_bd,
	writeln("Digite seu nome com até 15 caracteres: "),
	read_line_to_string(user_input, Nome), 
	string_length(Nome, X),
	(X <= 15) -> inicia_jogo, nl;
	write("Seu nome é maior que 15 caracteres, tente novamente."), iniciaJogo, nl.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	UltimaPontuacao < 0,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	%totalQuestoes = numero total de questoes cadastradas no sistema
	totalQuestoes =:= 0,
	writeln("Ainda não há questões cadastradas no sistema."),
	main,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	length(QuestoesSorteadas, Len),
	%totalQuestoes = numero total de questoes cadastradas no sistema
	Len =:= totalQuestoes,
	writeln("Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."),
	cadastra_no_ranking(Nome, UltimaPontuacao),
	main,
	halt.
inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	%totalQuestoes = numero total de questoes cadastradas no sistema (usar o predicado line_count)
	random_between(0, totalQuestoes, Rand),
	getQuestao(Rand, Q),
	exibeQuestao(Q),
	get_time(exibiu),
	append(QuestoesSorteadas, [Rand], QuestoesSorteadas1),
	read(Alternativa),
	get_time(respondeu),
	diff = timediff(exibiu, respondeu, dif),
	respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo),
	(Pontuacao >= Apex -> inicia_jogo(Nome, Pontuacao, Pontuacao, QuestoesSorteadas1));
	inicia_jogo(Nome, Pontuacao, Apex, QuestoesSorteadas1).


timediff(DT1, DT2, Secs) :-
        date_time_stamp(DT1, TS1),
        date_time_stamp(DT2, TS2),
        Sec is TS2 - TS1.

respondeQuestao(Q, Alternativa, Pontuacao, DiffTempo) :-
	gabarito(Q, G),
	Alternativa =:= G,
	
