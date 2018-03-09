limpaTela :- write('\e[H\e[2J').

matrizVazia([	['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
				['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', '#'],
				['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'],
				['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
				['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', '#'],
				['#', '#', '#', '#', '#','#', '-', '#', '#', '#','#', '#', '#', '#', '#'],
				['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
				['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
				['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
				['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', 'S'],
				['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#']]).

matrizSegundaFase([ ['#', '-', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'], 
					['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', '#'],
					['#', '#', '#', '#', '#','#', '#', '#', '#', '#','#', '#', '#', '#', '#'],
					['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
					['#', '-', '-', '-', '-','-', '#', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '-','#', '#', '-', '-', '-','-', '-', '#', '-', '#'],
					['#', '#', '#', '#', '#','#', '-', '#', '#', '#','#', '#', '#', '#', '#'],
					['#', '-', '#', '#', '#','#', '-', '#', '#', '#','#', '-', '#', '#', '#'], 
					['#', '-', '-', '-', '-','-', '-', '-', '-', '#','#', '-', '-', '-', '#'], 
					['#', '-', '-', '-', '#','#', '-', '#', '-', '#','#', '-', '#', '-', '#'],
					['#', '-', '-', '-', '-','#', '-', '-', '-', '-','-', '-', '#', '-', 'S'],
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
	writeln("APAGANDO"),
    nth0(R, Mat, OldRow, RestRows),   % get the row and the rest
    nth0(C, OldRow, _Val, NewRow),    % we dont care the _Val deleted
    nth0(C, NewRowUpd,Val,NewRow),		% insert Val into C, where _val was
    nth0(R, Upd, NewRowUpd, RestRows).   % insert updated row in rest, get Upd matrix


verificaEAdd(R, C, MatrizAntes, E, MatrizUpd):-
	index(MatrizAntes, R, C, Val), % val é o valor da MatrizAntes[R,C].
	
	% caso val seja igual a "#" -> MatrizUpd == MatrizAntes
 	((    (Val = "#"), 
		apagaPosicaoEAnda(R,C,MatrizAntes,"#", MatrizUpd));

 	% caso val seja DIFERENTE a "#" -> MatrizUpd sera atualizada com valor de E
	(     (Val \= "#"), 
		apagaPosicaoEAnda(R,C,MatrizAntes,E, MatrizUpd))).

/* Gera Matriz Jogador */

criaMatrizComJogador(Maze):-
	matrizVazia(MatrizInicial),  %pega matriz vazia
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
	index(ProximoMaze,R,C,"@"),                  % pegar nova Coordenada Jogador
	index(MazeElements,R,C, Val),				% valor da matriz de elementos.
	
	((Encontrou = "sim", RI=R, CI=C, writeln("Você ganhou!!"));

	((Val = "-"), (andaParaPosicao(ProximoMaze, MazeElements,RI,CI,Encontrou)));
	((Val = "S" ),writeln("\nVocê ganhouuuu2 !!!!!!"),
		andaParaPosicao(ProximoMaze, MazeElements,RI,CI,"sim"));                    % elseifcaso Val for S ganha
			
	(andaParaPosicao(ProximoMaze, MazeElements,RI,CI, Encontrou))). 							% else loop,

moveJogador(Maze, ProximoMaze):-
	writeln(" "),
	writeln("\n Para andar digite: up: cima, down: baixo, right: direita, left: esquerda. "),

	read_line_to_codes(user_input, Entrada),
    string_to_atom(Entrada,Entrada_),
    andaNaMatriz(Entrada_,Maze, ProximoMaze).

andaNaMatriz(help,Maze, Maze):-
	imprimeMenu.

andaNaMatriz(up,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),                    			% pegar linha e coluna do Jogador
	Top is (R+14) mod 15,                              			% proxima pos do jogador
	apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),			% apagando pos anterior
	apagaPosicaoEAnda(Top,C, MatUpd, "@", ProximoMaze).

andaNaMatriz(down,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),
	Bot is (R+1) mod 15,
	index(Maze,Bot,C,Val),
	 ( \+(Val \== '-') ->
    	(writeln('entrou -'),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(Bot,C, MatUpd, "@", ProximoMaze),writeln('PATH END'));
    ( \+(Val = '#') ->
        writeln('A is 3');
    	(writeln('entrou #'),apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),
		apagaPosicaoEAnda(R,C, MatUpd, "@", ProximoMaze),writeln('PATH END'))
    	)
 	).


canWalk("#",Maze,Maze2,R,C).
		
canWalk("-",Maze,Maze2,R,C):-
	apagaPosicaoEAnda(R,C, Maze, "-", Maze2), apagaPosicaoEAnda(Bot,C, Maze, "@", Maze2).

canWalk("S",Maze,Maze2,R,C):-
	andaParaPosicao(Maze, Maze2,R,C,"nao"). # MUDA DE FASE

canWalk("E",Maze,Maze2,R,C):-
	andaParaPosicao(Maze, Maze2,R,C,"sim").


andaNaMatriz(left,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),                             % pegar linha e coluna do Jogador
	Left is (C+14) mod 15,                                       % proxima pos do jogador
	apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),         % apagando pos anterior
	apagaPosicaoEAnda(R,Left, MatUpd, "@", ProximoMaze).

andaNaMatriz(right,Maze, ProximoMaze):-
	index(Maze,R,C,"@"),                             % pegar linha e coluna do Jogador
	Right is (C+1) mod 15,                                       % proxima pos do jogador
	apagaPosicaoEAnda(R,C, Maze, "-", MatUpd),         % apagando pos anterior
	apagaPosicaoEAnda(R,Right, MatUpd, "@", ProximoMaze).

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
