import Lab2
import System.Environment

main = do
    args <- getArgs
    content <- readLines(head(args))
    putStrLn "Input:"
    print(content)
    putStrLn "Output:"
    print(batcherSort content)