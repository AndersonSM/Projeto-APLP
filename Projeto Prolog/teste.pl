limpaTela :- write('\e[H\e[2J').


matrizVazia([	['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '*', '#'],
				['#', '-', '-', '-', '*','#', '-', '-', '-', '-','-', '-', '#', '-', '#'],
				['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'],
				['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '*', '#'],
				['#', '-', '-', '-', '-','#', '-', '-', '-', '-','*', '-', '#', '-', '#'],
				['#', '#', '#', '#', '#','#', '-', '#', '#', '#','#', '#', '#', '#', '#'],
				['#', '*', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
				['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', 'S'],
				['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#']]).

matrizSegundaFase([ ['#', '-', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'], 
					['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '*', '#'],
					['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'],
					['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '*', '#', '#', '#'], 
					['#', '-', '-', '-', '-','-', '#', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '-','#', '#', '-', '-', '-','-', '-', '#', '-', '#'],
					['#', '#', '#', '#', '#','#', '-', '#', '#', '#','#', '#', '#', '#', '#'],
					['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
					['#', '-', '-', '-', '*','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '*','#', '-', '-', '-', '-','*', '-', '#', '-', 'E'],
					['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#']]).

%imprimir linha
imprimeLinha([]).
imprimeLinha([H|T]) :- write(H), write(' '), imprimeLinha(T).

%imprime matriz
desenhaLabirinto([]).
desenhaLabirinto([H|T]) :- 
	imprimeLinha(H), writeln(''), 	
	desenhaLabirinto(T).

% pegar elemento do index (Row, Col)
index(Matrix, Row, Col, Value):-
  nth0(Row, Matrix, MatrixRow),
  nth0(Col, MatrixRow, Value).

%Trocar valor da matrz Mat, nas coordenadas (R,C), pelo valor Val
apagaPosicaoEAnda(R, C, Mat, Val, Upd) :-
    nth0(R, Mat, OldRow, RestRows),   % get the row and the rest
    nth0(C, OldRow, _Val, NewRow),    % we dont care the _Val deleted
    nth0(C, NewRowUpd,Val,NewRow),		% insert Val into C, where _val was
    nth0(R, Upd, NewRowUpd, RestRows).   % insert updated row in rest, get Upd matrix


verificaEAdd(R, C, MatrizAntes, E, MatrizUpd):-
	index(MatrizAntes, R, C, Val), % val é o valor da MatrizAntes[R,C].
	
 	((    (Val = "#"), 
		apagaPosicaoEAnda(R,C,MatrizAntes,"#", MatrizUpd));

	(     (Val \= "#"), 
		apagaPosicaoEAnda(R,C,MatrizAntes,E, MatrizUpd))).

/* Gera Matriz Jogador */

criaMatrizComJogador(Maze):-
	matrizVazia(MatrizInicial),  
	verificaEAdd(0,1,MatrizInicial,"@", Maze).% coloca o jogador na posicao [0,1]

/* Imprime Menu */

imprimeMenu :- 
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	write("----- _       _    _       _       _        -----"),nl,
	write("-----| | ___ | |_ |_| ___ |_| ___ | |_  ___ -----"),nl,
	write("-----| || .'|| . || ||  _|| ||   ||  _|| . |-----"),nl,
	write("-----|_||__,||___||_||_|  |_||_|_||_|  |___|-----"),nl,
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	write("-------------------------------------------------"),nl,
	writeln("-------------------------------------------------").

/* Iniciar matriz */

geraMatrizElemento(MazeElements):-
	matrizVazia(MatrizInicial).

/* Andar */

andaParaPosicao(Maze, MazeElements, RI, CI, Encontrou):-
	moveJogador(Maze, ProximoMaze),
	desenhaLabirinto(ProximoMaze),
	index(ProximoMaze,R,C,"@"), 
	index(MazeElements,R,C, Val),
	
	((Encontrou = "sim", RI=R, CI=C, writeln("Você ganhou!!"));

	((Val = "-"), (andaParaPosicao(ProximoMaze, MazeElements,RI,CI,Encontrou)));
	((Val = "S" ),writeln("\nVocê ganhouuuu2 !!!!!!"),
		andaParaPosicao(ProximoMaze, MazeElements,RI,CI,"sim")); 
			
	(andaParaPosicao(ProximoMaze, MazeElements,RI,CI, Encontrou))).

moveJogador(Maze, ProximoMaze):-
	writeln(" "),
	writeln("\n Para andar digite: up: cima, down: baixo, right: direita, left: esquerda. "),

	read_line_to_codes(user_input, Entrada),
    string_to_atom(Entrada,Entrada_),
    andaNaMatriz(Entrada_,Maze, ProximoMaze).

andaNaMatriz(help,Maze, Maze):-
	imprimeMenu.

andaNaMatriz(w,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Top is (R+14) mod 15,
	index(Maze,Top,C,Val),
    writeln(Val),
    writeln(R),
    writeln(C),
    writeln(Top),
	 ( \+(Val \== '-') ->
    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Top,C, MatUpd, "@", ProximoMaze));
    ( \+(Val \== '*') ->(write("VAL = *"),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Top,C, MatUpd, "@", ProximoMaze));

    	(write("VAL = OTHERS"),apagaPosicaoEAnda(R,C, Maze, "@", ProximoMaze))
    	)
 	).

andaNaMatriz(x,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Bot is (R+1) mod 15,
	index(Maze,Bot,C,Val),
    writeln(Val),
    writeln(R),
    writeln(C),
    writeln(Bot),
	 ( \+(Val \== '-') ->
    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Bot,C, MatUpd, "@", ProximoMaze));
    ( \+(Val \== '*') ->     (write("VAL = *"),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Bot,C, MatUpd, "@", ProximoMaze));

    	(write("VAL = OTHERS"),apagaPosicaoEAnda(R,C, Maze, "@", ProximoMaze))
    	)
 	).

andaNaMatriz(a,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Left is (C+14) mod 15,
	index(Maze,R,Left,Val),
    writeln(Val),
    writeln(R),
    writeln(C),
    writeln(Left),
	 ( \+(Val \== '-') ->
    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Left, MatUpd, "@", ProximoMaze));
    ( \+(Val \== '*') ->   (write("VAL = *"),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Left, MatUpd, "@", ProximoMaze));

	(write("VAL = OTHERS"),apagaPosicaoEAnda(R,C, Maze, "@", ProximoMaze))
	)
 	).

andaNaMatriz(d,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Right is (C+1) mod 15,
	writeln(Right),
	index(Maze,R,Right,Val),
    writeln(Val),
    writeln(R),
    writeln(C),
    writeln(Right),
	 ( \+(Val \== '-') ->
    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Right, MatUpd, "@", ProximoMaze));
    ( \+(Val \== '*') -> (write("VAL = *"),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Right, MatUpd, "@", ProximoMaze));

	(write("VAL = OTHERS"),apagaPosicaoEAnda(R,C, Maze, "@", ProximoMaze))
	)
 	).

% Entrada errada
andaNaMatriz(Entrada,Maze, ProximoMaze):-
	writeln("Você digitou entrada errada. Digite novamente"),
	moveJogador(Maze, ProximoMaze).


:- initialization main.

main:-
	imprimeMenu,
	criaMatrizComJogador(Maze),
	desenhaLabirinto(Maze),
	index(Maze,RI,CI,"@"),
	index(MazeElements,RI,CI,Val),
	andaParaPosicao(Maze, MazeElements, RI, CI, "nao").
