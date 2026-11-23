# Wiring and behavior

Measured on the tested CH552G USB-C / 3.5 mm TRS board using a meter:

```
        3.5 mm TRS                         CH552G (SOP16)
      __________________
     /  TIP       -> P1.5  -------------> pin 3   Arduino 15 (z)
    |   RING      -> P1.6  -------------> pin 4   Arduino 16 (x)
    |   SLEEVE    -> GND   -------------> pin 14  Ground
     \__________________/
```

- **Released:** input reads HIGH (`INPUT_PULLUP`).
- **Pressed:** paddle bridges tip/sleeve or ring/sleeve; input reads LOW.
- Firmware uses `!digitalRead(...)` for active-LOW detection.
- The white PCB button is for **bootloader entry** when plugging into USB, not for keying.
- It is a **passive switch input**. Never apply external voltage to tip/ring; they are MCU inputs and are expected to be shorted to sleeve only.
- This wiring may differ on other devices. Check continuity and common ground, not just chip model, before flashing.

## Modes

**Hold mode:** Press -> send key down; release -> send key up. The app gets press duration (unless it relies on raw host autorepeat behavior).

**Tap mode:** Press -> 25 ms key down then release. Staying on the paddle does not cause firmware repeat. The app cannot measure held duration from this signal.

**Using the adapter as a Morse key:** This project **does not include a Morse timing/keyer engine**. It reports the two paddle contacts as PC keyboard `z` and `x`. Dits/dahs/iambic handling must be implemented by the receiving application.