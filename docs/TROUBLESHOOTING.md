# Troubleshooting

## No keyboard events on Windows, but works on phone/Linux

On the tested adapter, firmware sent valid HID reports on Android and Linux, but Windows initially created a HID Keyboard Device without typing. **Rebooting Windows with the adapter unplugged, then plugging it in, fixed it.** Avoid rewriting known-working firmware or globally removing Windows HID drivers before trying this.

## Windows sees USB Input Device / HID Keyboard Device but no COM port

**Expected**. This project uses a **keyboard-only** USB interface. The original factory adapter exposed a composite CDC serial interface, which this firmware does not.

## WCHISPTool cannot see the board

- Enter bootloader: unplug -> hold white button -> plug in -> keep holding through detection.
- Check device ID `4348:55E0` while in bootloader (not `1209:C55E`).
- If Zadig was used, restore the manufacturer's `CH375_A64` driver for the **bootloader** device so WCHISPTool can open it. Avoid changing unrelated drivers.
- Use a data-capable cable, and another USB port if needed.

## Arduino says `This example needs to be compiled with a USER USB setting`

Set Tools > USB Settings to **USER CODE w/ 148B USB RAM** in the active `Morse_Code.ino` window. Confirm Board = **CH552 Board**.

## Compiler cannot find `include/ch5xx.h` or `usbCommonDescriptors/...`

The six USB override files are not a standalone core. Use `tools/Prepare-Sketch.ps1` (Windows) or `tools/prepare-sketch.sh` (Linux) to copy the complete CH55xDuino example `src` tree before applying our overrides. Or follow README manual preparation.

## Keys swapped or no response

- This board was measured: tip=P1.5/Arduino 15 (`z`), ring=P1.6/Arduino 16 (`x`), sleeve=GND.
- Confirm input goes LOW when the paddle closes to sleeve. Test with a 3.5 mm plug and a continuity meter.
- If tip/ring swapped on your board, swap the `'z'` and `'x'` assignments in the sketch.
- **No automatic `zxzx` output** should occur with the normal paddle sketch, because the diagnostic timer sketch is not the release firmware.

## Key repeats when a paddle is held

Normal Windows keyboard repeat happens when a HID key is kept down. Use the **tap** variant only for apps that want edge-triggered taps; for CW trainers that time the held paddle, keep the **hold** variant and have the app ignore repeated keydown events (e.g. JavaScript `KeyboardEvent.repeat`). Standard HID keyboards cannot make Windows hold a key and simultaneously disable the OS-wide repeat policy just for that key.

## Firmware safety

Firmware uploads replace existing application firmware. A separate CH552 ROM bootloader normally remains available on the tested board, but never assume every clone PCB implements BOOT or reset identically. If you need the original firmware, back it up before flashing; we do not distribute the original vendor firmware.