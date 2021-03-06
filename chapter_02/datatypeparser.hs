module Main where
import System.Environment
import Text.ParserCombinators.Parsec hiding(spaces)
import Control.Monad

main:: IO ()
main = do args <- getArgs
          putStrLn (readExpr (args !! 0))

symbol :: Parser Char
symbol = oneOf "!$%&|*+-/:<=?>@^_~#"

spaces :: Parser ()
spaces = skipMany1 space

readExpr :: String -> String
readExpr input = case parse parseExpr "lisp" input of
  Left err -> "No Match: " ++ show err
  Right val -> "Valid Value found: " ++ show val
                  
data LispVal = Atom String
             | List [LispVal]
             | DottedList [LispVal] LispVal
             | Number Integer
             | String String
             | Bool Bool
             deriving (Show)

parseString :: Parser LispVal
parseString = do char '"'
                 x <- many (noneOf "\"")
                 char '"'
                 return $ String x

parseAtom :: Parser LispVal
parseAtom = do first <- letter <|> symbol
               rest  <- many(letter <|> symbol <|> digit)
               let atom = [first] ++ rest
               return $ case atom of
                 "#t" -> Bool True
                 "#f" -> Bool False
                 otherwise -> Atom atom

parseNumber :: Parser LispVal
parseNumber = liftM (Number . read) $ many1 digit

parseExpr :: Parser LispVal
parseExpr =  parseAtom
         <|> parseString
         <|> parseNumber
