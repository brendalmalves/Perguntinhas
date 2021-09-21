setup_bd :-
	consult('./data/bd_adm.pl').


cadastra_adm(S) :-
	setup_bd.

cadastraAdm :- 
	nl, write("Insira sua senha: "), nl,
	read(Senha),
	cadastra_adm(Senha).