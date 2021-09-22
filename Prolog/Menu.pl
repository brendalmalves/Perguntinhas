main :-
	apresentacao,
	mostraMenu, nl.

apresentacao :-
	writeln("Boas vindas!"),
	writeln("Perguntinhas é um jogo de perguntas e respostas"),
	writeln("Selecione uma das opções abaixo:"), nl.

mostraMenu :- 
	writeln("1 - Sou jogador"),
	writeln("2 - Sou administrador"),
	writeln("3 - Ver recordes"),
	writeln("4 - Sobre o jogo"),
	writeln("5 - Sair"),
	read(Option),
	(Option == 1 -> menuJogador;
	Option == 2 -> menuAdministrador;
	Option == 3 -> mostraRanking;
	Option == 4 -> sobre;
	Option == 5 -> sair;
	invalidOption,
	mostraMenu, nl, halt).

menuJogador :- 
	writeln("Selecione uma das opções abaixo:"), nl,
	writeln("1 - Iniciar jogo"),
	writeln("2 - Retornar para o menu"), nl,
	read(Option),
	(Option == 1 -> iniciaJog;
	Option == 2 -> mostraMenu;
	invalidOption,
	menuJogador).

menuAdministrador :- 
	writeln("Selecione uma das opções abaixo:"),
	writeln("1 - Já tenho cadastro (fazer login)"),
	writeln("2 - Não tenho cadastro (criar conta)"),
	writeln("3 - Retornar para o menu"),
	read(Option),
	(Option == 1 -> login,
	Option == 2 -> criarContaAdm,
	Option == 3 -> mostraMenu,
	invalidOption,
	menuAdministrador, halt).

invalidOption :-
	 writeln("Selecione uma alternativa válida."), nl.
	

