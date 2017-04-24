# It-boots-but-that's-about-it OS

This is me learning a bit of assembly the hard way. I googled "how to write an operating system",
found [How to write a simple operating system](http://mikeos.sourceforge.net/write-your-own-os.html)
by Mike Saunders et al and am now messing around.

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
just following like a lemur.

## How to run (in qemu)

build it:

    make

should generate `myos.iso`.

run it:

    ./boot

should open up qemu window and print something.

## How to boot from USB stick

I will find out soon and let you know.
Edit: I got it to work by running `dd if=myos.img of=/dev/sd[c1 in my case but yours will be different]` in Git Bash.
