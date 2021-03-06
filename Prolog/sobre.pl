:- module('sobre', [mostra_texto/0]).
:- encoding(utf8).

mostra_texto :-
    writeln("Perguntinhas é um jogo de perguntas e respostas em que o objetivo é o jogador não deixar com que sua pontuação seja zerada. Este sempre enfrentará uma inteligência baseada em aleatoriedade, que escolherá as perguntas que serão respondidas de modo aleatório e irá calcular, de acordo com o tempo demorado para responder, quantos pontos o jogador ganhou (caso acerte) ou perdeu (caso erre).
    No jogo haverão turnos, e em cada turno o jogador responde uma única questão, que sempre é composta por uma pergunta e quatro alternativas, sendo apenas uma dessas a alternativa que responde corretamente à questão. Selecionando a alternativa correta, o jogador ganhará pontos; caso contrário, perderá pontos, sendo subtraída uma determinada quantidade [definida pela máquina] de pontos da sua pontuação atual.
    O tempo que um usuário demora para responder é sempre cronometrado pela inteligência, que poderá oferecer ajudas para o jogador e descontar pontos se a demora deste for muito grande ou aceitar a ajuda. Assim, se o tempo cronometrado for muito alto, este ganhará menos pontos caso acerte a questão, como também perderá mais pontos se errá-la.
    O ápice de pontos atingidos pelo jogador durante sua partida fica sempre salvo junto ao seu nome, de modo que sempre que um jogo termina, a quantidade mais alta de pontos atingidos pelo humano é exibida num ranking, juntamente a todos os outros ápices atingidos por jogadores anteriormente.
    O jogo pode terminar de duas maneiras diferentes:
    O jogador chegou a 0 pontos
    Quando isso ocorrer, o jogo deverá dar um bônus de uma única questão a ser respondida pelo usuário, que ganhará uma pontuação para que seu jogo não termine ali;
    O jogador decidiu parar de jogar
    Quando isso ocorrer, o ápice é salvo no ranking e o jogo simplesmente termina.").
