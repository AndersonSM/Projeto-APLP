#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <string.h>
#include <fstream>
#include <utility>
#include<conio.h>
using namespace std;

char PAREDE = '#';
char ITEM = '*';
char JOGADOR = '@';
char ESPACO = ' ';

int ESQUERDA = 1;
int DIREITA = 2;
int CIMA = 3;
int BAIXO = 4;

char labirinto[10][10];
pair <int, int> posicaoJogador;
int itensColetados = 0;

void imprimeLabirinto() {
    cout << string(50, '\n');
    for(int i = 0; i < sizeof labirinto[0]; i++) {
        for(int j = 0; j < sizeof labirinto[0]; j++) {
            cout << labirinto[i][j];
        }
        cout << endl;
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


int main() {
    char key;
    int asciiValue;
    char ch;
    ifstream inFile;

    inFile.open("test.txt");
    if (!inFile) {
        cout << "Unable to open file";
        exit(1); // terminate with error
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
    }
    inFile.close();

    imprimeLabirinto();

    while(1)
    {
        key = getch();
        asciiValue = key;

        if (asciiValue == 27)
            break;

        if (asciiValue == 75) {
            moveJogador(ESQUERDA);
        } else if (asciiValue == 77) {
            moveJogador(DIREITA);
        }  else if (asciiValue == 72) {
            moveJogador(BAIXO);
        }  else if (asciiValue == 80) {
            moveJogador(CIMA);
        }
        imprimeLabirinto();
        cout << endl << "Itens coletados: " << itensColetados << endl;
    }

    return 0;
}
