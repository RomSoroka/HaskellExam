module Main where
import Database.MySQL.Base
import Change
import Select
import Utils
import Data.Int

printList::[[Char]]->IO()
printList x = mapM_ (\(a,b) -> do
    putStr (show a)
    putStrLn $ ". "++b) (zip [1..] x)

getInt::Int->Int->IO Int
getInt min max = do
    putStrLn $"Number from " ++ show min ++ " to " ++ show max
    str <- getLine
    let a = read str::Int
    if a >= min && a <= max then return a
    else
        do
            putStrLn "Choose wisely, dear"
            getInt min max

consoleInterfaceTableAction::MySQLConn->[Char]->IO ()
consoleInterfaceTableAction conn table = do
    putStrLn $ table
    putStrLn "\
    \1. View table\n\
    \2. Add to the table\n\
    \3. Change row of the table\n\
    \4. Delete rows from the table\n\
    \5. Show rows\n\
    \6. Go back"
    i <- getInt 1 6
    if (i == 1)
        then do
            showAll conn table
            consoleInterfaceTableAction conn table
    else if i == 2
        then do
            val <- getTableColumns conn table
            let columns = tail val
            values <- mapM (\name->do
                putStrLn ("Value for '"++name++"' field")
                getLine) columns
            insertInto conn table values
            consoleInterfaceTableAction conn table
    else if i == 3
        then do
            putStrLn "ID of the value:"
            id_s <- getLine
            let id = MySQLInt32 (read id_s::Int32)
            putStrLn "Choose column to update:"
            cols <- getTableColumns conn table
            printList cols
            index <- getInt 1 (length cols)
            let field = cols !! (index - 1)
            putStrLn "Value for the field:"
            value <- getLine
            types <- getTableTypes conn table
            let type_s = types !! (index - 1)
            update conn table id field type_s value
            consoleInterfaceTableAction conn table
    else if i == 4 || i == 5
        then do
            putStrLn "Choose field:"
            cols <- getTableColumns conn table
            printList cols
            index <- getInt 1 (length cols)
            let field = cols !! (index - 1)
            putStrLn "Value for the field:"
            value <- getLine
            types <- getTableTypes conn table
            let type_s = types !! (index - 1)
            if i == 4 then
                deleteFrom conn table field type_s value
            else
                select conn table field type_s value
            consoleInterfaceTableAction conn table

    else consoleInterfaceStart conn


consoleInterfaceStart conn = do
    tables <- getAllTables conn
    putStrLn "Choose table: "
    printList tables
    a <- getInt 1 ((length tables)+1)
    if a == (length tables) + 1 then return ()
    else consoleInterfaceTableAction conn (tables !! (a - 1))


main :: IO ()
main =  do
    conn <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_sport"}
    consoleInterfaceStart conn
    close conn
