module Main where
import System.Environment
import Text.ParserCombinators.Parsec hiding(spaces)

main:: IO ()
main = do args <- getArgs
          putStrLn (readExpr (args !! 0))

symbol :: Parser Char
symbol = oneOf "!$%&|*+-/:<=?>@^_~#"

spaces :: Parser ()
spaces = skipMany1 space

readExpr :: String -> String
readExpr input = case parse (spaces >> symbol) "lisp" input of
  Left err -> "No Match: " ++ show err
  Right val -> "Valid Value found: " ++ show val
                  