:- module('administrador', [cadastra_adm/0, exclui_adm/0]).
:- encoding(utf8).

setup_bd :-
	consult('./data/bd_adm.pl').


login :-
	setup_bd,
	arquivo_vazio -> writeln("Administrador não cadastrado, por favor, faça seu cadastro."), nl, false ;
	(administrador(_)) -> login_adm ;
	writeln("Administrador não cadastrado, por favor, faça seu cadastro."), nl, false.

login_adm :-
	nl,
	writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),
	administrador(Senha) -> nl, writeln("Login feito com sucesso.");
	writeln("Senha incorreta, tente novamente."), nl, false.


cadastra_adm :-
	setup_bd,
	arquivo_vazio -> cadastraAdm;
	(administrador(_)) -> writeln("Administrador já cadastrado. Insira sua senha."), nl, false;
	cadastraAdm.
	 

cadastraAdm :- 
	nl, writeln("Insira sua senha: "),
	read_line_to_string(user_input, Senha),
	assertz(administrador(Senha)),
	adiciona_adm,
	writeln("Senha cadastrada com sucesso!"), nl.

adiciona_adm :-
	setup_bd,
    tell('./data/bd_adm.pl'),
    nl,
    listing(administrador/1),
    told.
 
exclui_adm :- 
	nl, write("Digite sua senha para confirmar exclusão: "), nl,
	read_line_to_string(user_input, Senha),
	setup_bd,
	(administrador(Senha)) -> exclui_adm(Senha), writeln("Administrador excluído com sucesso!"), nl;
	write("Senha incorreta. Tente novamente."), nl.

exclui_adm(Senha) :- 
	setup_bd,
	retractall(administrador(Senha)),
	tell('./data/bd_adm.pl'), nl,
	told.


arquivo_vazio :-
	\+(predicate_property(administrador(_), dynamic)).