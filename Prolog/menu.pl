:- module('Menu', [segundoMenuAdministrador/0]).
:- use_module(administrador).
:- use_module(ranking).
:- use_module(sobre).
:- use_module(perguntinha).
:- use_module(jogador).

:- encoding(utf8).

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
	read_line_to_string(user_input, Option),
	(Option == "1" -> menuJogador;
	Option == "2" -> menuAdministrador;
	Option == "3" -> ranking:mostra_ranking, volta_tela_enter -> mostraMenu;
	Option == "4" -> sobre:mostra_texto, volta_tela_enter -> mostraMenu;
	Option == "5" -> sair;
	invalidOption,
	mostraMenu, nl, halt).

sair :- halt.

volta_tela_enter :-
	nl,
	writeln("Pressione enter para voltar ao menu anterior"),
	read_line_to_string(user_input,  _),
	true.

menuJogador :- 
	writeln("Selecione uma das opções abaixo:"), nl,
	writeln("1 - Iniciar jogo"),
	writeln("2 - Retornar para o menu"), nl,
	read_line_to_string(user_input, Option),
	(Option == "1" -> jogador: iniciaJogo, menuJogador;
	Option == "2" -> mostraMenu;
	invalidOption,
	menuJogador).

menuAdministrador :- 
	writeln("Selecione uma das opções abaixo:"),
	writeln("1 - Já tenho cadastro (fazer login)"),
	writeln("2 - Não tenho cadastro (criar conta)"),
	writeln("3 - Retornar para o menu"),
	read_line_to_string(user_input, Option),
	(Option == "1" -> (administrador:login -> segundoMenuAdministrador ; mostraMenu);
	Option == "2" -> administrador:cadastra_adm, menuAdministrador;
	Option == "3" -> mostraMenu;
	invalidOption,
	menuAdministrador).

invalidOption :-
	 writeln("Selecione uma alternativa válida."), nl.
	
confirmMenu :-
	writeln("Tem certeza que deseja excluir sua conta? Essa ação é irreversível."),
	writeln("1 - Não"),
	writeln("2 - Sim\n"),
	read_line_to_string(user_input, Option), 
	(Option == "1" -> segundoMenuAdministrador;
	Option == "2" -> administrador:exclui_adm, mostraMenu;
	invalidOption,
	confirmMenu).


menuJogador :-
	writeln("\nSelecione uma das opções abaixo:"),
	writeln("1 - Iniciar jogo"),
	writeln("2 - Retornar para o menu\n"),
	read(Option),
	opcaoJogador(Option),
	halt.

segundoMenuAdministrador :-
	writeln("\nEscolha o que você deseja fazer:"),
	writeln("1 - Cadastrar uma nova Perguntinha"),
	writeln("2 - Remover uma Perguntinha"),
	writeln("3 - Modificar ranking"),
	writeln("4 - Excluir minha conta"),
	writeln("5 - Retornar para o menu\n"),
	
	read_line_to_string(user_input, Option),
	
	(Option == "1" -> perguntinha:cadastra_perguntinha, segundoMenuAdministrador;
	Option == "2" -> perguntinha:remove_perguntinha, segundoMenuAdministrador;
	Option == "3" -> telaModificaRanking;
	Option == "4" -> confirmMenu;
	Option == "5" -> mostraMenu;
	invalidOption,
	segundoMenuAdministrador).

telaModificaRanking :-
	writeln("\nEscolha o que você deseja fazer:"),
	writeln("1 - Excluir jogador do ranking"),
	writeln("2 - Excluir ranking"),
	writeln("3 - Retornar para o menu anterior\n"),
	read_line_to_string(user_input, Option),
	(Option == "1" -> ranking:exclui_jogador, telaModificaRanking;
	Option == "2" -> ranking:exclui_ranking, telaModificaRanking;
	Option == "3" -> segundoMenuAdministrador;
	invalidOption,
	telaModificaRanking).
 