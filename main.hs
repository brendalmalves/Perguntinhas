import System.Exit (exitSuccess)

main :: IO()
main = do
	putStrLn $ "Boas vindas!"
	putStrLn $ "Perguntinhas é um jogo de perguntas e resposta"
	putStrLn $ "Selecione uma das opções abaixo:\n"
	showMenu

showMenu :: IO()
showMenu = do
	putStrLn("1 - Sou jogador")
	putStrLn("2 - Sou administrador")
	putStrLn("3 - Ver recordes")
	putStrLn("4 - Sobre o jogo")
	putStrLn("5 - Sair")

	opcao <- getLine
	menus opcao

menus :: String -> IO()
menus x
	| x == "1" = menuJogador
	| x == "2" = menuAdministrador
	| x == "3" = showRecordes
	| x == "4" = sobre
	| x == "5" = exitSuccess
	| otherwise = invalidOption

menuJogador :: IO()
menuJogador = do
	putStrLn("Selecione uma das opções abaixo:\n")
	putStrLn("1 - Iniciar jogo")
	putStrLn("2 - Retornar para o menu")

	opcao <- getLine
	opcaoJogador opcao

opcaoJogador :: String -> IO()
opcaoJogador x
	| x == "1" = jogo --ainda nao sei qual vai ser o nome dessa funcao entao da pra alterar depois
	| x == "2" = showMenu
	| otherwise = invalidOption

menuAdministrador :: IO()
menuAdministrador = do
	putStrLn("Selecione uma das opções abaixo:\n")
	putStrLn("1 - Já tenho cadastro (fazer login)")
	putStrLn("2 - Não tenho cadastro (criar conta)")
	putStrLn("3 - Retornar para o menu")

	opcao <- getLine
	opcaoAdministrador opcao

opcaoAdministrador :: String -> IO()
opcaoAdministrador x
	| x == "1" = loginAdm
	| x == "2" = criaAdm
	| x == "3" = showMenu
	| otherwise = invalidOption

showRecordes :: IO()
showRecordes = do
	putStrLn("Abaixo estão os nicknames dos jogadores que conseguiram fazer atingiram o maior ápice durante uma partida de Perguntinhas")
	recordes -- mostra os recordes. aqui vai precisar de uma opcao para retornar ao menu dentro dessa funcao. algo do tipo "pressione qualquer botao para retornar ao menu".

sobre :: IO()
sobre = do
	let file = "sobre.txt"
	doc <- readFile file
	putStrLn doc
	showMenu