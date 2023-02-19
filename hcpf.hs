import System.Environment
import System.Random
import Data.Char (digitToInt, intToDigit)

-- Elementos válidos em um CPF
validos :: String
validos = ".-0123456789"

-- Verifica se os elementos da string passada batem com o de um CPF
validaSimb :: String -> Bool
validaSimb str = all (`elem` validos) str

-- Passa o CPF de '123.456.789-00' para '12345678900'
removeSimb :: String -> String
removeSimb = filter (\c -> c >= '0' && c <= '9')

-- Verifica CPFs que são válidos mas na realidade são inválidos
in'valido :: String -> Bool
in'valido str
  | str == "11111111111" = True
  | str == "22222222222" = True
  | str == "33333333333" = True
  | str == "44444444444" = True
  | str == "55555555555" = True
  | str == "66666666666" = True
  | str == "77777777777" = True
  | str == "88888888888" = True
  | str == "99999999999" = True
  | otherwise = False

{-
  Explicação do Algoritmo de validação:

  Os únicos números que verdadeiramente importam
  são os dois últimos que são usados para verificação.

  Os dois últimos digitos são cálculados em cima 9
  primeiros.
  O cálculo começa com uma máscara sendo aplicada em cima
  desses digítos:

  Máscara   : 10    9    8    7    6    5    4    3    2
	CPF       :  2    2    5    4    3    7    1    0    1
	Multiplica: 20 + 18 + 40 + 28 + 18 + 35 +  4 +  0 +  2 = Somatória

  Após aplicada pegamos este valor tiramos o módulo e subtraimos por
  11 para obtermos o primeiro digito. Ficamos então com a seguinte
  equação:

  digito1 = 11 - (somatorio1 % 11)

  No caso do segundo digito, começamos realizando o mesmo processo
  de aplicação da máscara porém os valores passam a ser [11,10..3].
  Já no caso a equação iremos utilizar o primeiro digito que iremos
  multiplicar por 2 e somar com o segundo somatório, o resto da
  equação segue o mesmo padrão da primeiro. Temos então:

  digito2 = 11 - ((somatorio2 + digito1 * 2) % 11)

  Kudos to Aurelio Jargas, Itamarnet, Lucas Souza, Henrique Moody e Marcos Barbosa.
  Se não fosse por eles este programa que estão vendo não seria possível.
  Caso tenham mais interesse deêm uma olhada no projeto original(que por sinal é muito f@#$%):
  https://github.com/funcoeszz/funcoeszz/blob/master/zz/zzcpf.sh
-}

-- Passos para verificação de CPF
verDig1Str :: String -> Int
verDig1Str str = dig1
  where
    x = map digitToInt $ take 9 $ removeSimb str
    y = sum $ zipWith (*) [10,9..2] x
    z = 11 - y `mod` 11
    dig1 = if z < 10 then z else 0

verDig2Str :: String -> Int -> Int
verDig2Str str dig1 = dig2
  where
    x =  map digitToInt $ take 9 $ removeSimb str
    y = sum $ zipWith (*) [11,10..3] x
    z = 11 - (y + dig1 * 2) `mod` 11
    dig2 = if z < 10 then z else 0


verificaCPF :: String -> String
verificaCPF str =
  if not $ validaSimb str
  then "Formato invalido!\nCPF: xxx.xxx.xxx-xx ( ͡° ͜ʖ ͡°)"
  else
    if (length (removeSimb str)) /= 11
    then "CPF deve ter 11 dígitos."
    else
      if in'valido $ removeSimb str
      then "CPF invalido."
      else
        if ((verDig1Str str) == (digitToInt ((removeSimb str) !! 9))) &&
        (verDig2Str str (verDig1Str str) == (digitToInt ((removeSimb str) !! 10)))
        then "CPF valido."
        else "CPF invalido."

-- Passos para a criação de um CPF
genNoveDigits :: IO [Int]
genNoveDigits = do
  digitos <- newStdGen
  return (take 9 (randomRs(0,9) digitos))

verDig1Int :: [Int] -> Int
verDig1Int noveDig = dig1
  where
    x = sum $ zipWith (*) [10,9..2] noveDig
    y = 11 - x `mod` 11
    dig1 = if y < 10 then y else 0

verDig2Int :: [Int] -> Int -> Int
verDig2Int noveDig dig1 = dig2
  where
    x = sum $ zipWith (*) [11,10..3] noveDig
    y = 11 - (x + dig1 * 2) `mod` 11
    dig2 = if y < 10 then y else 0

-- Tranforma lista de inteiros em lista de caracteres
listToString :: [Int] -> [Char]
listToString = map intToDigit

genCPF :: IO String
genCPF = do
  rand <- genNoveDigits
  let dig1 = verDig1Int rand
  let dig2 = verDig2Int rand dig1
  let cpfInt = rand ++ [dig1, dig2]
  let cpfStr = listToString cpfInt
  let cpf = take 3 cpfStr ++ "." ++ take 3 (drop 3 cpfStr) ++ "." ++ take 3 (drop 6 cpfStr) ++ "-" ++ show dig1 ++ show dig2
  return cpf


{-  UTILIZAÇÃO
Passando 1 argumento(o cpf) é realizado as transformações e aplicações para válida-lo.
Se nenhum argumento for passado é criado um CPF válido(nada de pedir um carnê nas Casas Bahia hein);
-}
main :: IO ()
main = do
  args <- getArgs
  if length args == 1
    then putStrLn $ verificaCPF (args!!0)
    else
    if length args == 0
    then do cpf <- genCPF
            putStrLn cpf
    else
      putStrLn "Número de argumentos é inválido"
