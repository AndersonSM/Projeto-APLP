limpaTela :- write('\e[H\e[2J').


matrizVazia([	['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '*', '#'],
				['#', '-', '-', '-', '*','#', '-', '-', '-', '-','-', '-', '#', '-', '#'],
				['#', '#', '#', '#', '#','#', '-', '#', '#', '#','#', '#', '#', '#', '#'],
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

getch(1) :- 
	limpaTela.
getch(2) :- 
	limpaTela,
	halt(0).

imprimeMenu :-
	limpaTela,
	write("-------------------------------------------------"),nl,
	write("----------------------\033[1;92mMENU\033[0m-----------------------"),nl,
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
	write("-------------------------------------------------"),nl,
	write("            "),
	write("\033[1;36m [1] - JOGAR"),
	write("\033[0m || [2] - SAIR"),nl,nl,
	read_line_to_codes(user_input, X1),
	string_to_atom(X1,X2),
	atom_number(X2,N),
	getch(N).


/* Andar */

andaParaPosicao(Maze, MazeElements, RI, CI, Encontrou):-
	moveJogador(Maze, ProximoMaze),
	desenhaLabirinto(ProximoMaze),
	index(ProximoMaze,R,C,"@"), 
	index(MazeElements,R,C, Val),
	((Encontrou = "sim", RI=R, CI=C, writeln("Você ganhou!!"));

	((Val = "E"), (write(""),andaParaPosicao(ProximoMaze, MazeElements,RI,CI,"sim")));
	((Val = "S" ),writeln("\nVocê ganhouuuu2 !!!!!!"),
		andaParaPosicao(ProximoMaze, MazeElements,RI,CI,"sim"));
	((Val = "*" ),writeln("\nVocê ganhouuuu3 !!!!!!"),
		andaParaPosicao(ProximoMaze, MazeElements,R,C,"nao"));  
			
	(andaParaPosicao(ProximoMaze, MazeElements,R,C, Encontrou))).

moveJogador(Maze, ProximoMaze):-
	writeln(" "),
	writeln("\nPara andar digite: \033[1;32mCIMA:W  \033[1;33mBAIXO:S  \033[1;34mDIREITA:D  \033[1;39mESQUERDA:A \033[0m"),

	read_line_to_codes(user_input, Entrada),
    	string_to_atom(Entrada,Entrada_),
	andaNaMatriz(Entrada_,Maze, ProximoMaze).

andaNaMatriz(help,Maze, Maze):-
	imprimeMenu.

andaNaMatriz(w,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Top is (R+14) mod 15,
	index(Maze,Top,C,Val),
	 ( \+(Val \== '#') ->
    	(andaParaPosicao(Maze, Maze,R,C, "nao"));
    ( \+(Val \== 'S') ->(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Top,C, MatUpd, "@", ProximoMaze));

    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Top,C, MatUpd, "@", ProximoMaze))
    	)
 	),
	limpaTela.

andaNaMatriz(s,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Bot is (R+1) mod 15,
	index(Maze,Bot,C,Val),
	 ( \+(Val \== '#') ->
    	(andaParaPosicao(Maze, Maze,R,C, "nao"));
    ( \+(Val \== 'S') ->     (apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Bot,C, MatUpd, "@", ProximoMaze));

    	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Bot,C, MatUpd, "@", ProximoMaze))
    	)
 	),
	limpaTela.

andaNaMatriz(a,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Left is (C+14) mod 15,
	index(Maze,R,Left,Val),
	 ( \+(Val \== '#') ->
    	(andaParaPosicao(Maze, Maze,R,C, "nao"));
    ( \+(Val \== 'S') ->   (apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Left, MatUpd, "@", ProximoMaze));

	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Left, MatUpd, "@", ProximoMaze))
	)
 	),
	limpaTela.

andaNaMatriz(d,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Right is (C+1) mod 15,
	index(Maze,R,Right,Val),
	 ( \+(Val \== '#') ->
    	(andaParaPosicao(Maze, Maze,R,C, "nao"));
    ( \+(Val \== 'S') -> (apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Right, MatUpd, "@", ProximoMaze));

	(apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,Right, MatUpd, "@", ProximoMaze))
	)
 	),
	limpaTela.
% Entrada errada
andaNaMatriz(_,Maze, ProximoMaze):-
	writeln("Você digitou entrada errada. Digite novamente!"),
	moveJogador(Maze, ProximoMaze).


:- initialization main.

main:-
	imprimeMenu,
	criaMatrizComJogador(Maze),
	desenhaLabirinto(Maze),
	index(Maze,RI,CI,"@"),
	index(MazeElements,RI,CI,_),
andaParaPosicao(Maze, MazeElements, RI, CI, "nao").
