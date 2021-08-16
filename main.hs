import System
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
	| x == "3" = recordes
	| x == "4" = sobre
	| x == "5" = System.exit
	| otherwise = invalidOption