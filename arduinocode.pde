//LED Cube 5x5x5 - Arduino sketch

//Columns Shift Register
int latchPinC = 5;
int clockPinC = 4;
int dataPinC = 3;

//Rows Shift Register
int latchPinR = 10;
int clockPinR = 11;
int dataPinR = 9;

byte matrix[26];
byte matconv[25][5];
long matout[4][5];
byte head;
int state = 0;

void matconvert() {
  for(int row = 0; row < 25; row++) {
    for(int col = 0; col <5; col++) {
      matconv[row][col] = bitRead( matrix[row], col) ;
    }
  }
  for(int col = 0; col < 5; col++) {
    for(int row = 0; row < 24; row++) {
      for(int r = 0; r < 3; r++) {
        matout[r][col] = bitWrite( matout[r][col], row - (8 * r), matconv[row][col]);
      }
      matout[3][col] = bitWrite( matout[3][col], 0, matconv[24][col]);
    }
  }
  panelOut();
}

void panelOut() {
  for (int col = 0; col < 5; col++) {
    int colbit = 1 << col;
    digitalWrite(latchPinC, LOW);
    shiftOut(dataPinC, clockPinC, MSBFIRST, colbit);
    digitalWrite(latchPinR, LOW);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[3][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[2][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[1][col]);
    shiftOut(dataPinR, clockPinR, MSBFIRST, matout[0][col]);
    digitalWrite(latchPinC, HIGH);
    digitalWrite(latchPinR, HIGH);
  }
}

void setup() {
  for(int row = 0; row < 2; row++) {
    for(int col = 0; col < 8; col++) {
      matout[row][col] = 0;
    }
  }
  pinMode(clockPinC, OUTPUT);
  pinMode(latchPinC, OUTPUT);
  pinMode(dataPinC,  OUTPUT);
  pinMode(clockPinR, OUTPUT);
  pinMode(latchPinR, OUTPUT);
  pinMode(dataPinR,  OUTPUT);
  digitalWrite(clockPinC, LOW);
  digitalWrite(latchPinC, LOW);
  digitalWrite(dataPinC,  LOW);
  digitalWrite(clockPinR, LOW);
  digitalWrite(latchPinR, LOW);
  digitalWrite(dataPinR,  LOW);
  Serial.begin(9600);
  head = (byte) 0x55;
}

void loop() {
  if (Serial.available()>0) {
    int input = Serial.read();
    switch (state) {
    case 0:
      if (input==head) {
        state = 1;
      }
      break;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    case 7:
    case 8:
    case 9:
    case 10:
    case 11:
    case 12:
    case 13:
    case 14:
    case 15:
    case 16:
    case 17:
    case 18:
    case 19:
    case 20:
    case 21:
    case 22:
    case 23:
    case 24:
      if((byte) input < 0) {
        matrix[state-1] = (byte) input + 256;
        state++;
        break;
      }
      else {
        matrix[state-1] = (byte) input;
        state++;
        break;
      }
    case 25:
      if((byte) input < 0) {
        matrix[state-1] = (byte) input + 256;
        state = 0;
        matconvert();
        break;
      }
      else {
        matrix[state-1] = (byte) input;
        state = 0;
        matconvert();
        break;
      }
    }
  }
  else {
    panelOut();
  }
}
