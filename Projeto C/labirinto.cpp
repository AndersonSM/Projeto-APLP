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
char ASCII_VALUE_BEGIN = 'N';

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

void carregaFase(int fase) {
    char ch;
    ifstream inFile;

    itensRestantes = 0;
    itensColetados = 0;

    string nomeArquivo = "fase" + to_string(fase) + ".txt";
    inFile.open(nomeArquivo);
    if (!inFile) {
        cout << "Unable to open file - ";
        abort(); // terminate with error
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
    int asciiValue;

    //cout<<"\e[8;25;100t"; // redimensionar o terminal
    telaIntroducao();
    carregaFase(1);

    printw("\nAperte alguma tecla para começar...");

    key = getch();
    asciiValue = ASCII_VALUE_BEGIN; // valor arbitrario apenas para ser usado dentro do loop
    imprimeLabirinto();
    
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
        cout << endl;
        cout << "\rItens restantes: " << itensRestantes << endl;

        // verifica os itens pegos para passar de fase
        if (itensRestantes == 0) {
            faseAtual += 1;
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
