:- module('perguntinha', [cadastra_perguntinha/0, remove_perguntinha/0, getQuestao/2, getTotalQuestoes/1, teste/0, exibeQuestoes/0, existe_perguntinha/1]).
:- use_module(menu).
:- encoding(utf8).

setup_bd :-
	consult('./data/bd_perguntinhas.pl').

arquivo_vazio :-
	\+(predicate_property(perguntinha(_), dynamic)).

valida_gabarito(Letra) :-
    (   Letra @>= "a",
        Letra @=< "d"
     -> true
     ;  writeln("Entrada incorreta! Digite uma letra entre 'a' e 'd'."),
	 read_line_to_string(user_input, Gabarito),
	 string_lower(Gabarito, NovaLetra),
	 valida_gabarito(NovaLetra)).

cadastra_perguntinha :-
	setup_bd,
	nl, writeln("Insira sua Perguntinha: "),
	read_line_to_string(user_input, Questao),
	nl, writeln("Insira a alternativa A da Perguntinha: "),
	read_line_to_string(user_input, AlternativaA),
	nl, writeln("Insira a alternativa B da Perguntinha: "),
	read_line_to_string(user_input, AlternativaB),
	nl, writeln("Insira a alternativa C da Perguntinha: "),
	read_line_to_string(user_input, AlternativaC),
	nl, writeln("Insira a alternativa D da Perguntinha: "),
	read_line_to_string(user_input, AlternativaD),
	nl, writeln("Insira o gabarito da Perguntinha (de 'a' a 'd'): "),
	read_line_to_string(user_input, Gabarito),
	string_lower(Gabarito, Letra),
	valida_gabarito(Letra),
	nl, writeln("Insira a dica da Perguntinha: "),
	read_line_to_string(user_input, Dica),
	assertz(perguntinha(Questao, AlternativaA, AlternativaB, AlternativaC, AlternativaD, Gabarito, Dica)),
	adiciona_perguntinha,
	writeln("Perguntinha cadastrada com sucesso!"), nl.


adiciona_perguntinha :-
	setup_bd,
    tell('./data/bd_perguntinhas.pl'),
    nl,
    listing(perguntinha/7),
    told.

eh_questao_valida(X, M) :-
    (   number(X),
		number(M),
        X >= 1,
        X =< M
     -> true
     ;  string_concat("Entrada incorreta! Digite um NÙMERO que esteja entre 1 e ", M, Erro),
	 	writeln(Erro),
		remove_perguntinha,
        fail).


existe_perguntinha(N) :-
	(   number(N),
        N >= 1
     -> true
     ;  write("Não há Perguntinhas para remover."), nl,
	 	segundoMenuAdministrador).

remove_perguntinha :-
	setup_bd,
	getTotalQuestoes(TotalPerguntinhas),
	existe_perguntinha(TotalPerguntinhas),
	exibeQuestoes,
	nl, writeln("Insira a Perguntinha que deseja remover: "),
	read_line_to_string(user_input, Questao),
	number_codes(N, Questao),
	eh_questao_valida(N, TotalPerguntinhas),
	exclui_perguntinha(N),
	writeln("Perguntinha removida com sucesso!"), nl.

get_questoes(Questoes) :-
	setup_bd,
	findall([Questao, AlternativaA, AlternativaB, AlternativaC, AlternativaD, Gabarito,Dica], perguntinha(Questao, AlternativaA, AlternativaB, AlternativaC, AlternativaD, Gabarito, Dica), Questoes).


exclui_perguntinha(NumPerguntinha) :-
	get_questoes(Queries),
	nth1(NumPerguntinha, Queries, Perguntinha),
	nth0(0, Perguntinha, Enunciado),
	retract(perguntinha(Enunciado,_, _, _, _, _, _)),
    tell('./data/bd_perguntinhas.pl'),
    nl,
    listing(perguntinha/7),
    told.


getQuestao(NumPerguntinha, Perguntinha) :-
	get_questoes(Queries),
	nth0(NumPerguntinha, Queries, Perguntinha).

teste :-
	get_questoes(Queries),
	numeraQuestoes(Queries, 1).


getTotalQuestoes(TotalLinhas) :-
	get_questoes(Queries),
	length(Queries, TotalLinhas).

exibeEnunciado(Perguntinha, N) :-
	nth0(0, Perguntinha, Enunciado),
	string_concat(N, " - ", NumQuestao),
	string_concat(NumQuestao, Enunciado, Questao),
	write(Questao), nl.


numeraQuestoes([], _).
 numeraQuestoes([H|T], N) :- 
	exibeEnunciado(H, N),
	P is N + 1,
	numeraQuestoes(T, P).

exibeQuestoes :-
	get_questoes(Queries),
	numeraQuestoes(Queries, 1).


exibeQuestao(Perguntinha) :-
	nth0(0, Perguntinha, Enunciado),
	nth0(1, Perguntinha, AlternativaA),
	nth0(2, Perguntinha, AlternativaB),
	nth0(3, Perguntinha, AlternativaC),
	nth0(4, Perguntinha, AlternativaD),
	nth0(6, Perguntinha, DicaPerguntinha),
	write(AlternativaA),
	
		string_concat("a) ", AlternativaA, LetraA),
		string_concat("b) ", AlternativaB, LetraB),
		string_concat("c) ", AlternativaC, LetraC),
		string_concat("d) ", AlternativaD, LetraD),
		string_concat("e) ", DicaPerguntinha, LetraE),
		write(Enunciado), nl,
		write(LetraA), nl,
		write(LetraB), nl,
		write(LetraC), nl,
		write(LetraD), nl,
		write(LetraE), nl.