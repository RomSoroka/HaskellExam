import Test.HUnit
import Lab2

testSort1 = TestCase $ assertEqual "" ["1","2","2","3","5","6","7","9"] (batcherSort ["3","1","6","2","7","9","2","5"])

testSort2 = TestCase $ assertEqual "" ["1","2","3","3","3","4","5","5","5","5","6","6","7","8","8","9"]
                         (batcherSort ["9","5","8","4","6","5","3","2","5","8","3","6","5","7","3","1"])

testlist = TestList [TestLabel "testSort1" testSort1,
                     TestLabel "testSort2" testSort2                    
                    ]

main :: IO ()
main = do
  runTestTT testlist
  return ()
