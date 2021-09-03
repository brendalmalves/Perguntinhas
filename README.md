# Perguntinhas 

Projeto da disciplina Paradigmas de Linguagens de Programação, da UFCG. Perguntinhas é um jogo de perguntas e respostas em que o objetivo é o jogador não deixar com que sua pontuação seja	zerada. Este sempre enfrentará um bot, que escolherá de forma aleatória as perguntas a serem respondidas pelo usuário jogando. Este bot é uma inteligência baseada em heurística e aleatoriedade, programado para escolher as perguntas respondidas pelo jogador.

# Para executar Perguntinhas

1. Clonar o repositório e entrar na pasta do jogo, com os seguintes comandos:

* git clone https://github.com/brendalmalves/Perguntinhas.git
* cd Perguntinhas

2. Instalar algumas bibliotecas necessárias:

* cabal install --lib random
* cabal install --lib split

3. Após a instalação das bibliotecas, execute o programa:

* ghci main.hs
* main