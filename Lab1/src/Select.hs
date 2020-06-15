module Select
    ( select, showAll, __select
    ) where

import Utils
import qualified System.IO.Streams as Streams
import Database.MySQL.Base
import Data.List

showAll connection table = do
    let str =  toByteString ("SELECT * FROM " ++ table)
    columns <- getTableColumns connection table
    (defs, is) <- query_ connection (Query str)
    values <- Streams.toList is
    printResultSet columns values

__select::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ([[Char]],[[MySQLValue]])
__select connection table field s_type value = do
    let str = toByteString $ "SELECT * FROM " ++ table ++ " WHERE  " ++ field ++ " = ?"
    s <- prepareStmt connection (Query str)
    (defs, is) <- queryStmt connection s [toMySQLValue s_type value]
    values <- Streams.toList is
    columns <- getTableColumns connection table
    return (columns, values)

select::MySQLConn->[Char]->[Char]->[Char]->[Char]->IO ()
select connection table field s_type value = do
    (columns, values)<- __select connection table field s_type value
    printResultSet columns values
    