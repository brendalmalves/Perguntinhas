

setup_bd :-
	consult('./data/bd_adm.pl').


cadastra_adm(S) :-
	setup_bd,
	(administrador(S)) -> nl, writeln("Administrador já cadastrado!"), nl;


cadastraAdm :- 
	nl, write("Insira sua senha: "), nl,
	read(Senha),
	cadastra_adm(Senha).

excluiAdm :- 
	nl, write("Digite sua senha para confirmar exclusão: "), nl,
	read(Senha),
	setup_bd,
	(administrador(Senha)) -> exclui_cat(Senha), writeln("Administrador excluído com sucesso!");
	write("Senha incorreta. Tente novamente."), nl.

exclui_cat(Senha) :- 
	setup_bd,


