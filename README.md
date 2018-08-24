# It-boots-but-that's-about-it OS

This is me learning a bit of assembly the hard way. I googled "how to write an operating system",
found [How to write a simple operating system](http://mikeos.sourceforge.net/write-your-own-os.html)
by Mike Saunders et al and am now messing around.

![Animated GIF of boots booting](https://raw.githubusercontent.com/wmhilton/boots/master/website/video1.gif)

![Running boots in the browser with v86](https://raw.githubusercontent.com/wmhilton/boots/master/website/boots_v86_sim.png)

## Dependencies

The short answer is "William's computer". Just use my computer, and you'll be fine!

Long answer is probably some combination of these:

- `qemu-system-i386` aka [qemu](http://www.qemu.org/)
- `fasm` aka [flat assembler](http://flatassembler.net/)
- Windows Subsystem for Linux (bash)
  - some stuff in Ubuntu, like `mkisofs`, `mkfs.msdos` etc

Mike's original tutorial used `nasm` but I found the code worked with `fasm` just
fine and they have a super active forum and is supposedly faster and has a cool
macro language. And just generally seems more popular with OS developers, so I'm
just following like a ~~lemur~~ lemming, whatever that metaphor is.

## How to run (in qemu)

    ./boot.sh

should open up qemu window and print something.

## How to run (in Bochs)

Make a floppy image and boot from that in Bochs.

# Building

Raw compiled assembly code:

    ./makebin.sh

A 1.44Mb floppy disk image (used by the USB step later):

    ./makefloppy.sh

A bootable ISO (untested\*):

    ./makecdrom.sh

\* Rufus refused to make a USB drive emulating a CD-ROM drive emulating a floppy drive.

## How to make a bootable USB flash drive

### Safe and slow way

- Download and run [Rufus](https://github.com/pbatard/rufus)
- Under "Device" select the USB flash drive
- Under "Create a bootable disk using" choose "DD Image"
- Click the drive icon next to DD Image and choose "myos.bin"
- Click Start. That should do it.

### Fast and scary way

- Find the exact size of the flash drive in `cat /proc/partitions`.
- Copy `.env.example` to `.env` and edit the SIZE value. This is a safety feature so
  I don't accidentally write over the wrong drive, which would be bad.

```sh
    ./makefloppy.sh
    ./makeusb.sh     # run as Administrator
```

I've found on Windows you need to be running as root (Administrator) in order
to write to the bootloader of a USB drive.
