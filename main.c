#include <stdint.h>
#include <time.h>
#include <unistd.h>
#include <termios.h>
#include <fcntl.h>

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

void show(uint16_t **p_grid ,uint8_t *screenBuf){

  uint16_t l = 1;
  uint8_t cursor = 3;
    for (uint8_t i = 0, j = 0; i < 20; i++) {
    for (j = 0; j < 10; j++) {
      screenBuf[cursor++] = (*p_grid[i]) & l ? BLOCK : EMPTY;
      l <<= 1;
    }
    screenBuf[cursor++] = '\n';
    l = 1;
  }
  write(1, screenBuf, cursor + 3);
}

void printTetris(uint16_t **p_grid, uint8_t *fig){
    for(uint8_t i = 0; i < 8; i+=2){
        *p_grid[fig[i + 1]]|=1<<fig[i];
    }
}

void clearTetris(uint16_t **p_grid, uint8_t *fig){
    for(uint8_t i = 0; i < 8; i+=2){
      *p_grid[fig[i + 1]]&=~(1<<fig[i]);
    }
}

void tetrisDown(uint16_t **p_grid, uint8_t *fig, uint8_t *f){
  for(uint8_t i = 0; i < 8; i+=2){
    if (fig[i + 1] >= 19 || (*p_grid[fig[i + 1] + 1] & (1 << fig[i]))) {
      *f |= COLISION_MASK;
      return;
    }
  }
  fig[1]++;
  fig[3]++;
  fig[5]++;
  fig[7]++;
}

void setCoords(uint16_t **p_grid, uint8_t *coords, uint16_t *t, uint8_t *flag){
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

void checkColision(uint16_t **p_grid, uint8_t *coords, uint16_t *nextBlock, uint8_t *flag){
    if((*flag & COLISION_MASK) == COLISION_MASK){
        printTetris(p_grid, coords);
        setCoords(p_grid, coords, nextBlock, flag);
        *flag^=COLISION_MASK;
    }
}

void rotateTetris(uint16_t **p_grid, uint8_t *coords){
    int8_t buf[8];
    for(uint8_t i =0; i < 8;i+=2){
        buf[i] = coords[1] + coords[0] - coords[i + 1];
        buf[i+1] = coords[i] -coords[0] + coords[1];
        if(buf[i + 1] < 0 ) return;
        if(!(buf[i] > -1 && buf[i] < 10) || (*p_grid[buf[i+1]] & (1 << buf[i]))) return;
    }
    for(uint8_t i = 0; i < 8; i+=2){
        coords[i] = buf[i];
        coords[i+1] = buf[i+1];
    }
}

void horMoveLeft(uint16_t **p_grid, uint8_t *coords){
  for(uint8_t i = 0; i < 8; i+=2){
    if (!(coords[i] > 0) || (*p_grid[coords[i + 1]] & (1 << (coords[i] - 1))))
      return;
  }
  coords[0]--;
  coords[2]--;
  coords[4]--;
  coords[6]--;
}


void horMoveRight(uint16_t **p_grid, uint8_t *coords){
  for(uint8_t i = 0; i < 8; i+=2){
    if (!(coords[i] < 9) || (*p_grid[coords[i + 1]] & (1 << (coords[i] + 1))))
      return;
  }
  coords[0]++;
  coords[2]++;
  coords[4]++;
  coords[6]++;
}

void checkTetris(uint16_t **p_grid, uint16_t *score, uint8_t *speed, uint8_t *screen){
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
          if(*score < UINT16_MAX)
            *score = *score + 1;
          i = 19;
          screen[223] = '0' + (*score / 100);
          screen[224] = '0' + ((*score / 10) % 10);
          screen[225] = '0' + (*score % 10);

      }
  }
}

int main(void){
  uint16_t s_grid[20];
  uint16_t *p_grid[20];
  for (int i = 0; i < 20; i++) {
    s_grid[i] = 0;
    p_grid[i] = &s_grid[i];
  }
  uint16_t nextBlock = (uint16_t)time(NULL);
  uint8_t speed = 20;
  uint8_t coords[8]; // x, y
  uint8_t flag = 0x20;
  uint8_t tick = 0;
  int8_t c;
  int8_t input_size = 0;
  struct termios t, old;
  uint16_t score = 0;
  uint8_t screenBuf[226];
  screenBuf[0] = '\033';
  screenBuf[1] = '[';
  screenBuf[2] = 'H';
  screenBuf[223] = '0';
  screenBuf[224] = '0';
  screenBuf[225] = '0';
  tcgetattr(STDIN_FILENO, &t);
  old = t;
  t.c_lflag &= ~(ICANON | ECHO);
  tcsetattr(STDIN_FILENO, 0, &t);
  fcntl(STDIN_FILENO, F_SETFL, O_NONBLOCK);
  setCoords(p_grid, coords, &nextBlock, &flag);
  do {
    printTetris(p_grid, coords);
    show(p_grid,screenBuf);
    clearTetris(p_grid, coords);
    if(tick % speed == 0){
      tetrisDown(p_grid, coords, &flag);
      tick = 0;
    }
    input_size = read(0, &c, 1);
    if (input_size > 0) {
      if (c == 'a') horMoveLeft(p_grid, coords);
      if (c == 'd') horMoveRight(p_grid, coords);
      if (c == 'w') rotateTetris(p_grid, coords);
    }
    checkColision(p_grid, coords, &nextBlock, &flag);
    checkTetris(p_grid, &score, &speed, screenBuf);
    usleep(10000);
    tick++;
  }while (flag & GAME_LOOP_MASK);
  tcsetattr(STDIN_FILENO, TCSANOW, &old);
}