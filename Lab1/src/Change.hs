module Change
    ( insertInto, update, deleteFrom
    ) where
import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

deleteFrom::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ()
deleteFrom connection table field s_type value = do
    let str = toByteString $ "DELETE FROM " ++ table ++ " WHERE  " ++ field ++ " = ?"
    s <- prepareStmt connection (Query str)
    executeStmt connection s [toMySQLValue s_type value]
    execute_ connection "commit"
    putStr ""

update::MySQLConn->[Char]->MySQLValue->[Char]->[Char]->[Char]->IO ()
update connection table id field s_type value  = do
    let str = toByteString $ "UPDATE " ++ table ++ " SET " ++ field ++ " = ? where id = ?"
    s <- prepareStmt connection (Query str)
    executeStmt connection s [toMySQLValue s_type value, id]
    execute_ connection "commit"
    putStr ""


correspondType::[[Char]]->[[Char]]->[MySQLValue]
correspondType [] _ = []
correspondType _ [] = []
correspondType (t:s_types) (v:values) = toMySQLValue t v : correspondType s_types values

getFieldAndTypes::MySQLConn->[Char]->[[Char]]->IO ([[Char]],[MySQLValue])
getFieldAndTypes connection table values = do
    let str = toByteString $ "SHOW COLUMNS FROM " ++ table
    (defs, is) <- query_ connection (Query str)
    data1 <- Streams.toList is
    let fields = map (transform . head) (tail data1)
    let s_types = map (\x-> transform $ x !! 1) (tail data1)
    let types = correspondType s_types values
    return (fields, types)

insertInto connection table values = do
    vals <- getFieldAndTypes connection table values
    let fields = fst vals
    let types = snd vals
    let substitute = intercalate ", " (replicate (length fields) "?")
    let fields_str = intercalate ", " fields
    let str = toByteString $ "insert into " ++ table ++ " (" ++ fields_str ++ ") VALUES (" ++ substitute ++ ")"
    s <- prepareStmt connection (Query str)
    executeStmt  connection s types
    execute_ connection "commit"
    putStr ""
