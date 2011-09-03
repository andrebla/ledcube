//Basic animations

import processing.serial.*;

Serial port;
int pressed = 0;

void anim() {
switch(pressed) {
    case 0:
    case 2:
    case 4:
    case 6:
    cleanScreen();
    break;
    case 1:
    allON();
    break;
    case 3:
    row();
    break;
    case 5:
    column();
    break;
    case 7:
    rand();
    break;
    case 8:
    pressed = 0;
    anim();
    break;
  }
}

void allON() {
  int output = 255;
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for (int j=0; j < 25; j++) {
    matrix[j+1] = (byte) output;
  }
  port.write(matrix);
  println(matrix);
}

void binRow() {
  int output = 0;
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for (int j = 1; j < 26; j++) {
    matrix[j] = (byte) (j);
  }
  port.write(matrix);
  println(matrix);
}

void rand() {
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for (int j = 1; j < 26; j++) {
    matrix[j] = (byte) (random(0,255));
  }
  port.write(matrix);
  println(matrix);
  delay(200);
}

void column() {
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for(int col = 0; col < 5; col++) {
    for (int j = 1; j < 26; j++) {
      matrix[j] = (byte) (pow(2,col));
    }
      port.write(matrix);
      println(matrix);
      delay(80);
  }
}

void row() {
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for (int j = 2; j < 26; j++) {
    matrix[j-1] = (byte) (0);
    matrix[j] = (byte) (255);
    port.write(matrix);
    println(matrix);
    delay(75);
  }
}

void cleanScreen() {
  int output = 0;
  byte [] matrix = new byte[25+1];
  matrix[0] = (byte) 0x55;
  for (int j=0; j < 25; j++) {
    matrix[j+1] = (byte) output;
  }
  port.write(matrix);
  println(matrix);
}

void mousePressed() {
  pressed++;
  anim();
}

void setup() {
  port = new Serial(this,"COM3",9600);
}

void draw() {
  anim();
}
