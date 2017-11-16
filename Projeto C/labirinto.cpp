#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <string.h>
#include <fstream>
#include <utility>
#include <curses.h>
#include <stdlib.h>
#include <unistd.h>

using namespace std;

char PAREDE = '#';
char ITEM = '*';
char JOGADOR = '@';
char ESPACO = ' ';
char ASCII_VALUE_BEGIN = 'N'; // valor arbitrario apenas para inicializar a variável;

int ESQUERDA = 1;
int DIREITA = 2;
int CIMA = 3;
int BAIXO = 4;

int LINHAS_LABIRINTO = 20;
int COLUNAS_LABIRINTO = 70;

char labirinto[20][70];
int faseAtual = 1;
pair <int, int> posicaoJogador;
int itensRestantes = 0;
int itensColetados = 0;
int score = 0;

long tempoInicial = 0;
long tempoAtual = 0;
long tempoRestante = 0;
long tempoTotal = 200;

void limpaTela(){
    #if defined(__linux__) || defined(__unix__) || defined(__APPLE__)
        system("clear");
    #endif

    #if defined(_WIN32) || defined(_WIN64)
        system("cls");
    #endif
}

void imprimeLabirinto() {
    limpaTela();

    for(int i = 0; i < LINHAS_LABIRINTO; i++) {
        for(int j = 0; j < COLUNAS_LABIRINTO; j++) {
            cout << labirinto[i][j];
        }
        cout << "\r" << endl;
    }
}

void telaIntroducao() {
    limpaTela();
    cout << "\r" << endl;                                                                                     
    cout << " _       _    _       _       _        \n\r";
    cout << "| | ___ | |_ |_| ___ |_| ___ | |_  ___ \n\r";
    cout << "| || .'|| . || ||  _|| ||   ||  _|| . |\n\r";
    cout << "|_||__,||___||_||_|  |_||_|_||_|  |___|\n\r";
    cout << "---------------------------------------\n\r";
    cout << " _       _    _       _       _        \n\r";
    cout << "| | ___ | |_ |_| ___ |_| ___ | |_  ___ \n\r";
    cout << "| || .'|| . || ||  _|| ||   ||  _|| . |\n\r";
    cout << "|_||__,||___||_||_|  |_||_|_||_|  |___|\n\r";
    cout << "---------------------------------------\n\r";
    cout << " _       _    _       _       _        \n\r";
    cout << "| | ___ | |_ |_| ___ |_| ___ | |_  ___ \n\r";
    cout << "| || .'|| . || ||  _|| ||   ||  _|| . |\n\r";
    cout << "|_||__,||___||_||_|  |_||_|_||_|  |___|\n\r";
    cout << "---------------------------------------\n\r";     
    cout << "\nCarregando...\r" << endl;
    sleep(3); // tempo da tela de introdução

}

void telaInstrucoes() {
    limpaTela();
    cout << "\r" << endl;                                                                                     

    cout << "----------------------------------------------------------------------------\n\r";
    cout << "---------------------------------INSTRUÇÕES---------------------------------\n\r";
    cout << "----------------------------------------------------------------------------\n\r";
    cout << "1 - USE OS DIRECIONAIS PARA MOVER O JOGADOR REPRESENTADO POR \"@\" -----------\n\r";
    cout << "2 - COLETE OS ITENS \"*\" ESPALHADOS NO LABIRINTO ----------------------------\n\r";
    cout << "3 - SE COLETAR TODOS ITENS DA FASE AUTOMATICAMENTE VOCÊ PASSA PARA PROXIMA--\n\r";
    cout << "4 - FIQUE DE OLHO NO TEMPO QUE VOCÊ TEM PARA PERCORRER AS FASES-------------\n\r";
    cout << "5 - CADA ITEM TEM UM SCORE QUE É ACUMULADO AO LONGA DAS FASES---------------\n\r";
    cout << "6 - A CADA FASE CONCLUIDA VOCÊ GANHA UM BÔNUS NO SCORE, PROPORCIONAL A FASE \n\r";
    cout << " ALCANÇADA------------------------------------------------------------------\n\r";
    cout << "----------------------------------------------------------------------------\n\r"; 
    cout << "----------------------------------------------------------------------------\n\r"; 
    cout << "\n                        \033[1;33m[2] - MENU\033[0m ||| [ESC] - SAIR                         \r" << endl;

    int asciiValue;
    asciiValue = getch();

    if (asciiValue == 27) {
	limpaTela();
	endwin();
	exit(0);
    } else if (asciiValue == 50) {
        return;
    } else {
	telaInstrucoes();
    }

}

void telaMenu() {
    limpaTela();
    cout << "\r" << endl;
    cout << "-------------------------------------------------\n\r";                                                                              
    cout << "----------------------MENU-----------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "----- _       _    _       _       _        -----\n\r";
    cout << "-----| | ___ | |_ |_| ___ |_| ___ | |_  ___ -----\n\r";
    cout << "-----| || .'|| . || ||  _|| ||   ||  _|| . |-----\n\r";
    cout << "-----|_||__,||___||_||_|  |_||_|_||_|  |___|-----\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";
    cout << "-------------------------------------------------\n\r";     
    cout << "\n\033[1;36m [1] - JOGAR\033[0m || \033[1;33m[2] - INSTRUÇÕES\033[0m || [ESC] - SAIR\r" << endl;

    int asciiValue;
    asciiValue = getch();

    if (asciiValue == 27) {
	limpaTela();
	endwin();
	exit(0);
    } else if (asciiValue == 49) {
        return;
    } else if (asciiValue == 50) {
       telaInstrucoes();
       telaMenu();
    } else {
	telaMenu();
    }

}

void telaConclusao() {
    limpaTela();
    cout << "\r" << endl;                                                                                     
    cout << "--------------------------------------------\n\r";
    cout << "--------------------------------------------\n\r";
    cout << "--------------------------------------------\n\r";
    cout << "--------------------------------------------\n\r";
    cout << " ___                                        \n\r";
    cout << "| __| ___  _____  ___    ___  _ _  ___  ___ \n\r";
    cout << "| . || .'||     || ..|  | . || | || ..||  _|\n\r";
    cout << "|___||__,||_|_|_||___   |___||___||___ |_|  \n\r";
    cout << "--------------------------------------------\n\r";
    cout << "--------------------------------------------\n\r";
    cout << "--------------------------------------------\n\r";     
    cout << "\r\033[1;34m---------------> SCORE FINAL: " << score << "\033[0m" << endl;
    sleep(6); // tempo da tela de conclusao

}

void carregaFase(int fase) {
    char ch;
    ifstream inFile;

    itensRestantes = 0;
    itensColetados = 0;

    string nomeArquivo = "fase" + to_string(fase) + ".txt";
    inFile.open(nomeArquivo);
    if (!inFile) {
        cout << "Unable to open file - ";
        abort(); // aborta secção com erro
    }

    // read chars from file
    int i = 0;
    int j = 0;
    while (inFile >> noskipws >> ch) {
        labirinto[i][j] = ch;
        if (ch == JOGADOR) {
            posicaoJogador = make_pair(i, j);
        }
        j++;
        if(ch == '\n'){
            i++;
            j = 0;
        }
        if(ch == ITEM) {
            itensRestantes += 1;
        }
    }

    inFile.close();

}

bool verificaLimite(pair <int, int> coord) {
    return coord.first < LINHAS_LABIRINTO && coord.first >= 0 && coord.second < COLUNAS_LABIRINTO && coord.second >= 0;
}

bool verificaParede(pair <int, int> coord) {
    return labirinto[coord.first][coord.second] == PAREDE;
}

void verificaItem(pair <int, int> coord) {
    if (labirinto[coord.first][coord.second] == ITEM) {
        itensColetados++;
        itensRestantes--;
	score += (tempoRestante/3)*itensColetados; // calculo para score do item coletado (quanto menor o tempo para colatar, maior score)
    }
}

void moveJogador(int direcao) {
    pair <int, int> novaPosicao;
    switch(direcao) {
        case 1 : // ESQUERDA
            novaPosicao = make_pair(posicaoJogador.first, posicaoJogador.second - 1);
            if (verificaLimite(novaPosicao)) {
                if (!verificaParede(novaPosicao)) {
                    verificaItem(novaPosicao);
                    labirinto[posicaoJogador.first][posicaoJogador.second] = ESPACO;
                    posicaoJogador = novaPosicao;
                    labirinto[posicaoJogador.first][posicaoJogador.second] = JOGADOR;

                }
            }
            break;

        case 2 : // DIREITA
            novaPosicao = make_pair(posicaoJogador.first, posicaoJogador.second + 1);
            if (verificaLimite(novaPosicao)) {
                if (!verificaParede(novaPosicao)) {
                    verificaItem(novaPosicao);
                    labirinto[posicaoJogador.first][posicaoJogador.second] = ESPACO;
                    posicaoJogador = novaPosicao;
                    labirinto[posicaoJogador.first][posicaoJogador.second] = JOGADOR;

                }
            }
            break;

        case 3 : // CIMA
            novaPosicao = make_pair(posicaoJogador.first + 1, posicaoJogador.second);
            if (verificaLimite(novaPosicao)) {
                if (!verificaParede(novaPosicao)) {
                    verificaItem(novaPosicao);
                    labirinto[posicaoJogador.first][posicaoJogador.second] = ESPACO;
                    posicaoJogador = novaPosicao;
                    labirinto[posicaoJogador.first][posicaoJogador.second] = JOGADOR;

                }
            }
            break;

        case 4 : // BAIXO
            novaPosicao = make_pair(posicaoJogador.first - 1, posicaoJogador.second);
            if (verificaLimite(novaPosicao)) {
                if (!verificaParede(novaPosicao)) {
                    verificaItem(novaPosicao);
                    labirinto[posicaoJogador.first][posicaoJogador.second] = ESPACO;
                    posicaoJogador = novaPosicao;
                    labirinto[posicaoJogador.first][posicaoJogador.second] = JOGADOR;

                }
            }
            break;
    }
}

int main() {
    initscr();
    keypad(stdscr, TRUE);
    char key;
    int asciiValue = ASCII_VALUE_BEGIN;

    telaIntroducao();
    carregaFase(1);

    refresh();
    telaMenu();

    imprimeLabirinto();
    tempoInicial = time(0); // inicio do jogo

    while(1) {
        if (asciiValue == 27)
            break;

        if (asciiValue == 75 || asciiValue == 4) {
            moveJogador(ESQUERDA);
        } else if (asciiValue == 77 || asciiValue == 5) {
            moveJogador(DIREITA);
        }  else if (asciiValue == 72 || asciiValue == 3) {
            moveJogador(BAIXO);
        }  else if (asciiValue == 80 || asciiValue == 2) {
            moveJogador(CIMA);
        }
        
        imprimeLabirinto();
	
	tempoAtual = time(0)-tempoInicial;
	tempoRestante = tempoTotal - tempoAtual;

        cout << endl;
	cout << "\r\033[1;32m Itens coletados: " << itensColetados << "\033[0m"
		<< " || \033[1;34mScore: " << score << "\033[0m" 
		<< " || \033[1;31mTempo Restante: " << tempoRestante  << "\033[0m" 
		<< " || " << "[ESC] - SAIR"
		<< endl;

 	timeout(1000); // função que garante a execução do bloco (com ou sem entrada de teclado);

        // condição de termino do jogo por falta de tempo
	if(tempoRestante==0) {
	     telaConclusao();		
	     break;
	}

        // verifica os itens pegos para passar de fase
        if (itensRestantes == 0) {
            faseAtual += 1;
	    score+= (faseAtual*10); // bônus no score por ter completado fase
            if (faseAtual == 5) {
                break;
            }
            carregaFase(faseAtual);
            imprimeLabirinto();
        }
        
        key = getch();
        asciiValue = key;
    }

    endwin();

    return 0;
}
