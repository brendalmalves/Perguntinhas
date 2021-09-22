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
	(Option == 1 -> jogador: iniciaJogo, menuJogador;
	Option == 2 -> mostraMenu;
	invalidOption,
	menuJogador).

menuAdministrador :- 
	writeln("Selecione uma das opções abaixo:"),
	writeln("1 - Já tenho cadastro (fazer login)"),
	writeln("2 - Não tenho cadastro (criar conta)"),
	writeln("3 - Retornar para o menu"),
	read(Option),
	(Option == 1 -> administrador: login, menuAdministrador;
	Option == 2 -> administrador: cadastraAdm, menuAdministrador;
	Option == 3 -> mostraMenu;
	invalidOption,
	menuAdministrador).

invalidOption :-
	 writeln("Selecione uma alternativa válida."), nl.
	
confirmMenu :-
	writeln("Tem certeza que deseja excluir sua conta? Essa ação é irreversível."),
	writeln("1 - Não"),
	writeln("2 - Sim\n"),
	read(Option),
	opcaoExcluiAdm(Option),
	halt.

menuJogador :-
	writeln("\nSelecione uma das opções abaixo:"),
	writeln("1 - Iniciar jogo"),
	writeln("2 - Retornar para o menu\n"),
	read(Option),
	opcaoJogador(opcao),
	halt.

segundoMenuAdministrador :-
	writeln("\nEscolha o que você deseja fazer:"),
	writeln("1 - Cadastrar uma nova Perguntinha"),
	writeln("2 - Remover uma Perguntinha"),
	writeln("3 - Modificar ranking"),
	writeln("4 - Excluir minha conta"),
	writeln("5 - Retornar para o menu\n"),
	read(Option),
	segundaTelaOpcaoAdministrador(Option),
	halt.

telaModificaRanking :-
	writeln("\nEscolha o que você deseja fazer:"),
	writeln("1 - Excluir jogador do ranking"),
	writeln("2 - Excluir ranking"),
	writeln("3 - Retornar para o menu\n"),
	read(Option),
	menuModificaRanking(Option),
	halt.