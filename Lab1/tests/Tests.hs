module Tests where

import Test.HUnit
import Change
import Select
import Database.MySQL.Base

testSelect:: Test
testSelect = TestCase (do 
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_sport"}
    (cols, res) <- __select connection "students" "name" "varchar" "Joseph"
    assertBool "Result should not be empty" ((length res) > 0)
    assertEqual "Surname incorrect" (MySQLText "Halil") ((res !! 0) !! 3)
    close connection)

testInsert = TestCase (do 
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_sport"}
    deleteFrom connection "teachers" "name" "varchar" "Roman"
    insertInto connection "teachers" ["Roman","Notsoroka","22"]
    (cols, res) <- __select connection "teachers" "name" "varchar" "Roman"
    assertBool "Result should not be empty" ((length res) > 0)
    assertEqual "Name is correct" (MySQLText "Roman") ((res !! 0) !! 1)
    deleteFrom connection "teachers" "name" "varchar" "Roman"
    close connection)

testDelete = TestCase (do
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_sport"}
    insertInto connection "teachers" ["Petia","Petrov","40"]
    deleteFrom connection "teachers" "name" "varchar" "Petia"
    (cols, res) <- __select connection "teachers" "name" "varchar" "Petia"
    assertBool "Result is empty" ((length res) == 0)
    close connection)

testUpdate = TestCase (do
    connection <- connect defaultConnectInfo {ciUser = "root", ciPassword = "root", ciDatabase = "faculty_sport"}
    deleteFrom connection "teachers" "name" "varchar" "Roman"
    insertInto connection "teachers" ["Roman","Soroka","10"]
    (cols, res) <- __select connection "teachers" "name" "varchar" "Roman"
    let id = (res !! 0) !! 0
    let str_id = show (case id of  MySQLInt32 x -> x)
    update connection "teachers" id "name" "varchar" "NewRoman"
    (cols, res) <- __select connection "teachers" "id" "int" str_id
    assertBool "Result should not be empty" ((length res) > 0)
    assertEqual "Release info is correct" (MySQLText "NewRoman") ((res !! 0) !! 1)
    close connection)

main :: IO ()
main =  do
    runTestTT testSelect
    runTestTT testInsert
    runTestTT testDelete
    runTestTT testUpdate
    return ()