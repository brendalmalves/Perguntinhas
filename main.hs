import System.Exit (exitSuccess)
import System.Directory
import System.IO
import Control.Exception
import System.IO.Error hiding (catch)
import Prelude hiding (catch)
import Data.List
import Control.Applicative
import Data.List.Split
import System.Random
import Data.Time.Clock
import Data.Char

data Perguntinha = Perguntinha {
    enunciadoQuestao :: String,
    enunciadoAlternativaA :: String,
    enunciadoAlternativaB :: String,
    enunciadoAlternativaC :: String,
    enunciadoAlternativaD :: String,
    enunciadoDica :: String,
    enunciadoAlternativaCorreta :: String} deriving (Read, Show, Eq)


main :: IO()
main = do
    putStrLn "Boas vindas!"
    putStrLn "Perguntinhas é um jogo de perguntas e respostas"
    putStrLn "Selecione uma das opções abaixo:\n"
    showMenu

showMenu :: IO()
showMenu = do
        putStrLn "1 - Sou jogador"
        putStrLn "2 - Sou administrador"
        putStrLn "3 - Ver recordes"
        putStrLn "4 - Sobre o jogo"
        putStrLn "5 - Sair\n"

        opcao <- getLine
        menus opcao

confirmMenu :: IO ()
confirmMenu = do
        putStrLn "Tem certeza que deseja excluir sua conta? Essa ação é irreversível."
        putStrLn "1 - Não"
        putStrLn "2 - Sim\n"

        opcao <- getLine
        opcaoExcluiAdm opcao

menus :: String -> IO()
menus x
        | x == "1" = menuJogador
        | x == "2" = menuAdministrador
        | x == "3" = mostraRanking
        | x == "4" = sobre
        | x == "5" = exitSuccess
        | otherwise = invalidOption showMenu

menuJogador :: IO()
menuJogador = do
        putStrLn "\nSelecione uma das opções abaixo:"
        putStrLn "1 - Iniciar jogo"
        putStrLn "2 - Retornar para o menu\n"

        opcao <- getLine
        opcaoJogador opcao

opcaoJogador :: String -> IO()
opcaoJogador x
        | x == "1" = iniciaJogo 
        | x == "2" = showMenu
        | otherwise = invalidOption menuJogador

iniciaJogo = do
        -- Para que a exibição do ranking tenha um formato fixo
        putStr "Digite seu nome com até 15 caracteres: "
        nome <- getLine
        if length nome > 15 then do
                putStrLn "Seu nome é maior que 15 caracteres, tente novamente."
                iniciaJogo
        else do
                jogo nome [] [0]

menuAdministrador :: IO()
menuAdministrador = do
        putStrLn "\nSelecione uma das opções abaixo:"
        putStrLn "1 - Já tenho cadastro (fazer login)"
        putStrLn "2 - Não tenho cadastro (criar conta)"
        putStrLn "3 - Retornar para o menu\n"

        opcao <- getLine
        opcaoAdministrador opcao

segundoMenuAdministrador :: IO()
segundoMenuAdministrador = do
        putStrLn "\nEscolha o que você deseja fazer:"
        putStrLn "1 - Cadastrar uma nova Perguntinha"
        putStrLn "2 - Modificar ranking"
        putStrLn "3 - Excluir minha conta"
        putStrLn "4 - Retornar para o menu\n"
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
        | x == "1" = cadastraPergunta
        | x == "2" = telaModificaRanking
        | x == "3" = confirmMenu
        | x == "4" = showMenu
        | otherwise = invalidOption menuAdministrador

telaModificaRanking :: IO()
telaModificaRanking = do
        putStrLn "\nEscolha o que você deseja fazer:"
        putStrLn "1 - Excluir jogador do ranking"
        putStrLn "2 - Excluir ranking"
        putStrLn "3 - Retornar para o menu\n"
        opcao <- getLine
        menuModificaRanking opcao

menuModificaRanking :: String -> IO()
menuModificaRanking x
        | x == "1" = excluiJogadorRanking
        | x == "2" = excluiRanking
        | x == "3" = segundoMenuAdministrador
        | otherwise = invalidOption telaModificaRanking

cadastraPergunta :: IO()
cadastraPergunta = do
        putStrLn "\nInsira sua Perguntinha:"
        pergunta <- getLine
        putStrLn "\nInsira a alternativa A da Perguntinha:"
        alternativaA <- getLine
        putStrLn "\nInsira a alternativa B da Perguntinha:"
        alternativaB <- getLine
        putStrLn "\nInsira a alternativa C da Perguntinha:"
        alternativaC <- getLine
        putStrLn "\nInsira a alternativa D da Perguntinha:"
        alternativaD <- getLine
        putStrLn "\nInsira a dica da Perguntinha:"
        dica <- getLine
        putStrLn "Insira a alternativa correta da Perguntinha. Digite um caractere de 'a' a 'd', apenas o caractere:"
        alternativaCorreta <- getLine --seria bom ter um loop (recursao) ate o usuario digitar uma alternativa valida
        let lowerAlt = map toLower alternativaCorreta
        cadastraPerguntaGabarito pergunta alternativaA alternativaB alternativaC alternativaD dica lowerAlt

cadastraPerguntaGabarito :: String -> String -> String -> String -> String -> String -> String -> IO()
cadastraPerguntaGabarito pergunta alternativaA alternativaB alternativaC alternativaD dica gabarito = do
        if ehValida gabarito then do
                let perguntinha = Perguntinha pergunta alternativaA alternativaB alternativaC alternativaD dica gabarito
                perguntasCadastradas <- doesFileExist "perguntinhas.txt"
                if not perguntasCadastradas then do
                        file <- openFile "perguntinhas.txt" WriteMode
                        hPutStr file (show perguntinha)
                        hFlush file
                        hClose file
                else appendFile "perguntinhas.txt" ("\n" ++ show perguntinha)
        else do
                putStrLn "\nVocê não inseriu um gabarito válido para sua Perguntinha. Por favor, digite novamente um caractere válido de 'a' a 'd':"
                alternativaCorreta <- getLine
                let lowerAlt = map toLower alternativaCorreta
                cadastraPerguntaGabarito pergunta alternativaA alternativaB alternativaC alternativaD dica lowerAlt

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

cadastraNoRanking :: (String, Int) -> IO()
cadastraNoRanking tupla = do
        ranking <- readFile' "ranking.txt"
        if ehVazio ranking then do
                file <- openFile "ranking.txt" WriteMode
                hPutStr file (formataTuplaArquivo tupla)
                hFlush file
                hClose file
        else appendFile "ranking.txt"  ("\n" ++ formataTuplaArquivo tupla) 

voltaTelaEnter :: IO b -> IO b
voltaTelaEnter f = do
        putStrLn "Pressione enter para voltar ao menu anterior"
        x <- getLine
        f

mostraRanking :: IO ()
mostraRanking = do
        ranking <- readFile' "ranking.txt"
        if not (ehVazio ranking) then do
                let rankingEmTupla = map (converteEmTupla . words) (lines ranking)
                let rankingOrdenado = ordenaDecrescente rankingEmTupla
                putStrLn (formataRanking rankingOrdenado)
        else do
                putStrLn "Não temos registro de nenhuma pontuação de jogador. Que tal iniciar uma partida?"
        voltaTelaEnter showMenu

formataRanking :: [(String, Int)] -> String
formataRanking ranking = "\nAbaixo estão os nicknames dos jogadores que conseguiram fazer atingiram o maior ápice durante uma partida de Perguntinhas\n" ++
                                                 "Jogador         | Pontuação\n" ++
                         "----------------------------\n" ++
                         unlines (map formataTupla ranking)

converteEmTupla :: [String] -> (String, Int)
converteEmTupla [x, y] = (x, read y)

ordenaDecrescente :: [(a, Int)] -> [(a, Int)]
ordenaDecrescente = sortOn (\(_,y) -> negate y)

-- Transforma tupla em nomeJogador | pontuação, para exibição no ranking
formataTupla :: (String, Int) -> String
formataTupla (x, y) = x ++ concat(adicionaEspaco(length x)) ++ " | " ++ show y

-- 
adicionaEspaco :: Int -> [String]
adicionaEspaco x
        | x < 15 = replicate (15 - x) " "
        | otherwise = []

-- Transforma tupla em nomeJogador pontuação, para adição no aquivo do ranking
formataTuplaArquivo :: (String, Int) -> String
formataTuplaArquivo (x, y) = x ++ " " ++ show y

readicionaNoArquivo :: [(String, Int)] -> IO ()
readicionaNoArquivo ranking = do
        file <- openFile "ranking.txt" WriteMode
        hPutStr file (unlines (map formataTuplaArquivo ranking))
        hFlush file
        hClose file

ehVazio :: String -> Bool
ehVazio x = x == ""

excluiJogadorRanking :: IO ()
excluiJogadorRanking = do

        ranking <- readFile' "ranking.txt"
        if not (ehVazio ranking) then do
                putStrLn "Qual o nome do jogador que você deseja excluir do ranking?"
                nome <- getLine

                let rankingCompletoEmTupla = map (converteEmTupla . words) (lines ranking)
                let rankingFiltrado = filter ((/=nome).fst) rankingCompletoEmTupla

                if rankingCompletoEmTupla == rankingFiltrado then do
                        putStrLn "Não existe jogador no ranking com este nome de usúario. Tente novamente"
                        telaModificaRanking
                else do
                        readicionaNoArquivo rankingFiltrado
                        putStrLn "Jogador removido com sucesso."
        else
                putStrLn "Não é possível excluir jogador do ranking, não temos nenhuma pontuação registrada"
        voltaTelaEnter telaModificaRanking

excluiRanking :: IO ()
excluiRanking = do
        ranking <- readFile' "ranking.txt"
        if ehVazio ranking then do
               putStrLn "Não foi possível excluir ranking, não temos nenhuma pontuação registrada."
               telaModificaRanking
        else do
                file <- openFile "ranking.txt" WriteMode
                hPutStr file ""
                hFlush file
                hClose file
                putStrLn "Ranking excluído com sucesso."
        voltaTelaEnter telaModificaRanking

sobre :: IO()
sobre = do
        let file = "sobre.txt"
        doc <- readFile file
        putStrLn doc
        showMenu

invalidOption :: IO() -> IO()
invalidOption f = do
        putStrLn "Selecione uma alternativa válida"
        f



getEnunciadoQuestao :: Perguntinha -> String
getEnunciadoQuestao (Perguntinha enunciadoQuestao _ _ _ _ _ _) = enunciadoQuestao

getAlternativaA :: Perguntinha -> String
getAlternativaA (Perguntinha _ enunciadoAlternativaA _ _ _ _ _) = enunciadoAlternativaA

getAlternativaB :: Perguntinha -> String
getAlternativaB (Perguntinha _ _ enunciadoAlternativaB _ _ _ _) = enunciadoAlternativaB

getAlternativaC :: Perguntinha -> String
getAlternativaC (Perguntinha _ _ _ enunciadoAlternativaC _ _ _) = enunciadoAlternativaC

getAlternativaD :: Perguntinha -> String
getAlternativaD (Perguntinha _ _ _ _ enunciadoAlternativaD _ _) = enunciadoAlternativaD

getEnunciadoDica :: Perguntinha -> String
getEnunciadoDica (Perguntinha _ _ _ _ _ enunciadoDica _) = enunciadoDica

getAlternativaCorreta :: Perguntinha -> String
getAlternativaCorreta (Perguntinha _ _ _ _ _ _ enunciadoAlternativaCorreta) = enunciadoAlternativaCorreta

exibeQuestao :: Perguntinha -> IO()
exibeQuestao perguntinha = do     
        putStrLn (getEnunciadoQuestao perguntinha)
        putStrLn ("a) " ++ (getAlternativaA perguntinha))
        putStrLn ("b) " ++ (getAlternativaB perguntinha))
        putStrLn ("c) " ++ (getAlternativaC perguntinha))
        putStrLn ("d) " ++ (getAlternativaD perguntinha))
        putStrLn ("e) Ver dica")
        putStrLn ("f) Sair do jogo")

showDica :: Perguntinha -> IO()
showDica perguntinha = do
        putStrLn ("Dica: " ++ (getEnunciadoDica perguntinha))


acertouQuestao :: Perguntinha -> String -> Bool
acertouQuestao perguntinha resposta  
        | getAlternativaCorreta perguntinha == resposta = True
        | otherwise = False


pacertouQuestao :: Bool -> Int -> Int -> Int
pacertouQuestao teveDica tempoGasto ultimaPontuacao 
        | teveDica = 20 - 5 - tempoGasto + ultimaPontuacao
        | otherwise = 20 - tempoGasto + ultimaPontuacao


errouQuestao :: Bool -> Int -> Int -> Int
errouQuestao teveDica tempoGasto ultimaPontuacao 
        | teveDica = ((-1) * (20 + tempoGasto)) + ultimaPontuacao
        | otherwise = (-1) * (20 + tempoGasto) + ultimaPontuacao


calculaPontos :: Perguntinha -> String -> Bool -> Int -> Int -> Int
calculaPontos perguntinha resposta teveDica tempoGasto ultimaPontuacao 
        | acertouQuestao perguntinha resposta = pacertouQuestao teveDica tempoGasto ultimaPontuacao 
        | otherwise = errouQuestao teveDica tempoGasto ultimaPontuacao 





--esboço/pseudocodigo do metodo de jogo
--recebe como primeiro parametro uma lista de Perguntinha das questoes que ja foram selecionadas anteriormente
--recebe como segundo parametro uma lista de inteiros correspondente as pontuacoes do jogador numa partida
jogo :: String -> [Perguntinha] -> [Int] -> IO()
jogo nome questoes pontos
                | (last pontos) < 0 = do
                        putStrLn $ "Sua pontuação foi menor que zero. Sua partida será encerrada, mas seu nome e seu ápice serão guardados no ranking."
                        putStrLn $ nome ++ ", " ++ "seu ápice foi:" ++ (show (getApex pontos))
                        cadastraNoRanking (nome, (getApex pontos))
                        showMenu
                | otherwise = do
                        -- randomQuestao eh o metodo que escolhe aleatoriamente uma questao para ser respondida. retorna Perguntinha.
                        -- "a" eh o parametro do metodo. certamente deve ser o arquivo em que as questoes estao salvas
                        existePerguntas <- doesFileExist "perguntinhas.txt"                        
                        
                        if not existePerguntas then do
                                putStrLn $ "Ainda não há questões cadastradas no sistema."
                                showMenu
                                return ()
                        else do
                                perguntas <- readFile "perguntinhas.txt"
                                
                                let quantidadePerguntas = length (lines perguntas)
                                if quantidadePerguntas == (length questoes) then do
                                        putStrLn "Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."
                                        putStrLn $ nome ++ ", " ++ "seu ápice foi:" ++ (show (getApex pontos))
                                        cadastraNoRanking (nome, (getApex pontos))
                                        showMenu
                                        return ()
                                else do
                                        geradorAleatorio <- newStdGen
                                        let numeroDaLinha = randomR (0, quantidadePerguntas - 1) geradorAleatorio
                                        let perguntinhas = lines perguntas
                                        let perguntinha = perguntinhas !! (fst numeroDaLinha)
                                        let questao = read perguntinha :: Perguntinha

                                        if elem questao questoes then do
                                                jogo nome questoes pontos
                                                return ()
                                        
                                        else do
                                                exibeQuestao questao  
		                                tempoPergunta <- getCurrentTime
		                                let timePergunta = floor $ utctDayTime tempoPergunta :: Int
		                                resposta <- getLine
		                                if resposta == "e" then do
		                                        showDica questao
		                                        actualResposta <- getLine
		                                        tempoResposta <- getCurrentTime
		                                        let timeResposta = floor $ utctDayTime tempoResposta :: Int
		                                        let diferencaTempo = timeResposta - timePergunta
		                                        let pontos = pontos ++ [calculaPontos questao actualResposta True diferencaTempo (last pontos)]
		                                        return ()
		                                else if resposta == "f" then do
		                                        putStrLn "Você escolheu encerrar sua partida. Seu nome e ápice serão guardados no ranking e você retornará para o menu."
		                                        putStrLn $ nome ++ ", " ++ "seu ápice foi:" ++ (show (getApex pontos))
		                                        cadastraNoRanking (nome, (getApex pontos))
		                                        showMenu
		                                        return ()
		                                else if ehValida resposta then do
		                                        tempoResposta <- getCurrentTime
		                                        let timeResposta = floor $ utctDayTime tempoResposta :: Int
		                                        let diferencaTempo = timeResposta - timePergunta
		                                        let pontos = pontos ++ [calculaPontos questao resposta False diferencaTempo (last pontos)]
		                                        return ()
		                                else do 
		                                        let w = [(last pontos) - 20]
		                                        let pontos = pontos ++ w
		                                        return ()

                                                let lengthPontos = length pontos
                                                
                                                if ((pontos !! (lengthPontos - 1)) > (pontos !! (lengthPontos - 2))) then do
                                                        putStrLn $ "Você acertou! Sua pontuação atual é de " ++ (show (last pontos)) ++ " pontos. Seu ápice nesta partida é de " ++ (show (getApex pontos)) ++ "pontos."
                                                else do
                                                        putStrLn $ "Você errou! Sua pontuação atual é de " ++ (show (last pontos)) ++ " pontos. Seu ápice nesta partida é de " ++ (show (getApex pontos)) ++ "pontos."

		                                --chamada recursiva:
		                                jogo nome (questoes ++ [questao]) pontos
		                                return ()
		                                 


ehValida :: String -> Bool
ehValida resp =
        if resp == "a" || resp == "b" || resp == "c" || resp == "d"
                then True
        else False

getApex :: [Int] -> Int
getApex lista = maximum lista