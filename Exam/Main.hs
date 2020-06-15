--task1
data BinTree a = LeafNode a | BranchNode a (BinTree a) (BinTree a) deriving Show

listOfEven :: Integral a => BinTree a -> [a]
listOfEven tree = filter even $ listTree tree
  where listTree :: BinTree a -> [a]
        listTree (LeafNode x) = [x]
        listTree (BranchNode x l r) = (listTree l) ++ [x] ++ (listTree r)

--task2
increasingSum :: Num a => [a] -> [a]
increasingSum xs = map f [1..]
  where f n = sum $ take n xs

main :: IO ()
main = do
  print $ take 7 $ increasingSum [2 ..]

  let tree = BranchNode 20 (BranchNode 9 (LeafNode 5) (LeafNode 14)) (LeafNode 24)
  print $ listOfEven tree