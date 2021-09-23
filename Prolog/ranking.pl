:- module('ranking', [cadastra_no_ranking/2, 
    exclui_ranking/0, exclui_jogador/0, mostra_ranking/0]).
:- encoding(utf8).

setup_bd :-
    consult('./data/db_ranking.pl').

cadastra_no_ranking(Nome, Pontuacao) :-
    assertz(ranking(Nome, Pontuacao)),
    adiciona_no_ranking.

adiciona_no_ranking :-
    setup_bd,
    tell('./data/db_ranking.pl'),
    nl,
    listing(ranking/2),
    told.

exclui_ranking :-
    setup_bd,
    arquivo_vazio("ranking") ;
    ranking(_,_) -> retractall(ranking(_,_)), tell('db_ranking.pl'), nl, told, writeln("Ranking excluído com sucesso."), !;
    writeln("Não é possível excluir ranking, não temos nenhuma pontuação registrada").

exclui_jogador :-
    setup_bd,
    arquivo_vazio("jogador") ;
    ranking(_,_) -> opcao_exclui_jogador;
    writeln("Não é possível excluir jogador do ranking, não temos nenhuma pontuação registrada").
    

arquivo_vazio(Nome) :-
    \+(predicate_property(ranking(_,_), dynamic)) -> format('Não é possível excluir ~w, não temos nenhuma pontuação registrada.', [Nome]).


opcao_exclui_jogador :-
    mostra_ranking,
    nl, write("Qual jogador que voce deseja exluir? "),
    read_line_to_string(user_input, Jogador),
    (ranking(Jogador, _)) -> apaga_jogador(Jogador), nl, writeln("Jogador excluído com sucesso.");
    writeln("Não existe jogador no ranking com este nome de usúario. Tente novamente").
    

apaga_jogador(Jogador) :-
    setup_bd,
    retractall(ranking(Jogador, _)),
    tell('./data/db_ranking.pl'),
    nl,
    listing(ranking/2),
    told.

mostra_ranking :-
    setup_bd,
    (ranking(_, _)) -> formata_ranking ; 
    writeln("Não temos pontuação registrada, que tal iniciar uma partida?").
    

formata_ranking :-
    writeln("Abaixo estão os nicknames dos jogadores que conseguiram fazer atingiram o maior ápice durante uma partida de Perguntinhas"),
    writeln("Jogador         | Pontuação"),
    writeln("----------------------------"),
    findall((X,Y), ranking(X,Y), Lista), 
    sort(2, @>=, Lista, Sorted),
    maplist(formata_tupla, Sorted).


formata_tupla((X,Y)) :-
    adiciona_espaco(X, R),
    format('~w ~w ~w ~n', [R, "|", Y]).
    
adiciona_espaco(Str, R) :-
    string_length(Str, Length),
    X is 15 - Length,
    add_espaco(Str, X, R).

add_espaco(Str, 0, R) :- R = Str, !.
add_espaco(Str, X, R) :-
    string_concat(Str, " ", Str1),
    Y is X - 1,
    add_espaco(Str1, Y, R).
    

    