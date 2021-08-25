import System.Exit (exitSuccess)
import System.Directory
import System.IO
import Control.Exception
import System.IO.Error hiding (catch)
import Prelude hiding (catch)


data Perguntinha = Perguntinha {
    enunciadoQuestao :: String,
    enunciadoAlternativaA :: String,
    enunciadoAlternativaB :: String,
    enunciadoAlternativaC :: String,
    enunciadoAlternativaD :: String,
    enunciadoDica :: String,
    enunciadoAlternativaCorreta :: String} deriving (Read, Show)


main :: IO()
main = do
    putStrLn $ "Boas vindas!"
    putStrLn $ "Perguntinhas é um jogo de perguntas e respostas"
    putStrLn $ "Selecione uma das opções abaixo:\n"
    showMenu

showMenu :: IO()
showMenu = do
	putStrLn("1 - Sou jogador")
	putStrLn("2 - Sou administrador")
	putStrLn("3 - Ver recordes")
	putStrLn("4 - Sobre o jogo")
	putStrLn("5 - Sair\n")

	opcao <- getLine
	menus opcao

confirmMenu :: IO ()
confirmMenu = do
	putStrLn "Tem certeza que deseja excluir sua conta? Essa ação é irreversível."
	putStrLn("1 - Não")
	putStrLn("2 - Sim")

	opcao <- getLine
	opcaoExcluiAdm opcao

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
	putStrLn("\nSelecione uma das opções abaixo:")
	putStrLn("1 - Iniciar jogo")
	putStrLn("2 - Retornar para o menu")

	opcao <- getLine
	opcaoJogador opcao

opcaoJogador :: String -> IO()
opcaoJogador x
--	| x == "1" = jogo --ainda nao sei qual vai ser o nome dessa funcao entao da pra alterar depois
	| x == "2" = showMenu
	| otherwise = invalidOption menuJogador

menuAdministrador :: IO()
menuAdministrador = do
	putStrLn("\nSelecione uma das opções abaixo:")
	putStrLn("1 - Já tenho cadastro (fazer login)")
	putStrLn("2 - Não tenho cadastro (criar conta)")
	putStrLn("3 - Retornar para o menu")

	opcao <- getLine
	opcaoAdministrador opcao

segundoMenuAdministrador :: IO()
segundoMenuAdministrador = do
	putStrLn("\nEscolha o que você deseja fazer:")
	putStrLn("1 - Cadastrar uma nova Perguntinha")
	putStrLn("2 - Modificar ranking")
	putStrLn("3 - Excluir minha conta")
	putStrLn("4 - Retornar para o menu")
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
	| x == "1" = cadastraPergunta -- test
	| x == "2" = print "modificaRanking" -- test
	| x == "3" = confirmMenu
	| x == "4" = showMenu
	| otherwise = invalidOption menuAdministrador


cadastraPergunta :: IO()
cadastraPergunta = do
	putStrLn("\nInsira sua Perguntinha:")
	pergunta <- getLine
	putStrLn("Insira a alternativa A da Perguntinha:")
	alternativaA <- getLine
	putStrLn("Insira a alternativa B da Perguntinha:")
	alternativaB <- getLine
	putStrLn("Insira a alternativa C da Perguntinha:")
	alternativaC <- getLine
	putStrLn("Insira a alternativa D da Perguntinha:")
	alternativaD <- getLine
	putStrLn("Insira a dica da Perguntinha:")
	dica <- getLine
	putStrLn("Insira a alternativa correta da Perguntinha:")
	alternativaCorreta <- getLine
	
	let perguntinha = Perguntinha pergunta alternativaA alternativaB alternativaC alternativaD dica alternativaCorreta
	
	perguntasCadastradas <- doesFileExist "perguntinhas.txt"
    	if not perguntasCadastradas then do
        	file <- openFile "perguntinhas.txt" WriteMode
        	hPutStr file (show perguntinha)
        	hFlush file
        	hClose file
        else do
		appendFile "perguntinhas.txt" ("\n" ++ (show perguntinha))



showRecordes :: IO()
showRecordes = do
	putStrLn("\nAbaixo estão os nicknames dos jogadores que conseguiram fazer atingiram o maior ápice durante uma partida de Perguntinhas")
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
        putStrLn "\nAdministrador criado com sucesso."
        hFlush file
        hClose file
        putStrLn ""
        showMenu

    else do
        putStrLn "Administrador já cadastrado, utilize sua senha para logar."
        loginAdm


excluiAdm :: IO ()
excluiAdm = do
	putStrLn "Insira sua senha: "
	senha <- getLine
	file <- openFile "admin.txt" ReadMode
	senhaCadastrada <- hGetContents file

	if senha == senhaCadastrada then do
		removeFile "admin.txt"
		putStrLn "Cadastro excluído com sucesso!"
		showMenu
	else do
		putStrLn "Senha incorreta. Tente novamente."
		excluiAdm
     	

opcaoExcluiAdm :: String -> IO ()
opcaoExcluiAdm x
	| x == "1" = segundoMenuAdministrador
	| x == "2" = excluiAdm
	| otherwise = invalidOption segundoMenuAdministrador


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

--metodo que recebe a pergunta selecionada aleatoriamente e a exibe na saída do programa para ser respondida
exibeQuestao :: Perguntinha -> IO()
exibeQuestao p = do
	--mostra o enunciado da pergunta p com todas as alternativas a serem respondidas
	alternativa <- getLine
	recebeAlternativa questao alternativa

calculaPontos :: Bool -> Bool -> Int -> Int
calculaPontos verificacao dica tempo =
	if verificacao then
		if !dica then base
		else then base - 5
	else then
		if !dica then base * -1
		else then (base * -1) - 5
	where
		base = 20 + (tempo/2)

verificaQuestao :: Perguntinha -> String -> Bool
--se a string for igual ao gabarito da questao entao o metodo retorna true. caso contrario retorna false

