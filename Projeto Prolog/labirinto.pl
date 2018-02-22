limpaTela :- write('\e[H\e[2J').

getch(1) :- 
	limpaTela,
	imprimeTelaNivel.
getch(2) :- 
	limpaTela,
	imprimeTelaInstrucoes.
getch(3) :- 
	limpaTela,
	imprimeTelaMenu.

imprimeTelaInicial :-
	limpaTela,
	write(" _       _    _       _       _        "),nl,
	write("| | ___ | |_ |_| ___ |_| ___ | |_  ___ "),nl,
	write("| || .'|| . || ||  _|| ||   ||  _|| . |"),nl,
	write("|_||__,||___||_||_|  |_||_|_||_|  |___|"),nl,
	write("---------------------------------------"),nl,
	write(" _       _    _       _       _        "),nl,
	write("| | ___ | |_ |_| ___ |_| ___ | |_  ___ "),nl,
	write("| || .'|| . || ||  _|| ||   ||  _|| . |"),nl,
	write("|_||__,||___||_||_|  |_||_|_||_|  |___|"),nl,
	write("---------------------------------------"),nl,
	write(" _       _    _       _       _        "),nl,
	write("| | ___ | |_ |_| ___ |_| ___ | |_  ___ "),nl,
	write("| || .'|| . || ||  _|| ||   ||  _|| . |"),nl,
	write("|_||__,||___||_||_|  |_||_|_||_|  |___|"),nl,
	write("---------------------------------------"),nl,
	write("carregando..."),nl,
	sleep(3),
	limpaTela.

imprimeTelaMenu :-
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
	write("\033[1;36m [1] - JOGAR"),
	write("\033[0m || "),
	write("\033[1;33m[2] - INSTRUÇÕES"),
	write("\033[0m || [ESC] - SAIR"),nl,nl,
	read_line_to_codes(user_input, X1),
	string_to_atom(X1,X2),
	atom_number(X2,N),
	getch(N).

imprimeTelaInstrucoes :-
	limpaTela,                                                                                     
	write("------------------------------------------------------------------------------"),nl,
	write("---------------------------------INSTRUÇÕES-----------------------------------"),nl,
	write("-----------------------------------------------------------------------------"),nl,
	write("1 - USE OS DIRECIONAIS PARA MOVER O JOGADOR REPRESENTADO POR \"@\" ------------"),nl,
	write("2 - COLETE OS ITENS \"*\" ESPALHADOS NO LABIRINTO -----------------------------"),nl,
	write("3 - SE COLETAR TODOS OS ITENS DA FASE AUTOMATICAMENTE VOCÊ PASSA PARA PRÓXIMA"),nl,
	write("4 - FIQUE DE OLHO NO TEMPO QUE VOCÊ TEM PARA PERCORRER AS FASES--------------"),nl,
	write("5 - CADA ITEM TEM UM SCORE QUE É ACUMULADO AO LONGA DAS FASES----------------"),nl,
	write("6 - A CADA FASE CONCLUÍDA, VOCÊ GANHA UM BÔNUS NO SCORE, PROPORCIONAL A FASE "),nl,
	write("----ALCANÇADA----------------------------------------------------------------"),nl,
	write( "-----------------------------------------------------------------------------"),nl,
	write( "-----------------------------------------------------------------------------"),nl,
	write("                   \033[1;36m[1] - JOGAR \033[0m|| \033[1;33m[3] - MENU\033[0m || [ESC] - SAIR"),nl,
	read_line_to_codes(user_input, X1),
	string_to_atom(X1,X2),
	atom_number(X2,N),
	getch(N).

imprimeTelaNivel :-
	write("--------------------------------------------"),nl,
	sleep(0.2),
	write("--------------------------------------------"),nl,
	sleep(0.2),
	write("--------------------------------------------"),nl,
	sleep(0.2),
	write("-------------------F------------------------"),nl,
	sleep(0.2),
	write("--------------------A-----------------------"),nl,
	sleep(0.2),
	write("---------------------S----------------------"),nl,
	sleep(0.2),
	write("----------------------E---------------------"),nl,
	sleep(0.2),
	write("------------------------1-------------------"),nl,
	sleep(0.2),
	write("--------------------------------------------"),nl,
	sleep(0.2),
	write("--------------------------------------------"),nl,
	sleep(0.2),
	write("--------------------------------------------"),nl,
	sleep(3),
	limpaTela,
	imprimeLabirinto.

imprimeLabirinto :-
	carregaFase,
	read_line_to_codes(user_input, X1),
	string_to_atom(X1,X2),
	atom_number(X2,N),
	getch(N).

carregaFase :-
	open('fase1.txt', read, Stream),
	lerArquivo(Stream,Lista_Linhas),
	close(Stream),
	imprime_Linha(Lista_Linhas),nl.

/* Imprime sequencialmente cada linha do labirinto */
imprime_Linha([end_of_file]).
imprime_Linha([H|T]) :-
	format('~w\t',H),nl,
	imprime_Linha(T).

/* Ler cada caractere do arquivo faseX.txt para alimentar uma lista*/
lerArquivo(Stream,[]) :-
         at_end_of_stream(Stream).
  
lerArquivo(Stream,[H|T]) :-
         \+  at_end_of_stream(Stream),
         read(Stream,H),
         lerArquivo(Stream,T).

:- initialization main.
main :-
	imprimeTelaInicial,
	imprimeTelaMenu,
halt(0).
