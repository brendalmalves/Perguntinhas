:- encoding(utf8).

setup_bd :-
    consult('./data/bd_sobre.pl').

mostra_texto :-
    setup_bd,
    (sobre(X)) -> mostraTexto;
    writeln("foi").


mostraTexto :-
    assertz(sobre()).

