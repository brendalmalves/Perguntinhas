:- module('sobre', [mostra_texto/0]).
:- encoding(utf8).

setup_bd :-
    consult('./data/bd_sobre.pl').

mostra_texto :-
    setup_bd,
    sobre(X), nl,
    write(X).
