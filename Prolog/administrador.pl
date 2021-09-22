

setup_bd :-
	consult('./data/bd_adm.pl').


cadastra_adm(S) :-
	setup_bd,
	(administrador(S)) -> nl, writeln("Administrador já cadastrado!"), nl;



cadastraAdm :- 
	nl, write("Insira sua senha: "), nl,
	read_line_to_String(Senha),
	cadastra_adm(Senha).

excluiAdm :- 
	nl, write("Digite sua senha para confirmar exclusão: "), nl,
	read_line_to_String(Senha),
	setup_bd,
	(administrador(Senha)) -> exclui_adm(Senha), writeln("Administrador excluído com sucesso!");
	write("Senha incorreta. Tente novamente."), nl.

exclui_adm(Senha) :- 
	setup_bd,
	retract(administrador(Senha)),
	tell('./data/bd_adm.pl'), nl,
	told.


