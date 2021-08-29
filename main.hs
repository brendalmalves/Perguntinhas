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
    enunciadoAlternativaCorreta :: String} deriving (Read, Show)


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
        putStrLn "2 - Sim"

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
        putStrLn "2 - Retornar para o menu"

        opcao <- getLine
        opcaoJogador opcao

opcaoJogador :: String -> IO()
opcaoJogador x
--      | x == "1" = jogo --ainda nao sei qual vai ser o nome dessa funcao entao da pra alterar depois
        | x == "2" = showMenu
        | otherwise = invalidOption menuJogador

menuAdministrador :: IO()
menuAdministrador = do
        putStrLn "\nSelecione uma das opções abaixo:"
        putStrLn "1 - Já tenho cadastro (fazer login)"
        putStrLn "2 - Não tenho cadastro (criar conta)"
        putStrLn "3 - Retornar para o menu"

        opcao <- getLine
        opcaoAdministrador opcao

segundoMenuAdministrador :: IO()
segundoMenuAdministrador = do
        putStrLn "\nEscolha o que você deseja fazer:"
        putStrLn "1 - Cadastrar uma nova Perguntinha"
        putStrLn "2 - Modificar ranking"
        putStrLn "3 - Excluir minha conta"
        putStrLn "4 - Retornar para o menu"
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
        putStrLn "3 - Retornar para o menu"
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
        putStrLn "Insira a alternativa A da Perguntinha:"
        alternativaA <- getLine
        putStrLn "Insira a alternativa B da Perguntinha:"
        alternativaB <- getLine
        putStrLn "Insira a alternativa C da Perguntinha:"
        alternativaC <- getLine
        putStrLn "Insira a alternativa D da Perguntinha:"
        alternativaD <- getLine
        putStrLn "Insira a dica da Perguntinha:"
        dica <- getLine
        putStrLn "Insira a alternativa correta da Perguntinha. Digite um caractere de 'a' a 'd', apenas o caractere:"
        alternativaCorreta <- getLine --seria bom ter um loop (recusao) ate o usuario digitar uma alternativa valida
        let lowerAlt = map toLower alternativaCorreta

        let perguntinha = Perguntinha pergunta alternativaA alternativaB alternativaC alternativaD dica lowerAlt

        perguntasCadastradas <- doesFileExist "perguntinhas.txt"
        if not perguntasCadastradas then do
                file <- openFile "perguntinhas.txt" WriteMode
                hPutStr file (show perguntinha)
                hFlush file
                hClose file
        else appendFile "perguntinhas.txt" ("\n" ++ show perguntinha)

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
        rankingExiste <- doesFileExist "ranking.txt"
        if not rankingExiste then do
                file <- openFile "ranking.txt" WriteMode
                hPutStr file (formataTuplaArquivo tupla ++ "\n")
                hFlush file
                hClose file
        else appendFile "ranking.txt" (formataTuplaArquivo tupla ++ "\n")

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
                                                 "Jogador    | Pontuação\n" ++
                         "-----------------------\n" ++
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
        | x < 10 = replicate (10 - x) " "
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

{-
--esboço/pseudocodigo do metodo de jogo
--recebe como primeiro parametro uma lista de Perguntinha das questoes que ja foram selecionadas anteriormente
--recebe como segundo parametro uma lista de inteiros correspondente as pontuacoes do jogador numa partida
jogo :: String -> [Perguntinha] -> [Int] -> IO()
jogo nome questoes pontos
                | (last pontos) < 0 = do
                        putStrLn $ "Sua pontuação foi menor que zero. Sua partida será encerrada, mas seu nome e seu ápice serão guardados no ranking."
                        cadastraNoRanking (nome, (getApex pontos))
                        showMenu
                | otherwise = do
                        -- randomQuestao eh o metodo que escolhe aleatoriamente uma questao para ser respondida
                        -- a eh o parametro do metodo. certamente deve ser o arquivo em que as questoes estao salvas
                        existePerguntas <- doesFileExist "perguntinhas.txt"
                        if not existePerguntas then do
                                putStrLn $ "Ainda não há questões cadastradas no sistema."
                                menu
                        else do
                                perguntas <- readFile "perguntinhas.txt"
                                let quantidadePerguntas = length (lines perguntas)
                                if quantidadePerguntas == (length questoes) then do
                                        putStrLn "Todas as perguntas já foram respondidas. Seu nome e ápice serão guardados no ranking e o jogo será encerrado."
                                        cadastraNoRanking (nome, (getApex pontos))
                                        showMenu
                                geradorAleatorio <- newStdGen
                                let numeroDaLinha = randomR (1, quantidadePerguntas) geradorAleatorio
                                let questao = getQuestao numeroDaLinha -- getQuestao recebe um inteiro correspondente à linha em que a pergunta esta armazenada em perguntinhas.txt e retorna um Perguntinha
                                if questao elem questoes then
                                        jogo nome questoes pontos
                                exibeQuestao questao -- recebe um Perguntinha como parâmetro e exibe a pergunta, as alternativas e outras duas alternativas extras: alternativa 'e)', que exibe uma dica e alternativa 'f)' que encerra o jogo
                                tempoPergunta <- getCurrentTime
                                let timePergunta = floor $ utctDayTime tempoPergunta :: Int
                                resposta <- getLine
                                if resposta == "e" then do
                                        showDica questao
                                        actualResposta <- getLine
                                        tempoResposta <- getCurrentTime
                                        let timeResposta = floor $ utctDayTime tempoResposta :: Int
                                        let diferencaTempo = timeResposta - timePergunta
                                        pontos ++ [calculaPontos questao True diferencaTempo (last pontos)]
                                else if resposta == "f" then do
                                        putStrLn "Você escolheu encerrar sua partida. Seu nome e ápice serão guardados no ranking e você retornará para o menu."
                                        cadastraNoRanking (nome, (getApex pontos))
                                        showMenu
                                else if ehValida resposta then
                                        pontos ++ [calculaPontos questao False diferencaTempo (last pontos)]
                                else pontos ++ [(last pontos) - 20]
                                --chamada recursiva:
                                jogo nome (questoes ++ [questao]) pontos

ehValida :: Char -> Bool
ehValida resp =
        if resp == 'a' || resp == 'b' || resp == 'c' || resp == 'd'
                then True
        else False

getApex :: [Int] -> Int
getApex lista = maximum lista
-}