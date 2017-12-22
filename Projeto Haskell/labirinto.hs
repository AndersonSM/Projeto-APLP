import System.IO

main :: IO ()
main = do
    let maze = [0,1,1,1,1,1,1,1,0,0,0,0,2,0,0,1,1,0,0,2,1,0,0,1,1,0,0,1,1,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,3,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1 ]
    let items = [13,20]
    let start = 1
    let pos = 1
    let points = 0
    game maze start pos points items

game :: [Int] -> Int -> Int -> Int -> [Int] -> IO()
game maze start pos points items = do
    show_maze maze start pos items  
    putStrLn "Digite seu comando (a,w,s,d) e aperte enter"
    c <- getLine

    putStr "\n--------\n"
    putStr "Pontos :"
    print points
    

    if (pos `elem` items) then do
        let newPoints = points + (pos * 10)        
        walk game maze start pos newPoints c (remove pos items)
    else
         walk game maze start pos points c items

walk game maze start pos points input items = do
    let tmpd = drop pos maze
    let tmp1 = head tmpd
    let tmps = drop (pos + 7) maze
    let tmp2 = head tmps
    let tmpw = drop (pos - 9) maze
    let tmp3 = head tmpw
    let tmpa = drop (pos - 2) maze
    let tmp4 = head tmpa
    
    let walkableRight = tmp1 /= 1
    let walkableDown = tmp2 /= 1
    let walkableUp= tmp3 /= 1
    let walkableLeft = tmp4 /= 1

    if input == "s" && walkableDown then do
        game maze start (pos + 8) points items
    else if input == "w" && walkableUp then 
        game maze start (pos - 8) points items
    else if input == "d" && walkableRight then 
        game maze start (pos + 1) points items
    else if input == "a" && walkableLeft then 
        game maze start (pos - 1) points items
    else
        game maze start pos points items  

show_maze :: [Int] -> Int -> Int -> [Int] -> IO()
show_maze maze counter pos items = do
    let h = head maze
    decide h pos counter items
    putStr " "
    let counter1 = counter + 1
    let maze1 = tail maze
    cr_if_mult_8 counter
    if not ( counter == 64 ) then
        show_maze maze1 counter1 pos items
    else
        putStr ""

decide :: Int -> Int -> Int -> [Int] -> IO()
decide h pos counter items = do
    if counter == pos then
        putStr "@"
    else if h == 1 then
        putStr "#"
    else if h == 2 && (counter `elem` items) then
        putStr "*"
    else if h == 3 then
        putStr "$"
    else
        putStr "."


remove element list = filter (\e -> e/=element) list        

cr_if_mult_8 :: Int -> IO()
cr_if_mult_8 c = do
    let test = mod c 8
    if test == 0 then
        putStrLn ""
    else
        putStr ""
