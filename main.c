#include <stdio.h>
#include <stdint.h>
#include <ncurses.h>
#include <unistd.h>
#include <stdlib.h>

uint16_t s_grid[20];
uint16_t *p_grid[20];

uint8_t coords[8]; //x, y

uint8_t flag = 1;

int fig = 0;

const uint8_t COLISION_MASK  = 0x10;
const uint8_t END_GAME_MASK = 0x20;

const uint8_t figures[7][8] = {
    {4,1,4,0,3,1,5,1},
    {4,0,5,0,3,0,6,0}, 
    {4,0,4,1,5,0,5,1},  
    {4,1,4,0,3,1,5,0},
    {4,1,4,0,3,0,5,1},
    {4,1,4,0,4,2,5,0},
    {4,1,4,0,4,2,3,2}
};

void show(){
    uint16_t l = 1;
    for(int i = 0, j = 0; i < 20; i++){
        for(j = 0; j < 10; j++){
            if(((*p_grid[i])&l) == l){
                //printf("*p_grid = %d ", *p_grid[i]);
                //printf("Print point at x = %d, y = %d\n", j, i);
                mvaddch(i , j+ 10, '#');
            }else{
                mvaddch(i, j+ 10, '.');
            }
            l<<=1;
        }
        l = 1;
    }
    refresh();
}

void printBlock(uint8_t *x, uint8_t *y){
    uint16_t b = 1;
    b<<=*x;
    //*p_grid[*y]|=1<<*x;
    *p_grid[*y]|=b;
}


void printTetris(uint8_t *fig){
    printBlock(&fig[0], &fig[1]);
    printBlock(&fig[2], &fig[3]);
    printBlock(&fig[4], &fig[5]);
    printBlock(&fig[6], &fig[7]);
}


void clearBlock(uint8_t *x, uint8_t *y){
    uint16_t b = 1;
    b<<=*x;
    *p_grid[*y]^=b;
}

void clearTetris(uint8_t *fig){
    clearBlock(&fig[0], &fig[1]);
    clearBlock(&fig[2], &fig[3]);
    clearBlock(&fig[4], &fig[5]);
    clearBlock(&fig[6], &fig[7]);
}

void tetrisDown(uint8_t *fig, uint8_t *f){
    if(!(fig[1] < 19) || (*p_grid[fig[1] + 1] & (1<<fig[0]))) {*f|=COLISION_MASK; return;}
    if(!(fig[3] < 19) || (*p_grid[fig[3] + 1] & (1<<fig[2]))) {*f|=COLISION_MASK; return;}
    if(!(fig[5] < 19) || (*p_grid[fig[5] + 1] & (1<<fig[4]))) {*f|=COLISION_MASK; return;}
    if(!(fig[7] < 19) || (*p_grid[fig[7] + 1] & (1<<fig[6]))) {*f|=COLISION_MASK; return;}
    fig[1]++;
    fig[3]++;
    fig[5]++;
    fig[7]++;
}


void setCoords(){
    if(fig > 6) {
        flag|=END_GAME_MASK;
        return;
    }
    int r = rand() % 7;
    for(int i = 0; i < 8; i++){
        coords[i] = figures[r][i];
    }
    mvprintw(0,21, "             ");
    mvprintw(1,21, "             ");
    mvprintw(2,21, "             ");
    mvprintw(3,21, "             ");
}

void checkColision(){
    if((flag & COLISION_MASK) == COLISION_MASK){
        printTetris(coords);
        setCoords();
        flag^=COLISION_MASK;
    }
}

void rotateTetris(){
    int8_t buf[8];
    for(int i =0; i < 8;i+=2){
        //buf[i] = coords[i] - coords[0];
        //buf[i + 1] = coords[i + 1] - coords[1];
        //int8_t t = buf[i];
        //buf[i] = (buf[i + 1] * -1) + coords[0];
        //buf[i + 1] = t + coords[1];

        buf[i] = coords[1] + coords[0] - coords[i + 1];
        buf[i+1] = coords[i] -coords[0] + coords[1];
        if(buf[i + 1] < 0 ) return;
        if(!(buf[i] > 0 & buf[i] < 9) || (*p_grid[buf[i+1]] & (1 << (buf[i] - 1)))) return;
    }

//x = -(y - y0) + y0 = -y + 2y0
    for(int i = 0; i < 8; i++){
        coords[i] = buf[i];
        coords[i+1] = buf[i+1];
    }
}

void horMoveLeft(){
    if(!(coords[0] > 0) || (*p_grid[coords[1]] & (1 << (coords[0] - 1)))) return;
    if(!(coords[2] > 0) || (*p_grid[coords[3]] & (1 << (coords[2] - 1)))) return;
    if(!(coords[4] > 0) || (*p_grid[coords[5]] & (1 << (coords[4] - 1)))) return;
    if(!(coords[6] > 0) || (*p_grid[coords[7]] & (1 << (coords[6] - 1)))) return;
    coords[0]--;
    coords[2]--;
    coords[4]--;
    coords[6]--;
}


void horMoveRight(){
    if(!(coords[0] < 9) || (*p_grid[coords[1]] & (1 << (coords[0] + 1)))) return;
    if(!(coords[2] < 9) || (*p_grid[coords[3]] & (1 << (coords[2] + 1)))) return;
    if(!(coords[4] < 9) || (*p_grid[coords[5]] & (1 << (coords[4] + 1)))) return;
    if(!(coords[6] < 9) || (*p_grid[coords[7]] & (1 << (coords[6] + 1)))) return;
    coords[0]++;
    coords[2]++;
    coords[4]++;
    coords[6]++;
}


void checkISR(char c){
    if(c == ERR) return;
    clearTetris(coords);
    if(c == 'a'){
       horMoveLeft(); 
    }
    if(c == 'd'){
       horMoveRight();
    }
    if(c == 'w'){
        rotateTetris();
    }
    flushinp();
}

void checkTetris(){
    uint16_t l = 0x3FF;
    uint16_t *b;
    for(int i = 19; i >= 0; i--){
        if((*p_grid[i] & l) == l){
            b = p_grid[i];
            for(int j = i; j >= 1;j--){
              p_grid[j] = p_grid[j - 1];  
            }
            p_grid[0] = b;
            *p_grid[0] = 0;
        }
    }
}


int main(void){
    initscr();
    mvvline(0, 9, ACS_VLINE, 20);
    mvvline(0,20, ACS_VLINE, 20);
    refresh();
    timeout(100);
    noecho();
    for(int i = 0; i < 20; i++){
        s_grid[i] = 0;
        p_grid[i] = &s_grid[i];
    } 
    setCoords();
    //s_grid[5] = 255;
    do{
        printTetris(coords);
        show();
        //sleep(1);
        napms(300);
        checkISR(getch());
        printTetris(coords);
        clearTetris(coords);
        tetrisDown(coords, &flag);
        mvprintw(0,21, "X = %d, Y = %d", coords[0], coords[1]);
        mvprintw(1,21, "X = %d, Y = %d", coords[2], coords[3]);
        mvprintw(2,21, "X = %d, Y = %d", coords[4], coords[5]);
        mvprintw(3,21, "X = %d, Y = %d", coords[6], coords[7]); 
        refresh();
        checkColision();
        checkTetris();
    }while((flag & END_GAME_MASK) != END_GAME_MASK);
    mvprintw(4,21, "End game");
    refresh();
    timeout(-1);
    getch();
    endwin();
    return 0;
}
