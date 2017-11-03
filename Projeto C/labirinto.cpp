#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <string.h>
#include <fstream>
#include <utility>
#include <curses.h>
#include <stdlib.h>
#include <time.h>
using namespace std;

char PAREDE = '#';
char ITEM = '*';
char JOGADOR = '@';
char ESPACO = ' ';
char ASCIIVALUEBEGIN = 'N';

int ESQUERDA = 1;
int DIREITA = 2;
int CIMA = 3;
int BAIXO = 4;

struct timespec t = { 3.5/*seconds*/, 0/*nanoseconds*/}; // tempo da tela de instrodução

char labirinto[10][10];
pair <int, int> posicaoJogador;
int itensColetados = 0;

void clrscr(){
    #if defined(__linux__) || defined(__unix__) || defined(__APPLE__)
        system("clear");
    #endif

    #if defined(_WIN32) || defined(_WIN64)
        system("cls");
    #endif
}

void imprimeLabirinto() {
    clrscr(); // screen cleaning

    for(int i = 0; i < sizeof labirinto[0]; i++) {
        for(int j = 0; j < sizeof labirinto[0]; j++) {
            cout << labirinto[i][j];
        }
        cout << "\r" << endl;
    }
}

bool verificaLimite(pair <int, int> coord) {

    return coord.first < 10 && coord.first >= 0 && coord.second < 10 && coord.second >= 0;
}

bool verificaParede(pair <int, int> coord) {
    return labirinto[coord.first][coord.second] == PAREDE;
}

bool verificaItem(pair <int, int> coord) {
    return labirinto[coord.first][coord.second] == ITEM;
}

void moveJogador(int direcao) {
    pair <int, int> novaPosicao;
    switch(direcao) {
        case 1 : // ESQUERDA
            novaPosicao = make_pair(posicaoJogador.first, posicaoJogador.second - 1);
            if (verificaLimite(novaPosicao)) {
                if (!verificaParede(novaPosicao)) {
                    if (verificaItem(novaPosicao)) {
                        itensColetados++;
                    }
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
                    if (verificaItem(novaPosicao)) {
                        itensColetados++;
                    }
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
                    if (verificaItem(novaPosicao)) {
                        itensColetados++;
                    }
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
                    if (verificaItem(novaPosicao)) {
                        itensColetados++;
                    }
                    labirinto[posicaoJogador.first][posicaoJogador.second] = ESPACO;
                    posicaoJogador = novaPosicao;
                    labirinto[posicaoJogador.first][posicaoJogador.second] = JOGADOR;

                }
            }
            break;
    }
}
void telaIntroducao() {

    printf("\n00---------_000000_---00000000---00---00000000---00---00_____00---00000000---_000000_\n\r");
    printf("00---------00000000---00000000---__---00000000---__---000____00---00000000---00000000\n\r");
    printf("00---------00____00---00____0----00---00____00---00---0000___00------00------00____00\n\r");
    printf("00---------00000000---000000-----00---00000000---00---00_00__00------00------00____00\n\r");
    printf("00---------00000000---000000-----00---0000000----00---00__00_00------00------00____00\n\r");
    printf("00---------00____00---00____0----00---00_00------00---00___0000------00------00____00\n\r");
    printf("00000000---00____00---00000000---00---00___00----00---00____000------00------00000000\n\r");
    printf("00000000---00____00---00000000---00---00____00---00---00_____00------00------_000000_\n\r");
    printf("\nCarregando...\n");
    nanosleep(&t,NULL);

}

int main() {
    initscr();
    keypad(stdscr, TRUE);
    char key;
    int asciiValue;
    char ch;
    ifstream inFile;

    inFile.open("test.txt");
    if (!inFile) {
        cout << "Unable to open file - ";
        abort(); // terminate with error
    }

    telaIntroducao();

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
    }
    inFile.close();

    imprimeLabirinto();

    printw("\nAperte alguma tecla para começar...\n");
    key = getch();
    asciiValue = ASCIIVALUEBEGIN; // valor arbitrario apenas para ser usado dentro do loop

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
        cout << "\rItens coletados: " << itensColetados << endl;

        key = getch();
        asciiValue = key;
    }

    endwin();

    return 0;
}
