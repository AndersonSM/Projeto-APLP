import System.IO
import System.Console.ANSI
import Control.Concurrent
import Control.Concurrent.STM

printLabel :: IO ()
printLabel = do
    putStrLn " _       _    _       _       _        "
    putStrLn "| | ___ | |_ |_| ___ |_| ___ | |_  ___ "
    putStrLn "| || .'|| . || ||  _|| ||   ||  _|| . |"
    putStrLn "|_||__,||___||_||_|  |_||_|_||_|  |___|"
    putStrLn "---------------------------------------"
    putStrLn " _       _    _       _       _        "
    putStrLn "| | ___ | |_ |_| ___ |_| ___ | |_  ___ "
    putStrLn "| || .'|| . || ||  _|| ||   ||  _|| . |"
    putStrLn "|_||__,||___||_||_|  |_||_|_||_|  |___|"
    putStrLn "---------------------------------------"
    putStrLn " _       _    _       _       _        "
    putStrLn "| | ___ | |_ |_| ___ |_| ___ | |_  ___ "
    putStrLn "| || .'|| . || ||  _|| ||   ||  _|| . |"
    putStrLn "|_||__,||___||_||_|  |_||_|_||_|  |___|"
    putStrLn "---------------------------------------" 

limpaTela :: IO ()
limpaTela = do
    clearScreen
    setCursorPosition 0 0

drawPlayer :: IO ()
drawPlayer = do
    setSGR [SetConsoleIntensity BoldIntensity]
    setSGR [SetColor Foreground Vivid Blue]
    putStr "@"
    setSGR [Reset]

drawBonus :: IO ()
drawBonus = do
    setSGR [SetConsoleIntensity BoldIntensity]
    setSGR [SetColor Foreground Vivid Red]   
    putStr "*"
    setSGR [Reset] 

main :: IO ()
main = do
    setTitle "O Labirinto"
    printLabel
    threadDelay  2000000 
    limpaTela
    let maze1 = [0,1,1,1,1,1,1,1
                ,0,0,0,1,2,1,2,1
                ,1,0,1,2,1,0,0,1
                ,1,0,0,0,1,0,0,1
                ,1,0,1,1,1,0,0,1
                ,1,0,0,0,1,2,0,3
                ,1,0,1,0,0,0,0,1
                ,1,1,1,1,1,1,1,1 ]
    let items1 = [15,13,46,20]

    let maze2 = [0,1,1,1,0,1,1,1
                ,0,0,0,0,1,1,0,1
                ,1,0,0,1,2,1,0,3
                ,1,0,1,1,0,1,0,1
                ,1,0,0,0,0,0,2,1
                ,1,0,1,0,1,1,0,1
                ,0,1,1,1,2,0,0,1
                ,1,0,0,0,1,1,1,0 ]
    let items2 = [21,53]

    
    let mazes = [(maze1,items1),(maze2,items2)]
    let start = 1
    let pos = 1
    let points = 0
    game mazes maze1 start pos points items1

game :: [([Int],[Int])] -> [Int] -> Int -> Int -> Int -> [Int] -> IO()
game mazes maze start pos points items = do

    if start < 0 then do
        putStr "\n\n---JOGO FINALIZADO----\n\n"
        putStr "Pontos :"
        print points
        
    else do
        show_maze maze start pos items  

        putStr "\n--------\n"
        putStr "Pontos :"
        print points
        putStr "--------\n"
        putStrLn "Digite seu comando (a,w,s,d) e aperte enter"
        c <- getLine
        
        limpaTela
        

        if (pos `elem` items) then do
            let newPoints = points + (pos * 10)        
            walk game mazes maze start pos newPoints c (remove pos items)
        else
            walk game mazes maze start pos points c items

walk game mazes maze start pos points input items = do
    let tmpd = drop pos maze
    let tmp1 = head tmpd
    let tmps = drop (pos + 7) maze
    let tmp2 = head tmps
    let tmpw = drop (pos - 9) maze
    let tmp3 = head tmpw
    let tmpa = drop (pos - 2) maze
    let tmp4 = head tmpa
    
    let walkableRight = tmp1 /= 1 && mod pos 8 /= 0
    let walkableDown = tmp2 /= 1 && ((pos + 8) < 64)
    let walkableUp= tmp3 /= 1 && pos > 8
    let walkableLeft = tmp4 /= 1 && pos > 0

    if input == "s" && walkableDown then do
        let newPos = pos + 8
        let newMaze = maze
        let newMazes = mazes
        let newStart = start
        let newItems = items
        if ( maze !! newPos - 1 == 3) then do
            let newMazes = tail mazes 
            let newMaze = fst (head newMazes)
            let newPos = 1
            let newStart = 1
            let newItems = snd (head newMazes)
            putStr "\n\n--PASSOU DE FASE--\n\n"
            limpaTela
            threadDelay  1200000     
            if (length newMazes == 0) then do
                let newStart = -1
                game newMazes newMaze newStart newPos points newItems  
            else
                 game newMazes newMaze newStart newPos points newItems
            
        else
            game newMazes newMaze newStart newPos points newItems
    else if input == "w" && walkableUp then do
        let newPos = pos - 8
        let newMaze = maze
        let newMazes = mazes
        let newStart = start
        let newItems = items
        if ( maze !! newPos - 1 == 3) then do
            let newMazes = tail mazes 
            let newMaze = fst (head newMazes)
            let newPos = 1
            let newStart = 1
            let newItems = snd (head newMazes)
            putStr "\n\n--PASSOU DE FASE--\n\n"
            limpaTela
            threadDelay  1200000     
            if (length newMazes == 0) then do
                let newStart = -1
                game newMazes newMaze newStart newPos points newItems  
            else
                 game newMazes newMaze newStart newPos points newItems        
            
        else
            game newMazes newMaze newStart newPos points newItems

    else if input == "d" && walkableRight then do
        let newPos = pos + 1
        let newMaze = maze
        let newMazes = mazes
        let newStart = start
        let newItems = items
        if ( maze !! (newPos - 1) == 3) then do
            let newMazes = tail mazes 
            let newMaze = fst (head newMazes)
            let newPos = 1
            let newStart = 1
            let newItems = snd (head newMazes)
            putStr "\n\n--PASSOU DE FASE--\n\n"
            limpaTela
            threadDelay  1200000     
            if (length newMazes == 0) then do
                let newStart = -1
                game newMazes newMaze newStart newPos points newItems  
            else
                 game newMazes newMaze newStart newPos points newItems     
            
        else
            game newMazes newMaze newStart newPos points newItems
    else if input == "a" && walkableLeft then do
        let newPos = pos - 1
        let newMaze = maze
        let newMazes = mazes
        let newStart = start
        let newItems = items
        if ( maze !! newPos == 3) then do
            let newMazes = tail mazes 
            let newMaze = fst (head newMazes)
            let newPos = 1
            let newStart = 1
            let newItems = snd (head newMazes)
            putStr "\n\n--PASSOU DE FASE--\n\n"
            limpaTela
            threadDelay  1200000     
            if (length newMazes == 0) then do
                let newStart = -1
                game newMazes newMaze newStart newPos points newItems  
            else
                 game newMazes newMaze newStart newPos points newItems
                    
            
        else
            game newMazes newMaze newStart newPos points newItems
    else
        game mazes maze start pos points items  

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
        drawPlayer
    else if h == 1 then
        putStr "#"
    else if h == 2 && (counter `elem` items) then
        drawBonus
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
