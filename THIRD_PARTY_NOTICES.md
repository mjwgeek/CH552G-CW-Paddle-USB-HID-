# Third-party notices

The files in `usb-overrides/userUsbHidKeyboard/` are modifications of files from the
`HidKeyboard` example distributed in Deqing Sun's [CH55xDuino](https://github.com/DeqingSun/ch55xduino)
project (upstream repository: `DeqingSun/ch55xduino`, branch `ch55xduino`).

Upstream project's repository identifies its license as **LGPL-2.1**. The license
text is preserved in `LICENSES/LGPL-2.1.txt` and applies to the copied/modified
CH55xDuino source files. The repository's own paddle sketches, docs, and scripts
are distributed separately under MIT.

Local changes in the USB overrides relative to the example files supplied by
the user:

- `USBconstant.c`: uses PID `0xC55E` for this hobby keyboard, and replaces the
  report descriptor with a standard 63-byte USB HID boot keyboard descriptor.
- The other five files are included from the user's example copy to make
  reproduction straightforward. Their original EP1 DMA buffer offset
  (`Ep1Buffer[64+i]`) and endpoint TX/RX mode (`UEP4_1_MOD = 0xC0`) are preserved.

The other CH55xDuino example dependencies (`include/`, `usbCommonDescriptors/`)
are copied from each user's locally installed CH55xDuino board package by the
preparation script; they are not vendored in this repo.

WCHISPTool is made by WCH and is not redistributed here.
