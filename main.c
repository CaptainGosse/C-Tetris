#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
//#include <stdlib.h>
#include <termios.h>
#include <fcntl.h>


uint16_t s_grid[20];
uint16_t *p_grid[20];
int score = 0;
//int score = 0;
//uint16_t nextBlock = 0xACE1;

/*
    15 bit is 
*/
const uint8_t NEW_BLOCK = 0x1;

uint8_t coords[8]; //x, y

uint8_t flag = 0x20;
/*
    7 
    6 
    5 END_GAME
    4 COLISION  
    3 
    2 
    1 
    0
*/

const uint8_t COLISION_MASK  = 0x10;
const uint8_t GAME_LOOP_MASK = 0x20;

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
  const uint8_t BLOCK = '#';
  const uint8_t EMPTY = '.';
  uint16_t l = 1;
  uint8_t cursor = 0;
  char screenBuf[256];
  screenBuf[cursor++] = '\033';
  screenBuf[cursor++] = '[';
  screenBuf[cursor++] = 'H';
  // printf("\033[H\n");
  for (uint8_t i = 0, j = 0; i < 20; i++) {
    for (j = 0; j < 10; j++) {
      screenBuf[cursor++] = (*p_grid[i]) & l ? BLOCK : EMPTY;
      l <<= 1;
    }
    screenBuf[cursor++] = '\n';
    l = 1;
  }
    write(1, screenBuf, cursor);

}

void printBlock(uint8_t *x, uint8_t *y){
    *p_grid[*y]|=1<<*x;
}


void printTetris(uint8_t *fig){
    printBlock(&fig[0], &fig[1]);
    printBlock(&fig[2], &fig[3]);
    printBlock(&fig[4], &fig[5]);
    printBlock(&fig[6], &fig[7]);
}


void clearBlock(uint8_t *x, uint8_t *y){
    *p_grid[*y]&=~(1<<*x);
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


void setCoords(uint16_t *t){
    if((*p_grid[0]) != 0) {
        flag&=~(GAME_LOOP_MASK);
        return;
    }
    for(int i = 0; i < 8; i++){
        coords[i] = figures[*t % 7][i];
    }
    *t^= *t  >> 7;
    *t^= *t << 9;
    *t^= *t >>13;

}

void checkColision(uint16_t *nextBlock){
    if((flag & COLISION_MASK) == COLISION_MASK){
        printTetris(coords);
        setCoords(nextBlock);
        flag^=COLISION_MASK;
    }
}

void rotateTetris(){
    int8_t buf[8];
    for(uint8_t i =0; i < 8;i+=2){
        buf[i] = coords[1] + coords[0] - coords[i + 1];
        buf[i+1] = coords[i] -coords[0] + coords[1];
        if(buf[i + 1] < 0 ) return;
        if(!(buf[i] > -1 && buf[i] < 10) || (*p_grid[buf[i+1]] & (1 << (buf[i] - 1)))) return;
    }

//x = -(y - y0) + y0 = -y + 2y0
    for(uint8_t i = 0; i < 8; i+=2){
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

void checkTetris(uint8_t *speed){
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
          score+= 100;
      }
  }
  printf("Score: %d", score);
  *speed-=(score / 1000);
}

int main(void){
  for (int i = 0; i < 20; i++) {
    s_grid[i] = 0;
    p_grid[i] = &s_grid[i];
  }
  uint16_t nextBlock = 0xACE1;
  uint8_t speed = 20;
  printf("Score: 0");
  setCoords(&nextBlock);
  uint8_t tick = 0;
  int c;
  struct termios t, old;
  tcgetattr(STDIN_FILENO, &t);
  old = t;
  t.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, 0, &t);
  fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
  do {
    printTetris(coords);
    show();
    if(tick % speed == 0){
      clearTetris(coords);
      tetrisDown(coords, &flag);
      tick = 0;
      printf("Speed: %d", speed);
    }
    c = getchar();
    if (c != EOF) {
      clearTetris(coords);
      if (c == 'a') {
        horMoveLeft();
      }
      if (c == 'd') {
        horMoveRight();
      }
      if (c == 'w') {
        rotateTetris();
      }
    }
    // printTetris(coords);
    // show();
    clearTetris(coords);
    checkColision(&nextBlock);
    checkTetris(&speed);
    usleep(10000);
    tick++;
  }while (flag & GAME_LOOP_MASK);
  tcsetattr(STDIN_FILENO, TCSANOW, &old); // restore old settings
}

// printTetris(coords);
// show();
// pthread_mutex_unlock(&mtx);
// usleep(500000);
// pthread_mutex_lock(&mtx);
// printTetris(coords);
// clearTetris(coords);
// tetrisDown(coords, &flag);
// checkColision();
// checkTetris();