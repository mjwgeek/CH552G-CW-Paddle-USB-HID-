/*
  CH552G CW Paddle -> USB HID Keyboard (one-tap mode)

  TRS tip    -> P1.5 / Arduino pin 15 -> one z tap
  TRS ring   -> P1.6 / Arduino pin 16 -> one x tap
  TRS sleeve -> GND

  The host sees a short press/release per physical actuation.
  It does NOT retain the paddle's held state; not for trainers that
  measure dit/dah timing using key-down duration.

  Alternative sketch; hardware validation pending.
*/

#ifndef USER_USB_RAM
#error "Select USB Settings: USER CODE w/ 148B USB RAM"
#endif

#include "src/userUsbHidKeyboard/USBHIDKeyboard.h"

#define TIP_PIN 15
#define RING_PIN 16

bool tipWasPressed = false;
bool ringWasPressed = false;

void tapKey(char k) {
  Keyboard_press(k);
  delay(25);
  Keyboard_release(k);
}

void setup() {
  USBInit();
  pinMode(TIP_PIN, INPUT_PULLUP);
  pinMode(RING_PIN, INPUT_PULLUP);
  Keyboard_releaseAll();
}

void loop() {
  bool tipPressed = !digitalRead(TIP_PIN);
  bool ringPressed = !digitalRead(RING_PIN);

  if (tipPressed && !tipWasPressed) {
    tapKey('z');
  }

  if (ringPressed && !ringWasPressed) {
    tapKey('x');
  }

  tipWasPressed = tipPressed;
  ringWasPressed = ringPressed;
  delay(2);
}
