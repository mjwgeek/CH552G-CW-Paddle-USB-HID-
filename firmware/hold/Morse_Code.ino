/*
  CH552G CW Paddle -> USB HID Keyboard (hold mode)

  TRS tip    -> P1.5 / Arduino pin 15 -> z
  TRS ring   -> P1.6 / Arduino pin 16 -> x
  TRS sleeve -> GND

  Switches short tip/ring to sleeve when pressed (active LOW).
  Sends HID key DOWN on press and key UP on release.

  Based on the CH55xDuino HID Keyboard example by Deqing Sun.
*/

#ifndef USER_USB_RAM
#error "Select USB Settings: USER CODE w/ 148B USB RAM"
#endif

#include "src/userUsbHidKeyboard/USBHIDKeyboard.h"

#define TIP_PIN 15
#define RING_PIN 16

bool tipWasPressed = false;
bool ringWasPressed = false;

void setup() {
  USBInit();
  pinMode(TIP_PIN, INPUT_PULLUP);
  pinMode(RING_PIN, INPUT_PULLUP);
  Keyboard_releaseAll();
}

void loop() {
  bool tipPressed = !digitalRead(TIP_PIN);
  bool ringPressed = !digitalRead(RING_PIN);

  if (tipPressed != tipWasPressed) {
    tipWasPressed = tipPressed;
    if (tipPressed) {
      Keyboard_press('z');
    } else {
      Keyboard_release('z');
    }
  }

  if (ringPressed != ringWasPressed) {
    ringWasPressed = ringPressed;
    if (ringPressed) {
      Keyboard_press('x');
    } else {
      Keyboard_release('x');
    }
  }

  delay(2);
}
