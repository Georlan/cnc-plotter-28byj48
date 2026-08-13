/*
  CNC Plotter 28BYJ-48 + ULN2003 (Arduino Uno) - Version 7.0 (Calibrated X & Y)
  ----------------------------------------------------------------------------
  Firmware com calibração precisa dos eixos X e Y:
  - STEPS_PER_MM_X = 71.4286 (Medido: 20mm sol. = 28mm real)
  - STEPS_PER_MM_Y = 90.9091 (Medido: 20mm sol. = 22mm real)
  - STEPS_PER_MM_Z = 160.0000 (Precisão fina no Z)
*/

#include <Arduino.h>

int pinX[4] = {2, 3, 4, 5};     // Eixo X
int pinY[4] = {A0, A1, A2, A3}; // Eixo Y
int pinZ[4] = {6, 7, 8, 9};     // Eixo Z

bool INVERT_X = false;
bool INVERT_Y = true;  // Eixo Y Invertido
bool INVERT_Z = true;  // Eixo Z Invertido

// Calibração Precisa de Passos por Millímetro (Regra de 3)
float STEPS_PER_MM_X = 71.4286; // Calibrado: 100 * (20 / 28)
float STEPS_PER_MM_Y = 90.9091; // Calibrado: 100 * (20 / 22)
float STEPS_PER_MM_Z = 160.0;

long stepDelayUS_XY = 1500;
long stepDelayUS_Z  = 2000;

float currentX = 0.0;
float currentY = 0.0;
float currentZ = 0.0;
bool absoluteMode = true;

const byte stepSequence[8] = {
  B00001000,
  B00001100,
  B00000100,
  B00000110,
  B00000010,
  B00000011,
  B00000001,
  B00001001
};

int stepIndexX = 0;
int stepIndexY = 0;
int stepIndexZ = 0;

void setMotorOutput(const int pins[4], byte pattern) {
  digitalWrite(pins[0], (pattern & B00001000) ? HIGH : LOW);
  digitalWrite(pins[1], (pattern & B00000100) ? HIGH : LOW);
  digitalWrite(pins[2], (pattern & B00000010) ? HIGH : LOW);
  digitalWrite(pins[3], (pattern & B00000001) ? HIGH : LOW);
}

void disableMotor(const int pins[4]) {
  for (int i = 0; i < 4; i++) {
    digitalWrite(pins[i], LOW);
  }
}

void stepMotor(int axis, int dir) {
  if (axis == 0) {
    int effectiveDir = INVERT_X ? -dir : dir;
    stepIndexX = (stepIndexX + effectiveDir + 8) % 8;
    setMotorOutput(pinX, stepSequence[stepIndexX]);
  } else if (axis == 1) {
    int effectiveDir = INVERT_Y ? -dir : dir;
    stepIndexY = (stepIndexY + effectiveDir + 8) % 8;
    setMotorOutput(pinY, stepSequence[stepIndexY]);
  } else if (axis == 2) {
    int effectiveDir = INVERT_Z ? -dir : dir;
    stepIndexZ = (stepIndexZ + effectiveDir + 8) % 8;
    setMotorOutput(pinZ, stepSequence[stepIndexZ]);
  }
}

void moveTo(float targetX, float targetY, float targetZ) {
  long targetStepsX = lround(targetX * STEPS_PER_MM_X);
  long targetStepsY = lround(targetY * STEPS_PER_MM_Y);
  long targetStepsZ = lround(targetZ * STEPS_PER_MM_Z);

  long startStepsX = lround(currentX * STEPS_PER_MM_X);
  long startStepsY = lround(currentY * STEPS_PER_MM_Y);
  long startStepsZ = lround(currentZ * STEPS_PER_MM_Z);

  long deltaX = abs(targetStepsX - startStepsX);
  long deltaY = abs(targetStepsY - startStepsY);
  long deltaZ = abs(targetStepsZ - startStepsZ);

  int dirX = (targetStepsX >= startStepsX) ? 1 : -1;
  int dirY = (targetStepsY >= startStepsY) ? 1 : -1;
  int dirZ = (targetStepsZ >= startStepsZ) ? 1 : -1;

  long maxSteps = max(deltaX, max(deltaY, deltaZ));
  if (maxSteps == 0) return;

  long errX = maxSteps / 2;
  long errY = maxSteps / 2;
  long errZ = maxSteps / 2;

  long currentDelay = (deltaZ > 0 && deltaX == 0 && deltaY == 0) ? stepDelayUS_Z : stepDelayUS_XY;

  for (long i = 0; i < maxSteps; i++) {
    errX -= deltaX;
    if (errX < 0) {
      errX += maxSteps;
      stepMotor(0, dirX);
    }

    errY -= deltaY;
    if (errY < 0) {
      errY += maxSteps;
      stepMotor(1, dirY);
    }

    errZ -= deltaZ;
    if (errZ < 0) {
      errZ += maxSteps;
      stepMotor(2, dirZ);
    }

    delayMicroseconds(currentDelay);
  }

  currentX = targetX;
  currentY = targetY;
  currentZ = targetZ;

  disableMotor(pinX);
  disableMotor(pinY);
  disableMotor(pinZ);
}

float parseValue(String line, char code, float defaultValue) {
  int index = line.indexOf(code);
  if (index == -1) return defaultValue;
  int end = index + 1;
  while (end < line.length() && (isDigit(line[end]) || line[end] == '.' || line[end] == '-')) {
    end++;
  }
  return line.substring(index + 1, end).toFloat();
}

void processGCode(String line) {
  line.trim();
  if (line.length() == 0 || line.startsWith("(")) return;

  if (line == "?") {
    Serial.print("<Idle|MPos:");
    Serial.print(currentX, 3); Serial.print(",");
    Serial.print(currentY, 3); Serial.print(",");
    Serial.print(currentZ, 3);
    Serial.println("|F:0>");
    Serial.println("ok");
    return;
  }

  if (line.startsWith("G0") || line.startsWith("G00") || line.startsWith("G1") || line.startsWith("G01")) {
    float nextX = parseValue(line, 'X', absoluteMode ? currentX : 0.0);
    float nextY = parseValue(line, 'Y', absoluteMode ? currentY : 0.0);
    float nextZ = parseValue(line, 'Z', absoluteMode ? currentZ : 0.0);

    if (!absoluteMode) {
      nextX += currentX;
      nextY += currentY;
      nextZ += currentZ;
    }

    moveTo(nextX, nextY, nextZ);
    Serial.println("ok");
  } else if (line.startsWith("G90")) {
    absoluteMode = true;
    Serial.println("ok");
  } else if (line.startsWith("G91")) {
    absoluteMode = false;
    Serial.println("ok");
  } else if (line.startsWith("G28")) {
    moveTo(0, 0, 0);
    Serial.println("ok");
  } else if (line.startsWith("G21") || line.startsWith("M3") || line.startsWith("M5") || line.startsWith("M2")) {
    Serial.println("ok");
  } else {
    Serial.println("ok");
  }
}

void setup() {
  Serial.begin(115200);

  for (int i = 0; i < 4; i++) {
    pinMode(pinX[i], OUTPUT);
    pinMode(pinY[i], OUTPUT);
    pinMode(pinZ[i], OUTPUT);
  }

  disableMotor(pinX);
  disableMotor(pinY);
  disableMotor(pinZ);

  Serial.println("CNC Plotter v7.0 - X e Y Calibrados Exatamente");
}

String inputBuffer = "";

void loop() {
  while (Serial.available() > 0) {
    char c = Serial.read();
    if (c == '\n' || c == '\r') {
      if (inputBuffer.length() > 0) {
        processGCode(inputBuffer);
        inputBuffer = "";
      }
    } else {
      inputBuffer += c;
    }
  }
}
