import System.Exit (exitSuccess)
import System.Directory
import System.IO

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
	| otherwise = invalidOption showMenu

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
	| otherwise = invalidOption menuJogador

menuAdministrador :: IO()
menuAdministrador = do
	putStrLn("Selecione uma das opções abaixo:\n")
	putStrLn("1 - Já tenho cadastro (fazer login)")
	putStrLn("2 - Não tenho cadastro (criar conta)")
	putStrLn("3 - Retornar para o menu")

	opcao <- getLine
	opcaoAdministrador opcao

segundoMenuAdministrador :: IO()
segundoMenuAdministrador = do
	putStrLn("Escolha o que você deseja fazer:\n")
	putStrLn("1 - Cadastrar uma nova Perguntinha")
	putStrLn("2 - Modificar ranking")
	putStrLn("3 - Retornar para o menu")
	opcao <- getLine
	segundaTelaOpcaoAdministrador opcao

opcaoAdministrador :: String -> IO()
opcaoAdministrador x
	| x == "1" = loginAdm
	| x == "2" = criaAdm
	| x == "3" = showMenu
	| otherwise = invalidOption menuAdministrador

segundaTelaOpcaoAdministrador :: String -> IO()
segundaTelaOpcaoAdministrador x
	| x == "1" = print "cadastraPergunta" -- test
	| x == "2" = print "modificaRanking" -- test
	| x == "3" = showMenu
	| otherwise = invalidOption menuAdministrador

showRecordes :: IO()
showRecordes = do
	putStrLn("Abaixo estão os nicknames dos jogadores que conseguiram fazer atingiram o maior ápice durante uma partida de Perguntinhas")
	--recordes -- mostra os recordes. aqui vai precisar de uma opcao para retornar ao menu dentro dessa funcao. algo do tipo "pressione qualquer botao para retornar ao menu".

-- Como só existe um adm, não achei necessário ter nome de usuário, apenas senha e tbm simplifica se for assim.
-- Não sei se eh a melhor forma de fazer, mas pelo que testei, funciona kkk.
-- Acho que pode ter uma opção de resetar ou modificar a senha. 
loginAdm :: IO()
loginAdm = do
    adminCadastrado <- doesFileExist "admin.txt"
    
    if adminCadastrado then do
        putStr "Insira sua senha: "
        senha <- getLine
        file <- openFile "admin.txt" ReadMode
        senhaCadastrada <- hGetContents file
        
        if senha == senhaCadastrada then do
			putStrLn "Login realizado com sucesso."
			segundoMenuAdministrador
        else do
			putStrLn "Senha incorreta, tente novamente.\n"
			menuAdministrador
        hClose file
    
    else do
        putStrLn "Senha não cadastrada. Por favor, cadastre uma senha."
        criaAdm


criaAdm :: IO ()
criaAdm = do
    adminCadastrado <- doesFileExist "admin.txt"
    if not adminCadastrado then do
        putStrLn "Insira sua senha: "
        senha <- getLine
        file <- openFile "admin.txt" WriteMode
        hPutStr file senha
        putStrLn "Administrador criado com sucesso."
        hFlush file
        hClose file
    else do
        putStrLn "Administrador já cadastrado, utilize sua senha para logar."
        loginAdm

sobre :: IO()
sobre = do
	let file = "sobre.txt"
	doc <- readFile file
	putStrLn doc
	showMenu

invalidOption :: (IO()) -> IO()
invalidOption f = do
	putStrLn("Selecione uma alternativa válida")
	f