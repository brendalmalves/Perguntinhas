:- module('jogador', [iniciaJogo/0]).
:- use_module(ranking).
:- use_module(perguntinha).
:- use_module(menu).
:- encoding(utf8).

% sorteia_questao(TotalQuestoes, QuestoesSorteadas, Rand):- 
% 	length(QuestoesSorteadas, Len),
% 	Len =:= 0 -> 		
% 	random_between(1, TotalQuestoes, Rand);

% 	random_between(1, TotalQuestoes, Rand),
% 	member(Rand, QuestoesSorteadas) -> sorteia_questao(TotalQuestoes, QuestoesSorteadas, RandS);
% 	true.

% sorteia_questao(TotalQuestoes, QuestoesSorteadas, Rand):- 
% 	random_between(1, TotalQuestoes, Rand),
% 	(member(Rand, QuestoesSorteadas)-> sorteia_questao(TotalQuestoes, QuestoesSorteadas, NovaQ), Rand is NovaQ, true;
% 	true).

sorteia_questao(TotalQuestoes, QuestoesSorteadas, Rand):- 
	random_between(1, TotalQuestoes, Ale),
	(member(Ale, QuestoesSorteadas)-> sorteia_questao(TotalQuestoes, QuestoesSorteadas, Rand); true),
	write(Ale),
	Rand is Ale + 0, true.

valida_resposta(Letra, LetraVerificada) :-
    (   Letra @>= "a",
        Letra @=< "f"
     -> LetraVerificada = Letra, true
     ;  writeln("Entrada incorreta! Digite uma letra entre 'a' e 'f'."),
	 read_line_to_string(user_input, NovaAlternativa),
	 string_lower(NovaAlternativa, NovaLetra),
	 valida_resposta(NovaLetra, LetraVerificada)).


iniciaJogo :- 
	writeln("Digite seu nome com até 15 caracteres: "),
	read_line_to_string(user_input, Nome), 
	string_length(Nome, X),
	X =< 15 -> inicia_jogo(Nome, 0, 0, []), nl;
	write("Seu nome é maior que 15 caracteres, tente novamente."), nl, iniciaJogo, nl.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	length(QuestoesSorteadas, Len),
	Len >= 2,
	UltimaPontuacao < 0, 
	write("Sua pontuação foi menor que zero. Sua partida será encerrada, mas seu nome e seu ápice serão guardados no ranking."), nl, nl,
	cadastra_no_ranking(Nome, Apex),
	main.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	getTotalQuestoes(TotalQuestoes),
	TotalQuestoes =:= 0,
	writeln("Ainda não há questões cadastradas no sistema."),
	main,
	halt.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	length(QuestoesSorteadas, Len),
	write(Len),
	getTotalQuestoes(TotalQuestoes),
	Len =:= TotalQuestoes,
	writeln("Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."), nl, nl,
	cadastra_no_ranking(Nome, Apex),
	main,
	halt.

inicia_jogo(Nome, UltimaPontuacao, Apex, QuestoesSorteadas) :-
	getTotalQuestoes(TotalQuestoes),
	sorteia_questao(TotalQuestoes, QuestoesSorteadas, Rand),
	getQuestao(Rand, Q),
	exibeQuestao(Q),
	get_time(Exibiu),
	append(QuestoesSorteadas, [Rand], QuestoesSorteadas1),
	read_line_to_string(user_input, Alternativa),
	string_lower(Alternativa, AlternativaMinuscula),
	valida_resposta(AlternativaMinuscula, AlternativaVerificada),
	(AlternativaVerificada =:= "e" 
		-> 
		exibeDica(Q),
		read_line_to_string(user_input, Alternativa2),
		valida_resposta(Alternativa2, NovaAlternativaVerificada),
		get_time(Respondeu),
		string_lower(NovaAlternativaVerificada, Alternativa3),
		timediff(Exibiu, Respondeu, DiffTempo),
		respondeQuestao(Q, Alternativa3, UltimaPontuacao, DiffTempo, True, PontuacaoAtual),
		(PontuacaoAtual >= Apex 
			-> 
			inicia_jogo(Nome, PontuacaoAtual, PontuacaoAtual, QuestoesSorteadas1)
			;
			inicia_jogo(Nome, PontuacaoAtual, Apex, QuestoesSorteadas1))
		;

		AlternativaVerificada =:= "f"
		 -> 
		 write("Você escolheu encerrar sua partida. Seu nome e ápice serão guardados no ranking e você retornará para o menu."), nl, nl,
		cadastra_no_ranking(Nome, Apex),
		main;

		get_time(Respondeu),
		timediff(Exibiu, Respondeu, DiffTempo),
		respondeQuestao(Q, AlternativaVerificada, UltimaPontuacao, DiffTempo, False, PontuacaoAtual),
			(PontuacaoAtual >= Apex 
				-> 
				inicia_jogo(Nome, PontuacaoAtual, PontuacaoAtual, QuestoesSorteadas1)
				;
				inicia_jogo(Nome, PontuacaoAtual, Apex, QuestoesSorteadas1))).


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




