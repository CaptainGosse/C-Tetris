#include <stdint.h>
#include <unistd.h>
//#include <stdlib.h>
#include <termios.h>
#include <fcntl.h>


uint16_t s_grid[20];
uint16_t *p_grid[20];
const uint8_t COLISION_MASK  = 0x10;
const uint8_t GAME_LOOP_MASK = 0x20;

static const uint8_t figures[7][8] = {
    {4,1,4,0,3,1,5,1},
    {4,0,5,0,3,0,6,0}, 
    {4,0,4,1,5,0,5,1},  
    {4,1,4,0,3,1,5,0},
    {4,1,4,0,3,0,5,1},
    {4,1,4,0,4,2,5,0},
    {4,1,4,0,4,2,3,2}
};
const uint8_t BLOCK = '#';
const uint8_t EMPTY = '.';

void show(){

  uint16_t l = 1;
  uint8_t cursor = 0;
  char screenBuf[256];
  screenBuf[cursor++] = '\033';
  screenBuf[cursor++] = '[';
  screenBuf[cursor++] = 'H';
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

void printTetris(uint8_t *fig){
    for(uint8_t i = 0; i < 8; i+=2){
        *p_grid[fig[i + 1]]|=1<<fig[i];
    }
}

void clearTetris(uint8_t *fig){
    for(uint8_t i = 0; i < 8; i+=2){
        *p_grid[fig[i + 1]]&=~(1<<fig[i]);
    }
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


void setCoords(uint8_t *coords,uint16_t *t, uint8_t *flag){
    if((*p_grid[0]) != 0) {
        *flag&=~(GAME_LOOP_MASK);
        return;
    }
    for(int i = 0; i < 8; i++){
        coords[i] = figures[*t % 7][i];
    }
    *t^= *t >> 7;
    *t^= *t << 9;
    *t^= *t >>13;

}

void checkColision(uint8_t *coords, uint16_t *nextBlock, uint8_t *flag){
    if((*flag & COLISION_MASK) == COLISION_MASK){
        printTetris(coords);
        setCoords(coords, nextBlock, flag);
        *flag^=COLISION_MASK;
    }
}

void rotateTetris(uint8_t *coords){
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

void horMoveLeft(uint8_t *coords){
    if(!(coords[0] > 0) || (*p_grid[coords[1]] & (1 << (coords[0] - 1)))) return;
    if(!(coords[2] > 0) || (*p_grid[coords[3]] & (1 << (coords[2] - 1)))) return;
    if(!(coords[4] > 0) || (*p_grid[coords[5]] & (1 << (coords[4] - 1)))) return;
    if(!(coords[6] > 0) || (*p_grid[coords[7]] & (1 << (coords[6] - 1)))) return;
    coords[0]--;
    coords[2]--;
    coords[4]--;
    coords[6]--;
}


void horMoveRight(uint8_t *coords){
    if(!(coords[0] < 9) || (*p_grid[coords[1]] & (1 << (coords[0] + 1)))) return;
    if(!(coords[2] < 9) || (*p_grid[coords[3]] & (1 << (coords[2] + 1)))) return;
    if(!(coords[4] < 9) || (*p_grid[coords[5]] & (1 << (coords[4] + 1)))) return;
    if(!(coords[6] < 9) || (*p_grid[coords[7]] & (1 << (coords[6] + 1)))) return;
    coords[0]++;
    coords[2]++;
    coords[4]++;
    coords[6]++;
}

void checkTetris(uint16_t *score, uint8_t *speed){
  uint16_t l = 0x3FF;
  uint16_t *b;
  uint8_t screen[3];
  for(int i = 19; i >= 0; i--){
      if((*p_grid[i] & l) == l){
          b = p_grid[i];
          for(int j = i; j >= 1;j--){
            p_grid[j] = p_grid[j - 1];  
          }
          p_grid[0] = b;
          *p_grid[0] = 0;
          *score = *score + 1;
            screen[0] = '0' + (*score / 100);
            screen[1] = '0' + ((*score / 10) % 10);
            screen[2] = '0' + (*score % 10);
            write(1, &screen, 3);
      }
  }
}

int main(void){
  for (int i = 0; i < 20; i++) {
    s_grid[i] = 0;
    p_grid[i] = &s_grid[i];
  }
  uint16_t nextBlock = 0xACE1;
  uint8_t speed = 20;
  uint8_t coords[8]; // x, y
  uint8_t flag = 0x20;
  uint8_t tick = 0;
  int8_t c;
  int8_t input_size = 0;
  struct termios t, old;
  uint16_t score = 0;
  tcgetattr(STDIN_FILENO, &t);
  old = t;
  t.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, 0, &t);
  fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
  setCoords(coords, &nextBlock, &flag);
  do {
    printTetris(coords);
    show();
    if(tick % speed == 0){
      clearTetris(coords);
      tetrisDown(coords, &flag);
      tick = 0;
    }
    input_size = read(0, &c, 1);
    if (input_size > 0) {
      clearTetris(coords);
      if (c == 'a') horMoveLeft(coords);
      if (c == 'd') horMoveRight(coords);
      if (c == 'w') rotateTetris(coords);
    }
    clearTetris(coords);
    checkColision(coords, &nextBlock, &flag);
    checkTetris(&score, &speed);
    usleep(10000);
    tick++;
  }while (flag & GAME_LOOP_MASK);
  tcsetattr(STDIN_FILENO, TCSANOW, &old); // restore old settings
}
