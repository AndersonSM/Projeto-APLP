import System.IO
import System.Console.ANSI

limpaTela :: IO ()
limpaTela = do
    clearScreen

game :: [Int] -> Int -> Int -> IO()
game maze start pos = do
    show_maze maze start pos    
    putStrLn "Digite seu comando (a,w,s,d) e aperte enter"
    c <- getLine
    putStr "\n--------\n"
    limpaTela
    let newpos = pos + 1
    let tmp = drop pos maze
    let tmp1 = head tmp
    walk game maze start pos c

walk game maze start pos input = do
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
        game maze start (pos + 8)
    else if input == "w" && walkableUp then 
        game maze start (pos - 8)
    else if input == "d" && walkableRight then 
        game maze start (pos + 1)
    else if input == "a" && walkableLeft then 
        game maze start (pos - 1)
    else
        game maze start pos

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

show_maze :: [Int] -> Int -> Int -> IO()
show_maze maze counter pos = do
    let h = head maze
    decide h pos counter
    putStr " "
    let counter1 = counter + 1
    let maze1 = tail maze
    cr_if_mult_8 counter
    if not ( counter == 64 ) then
        show_maze maze1 counter1 pos
    else
        putStr ""

decide :: Int -> Int -> Int -> IO()
decide h pos counter = do
    if counter == pos then
        drawPlayer
    else if h == 0 then
        putStr "."
    else if h == 2 then
        drawBonus
    else if h == 3 then
        putStr "$"
    else
        putStr "#"

cr_if_mult_8 :: Int -> IO()
cr_if_mult_8 c = do
    let test = mod c 8
    if test == 0 then
        putStrLn ""
    else
        putStr ""

main :: IO ()
main = do
    let maze = [0,1,1,1,1,1,1,1,
                0,0,0,0,0,0,0,1,
                1,0,1,1,0,1,0,1,
                1,0,1,0,0,1,2,1,
                1,0,1,2,1,1,1,1,
                1,0,1,1,1,0,0,3,
                1,0,0,0,0,0,1,1,
                1,1,1,1,1,1,1,1]
    
    let maze2 = [0,1,1,1,1,1,1,1,
                0,0,0,0,0,0,0,1,
                1,0,0,0,2,0,0,1,
                1,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,3,
                1,0,0,0,0,0,0,1,
                1,1,1,1,1,1,1,1]
    
    let maze3 = [0,1,1,1,1,1,1,1,
                0,0,0,0,0,0,0,1,
                1,0,0,0,2,0,0,1,
                1,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,1,
                1,0,0,0,0,0,0,3,
                1,0,0,0,0,0,0,1,
                1,1,1,1,1,1,1,1]

    let start = 1
    let pos = 1
    game maze start pos
