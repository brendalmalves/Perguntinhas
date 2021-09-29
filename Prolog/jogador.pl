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

inicia_jogo (Nome, pontuacoes, questoesSorteadas, R) :- 
	last(pontuacoes, R),
	(R < 0) -> writeln("Sua pontuação foi menor que zero. Sua partida será encerrada, mas seu nome e seu ápice serão guardados no ranking."),
	cadastra_no_ranking(Nome, (getApex(pontuacoes, valorMaximo)),
	mostraMenu;


getApex(L, R) :- 
    length(L, Len),
    Len =:= 1,
    [H|T],
    L = R.

getApex(L, R) :-
    [H|T] = L,
    getApex(T, AT),
    H >= AT,
    R = H.

getApex(L, R) :-
    [H|T] = L,
    getApex(T, AT),
    H < AT,
    R = AT.