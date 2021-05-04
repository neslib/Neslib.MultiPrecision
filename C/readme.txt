Building the QD library for use with Delphi
===========================================

Uses QD 2.3.22 (https://www.davidhbailey.com/dhbsoftware/)

This directory contains a custom version of the QD library, more suitable for
use from Delphi.

Compile for Windows
-------------------
* Install 64-bit MinGW with at least support for mingw32-gcc and mingw32-gcc-g++
  https://sourceforge.net/projects/mingw-w64/files/mingw-w64/
* Add the MinGW\Bin directory to the path, or for temporary path addition:
  >set PATH=%PATH%;c:\MinGW64\mingw64\bin\
* Run BuildX86.bat and BuildX64.bat

Explaination of gcc command line options used:
* -m32: build 32-bit object file
* -m64: build 64-bit object file
* -c: compile only (do not link)
* -o: name of output file
* -I: add include directory to search path
* -Wno-attributes: ignore warning "'regparm' attribute only applies to function
   types". This warning happens because the calling convention define (QD_API)
   is not only applied to functions, but to structs as well.
* -mfpmath=sse: use SSE instead of FPU for floating-point math (only needed for
   Intel 32-bit)
* -msse2: use SSE2 (which supports double-precision math)
* -O3: full optimization
* -mincoming-stack-boundary=2: assumes the stack is aligned on a 2^2=4 byte
   boundary when a function in the object file is called. Some functions in the
   object file require that the stack is aligned to a 16 byte boundary, but
   Delphi only aligns to 4 byte boundaries on Intel 32-bit. With this option,
   extra code is added in the object file to make sure the stack is aligned
   to a 16 byte boundary. This is not needed for 64-bit, since the stack is
   required to be aligned on 16 byte boundaries then.
* -Xassembler -L: passes -L to the assembler. This keeps any local symbols in
   the object file (such as data containing floating-point constants). Without
   this, the object file would try to load that data from address 0, leading to
   an AV
   
Compile for Android
-------------------
* Make sure you have a recent version of the Android NDK installed.
* Open the BuildAndroid.bat file in a text editor.
* Modify the NDK_BUILD variable to point to the location of the ndk-build.cmd
  file in your NDK directory.
* Run the batch file

Build for macOS and iOS
-----------------------
* Make this directory available on a Mac (either as a share or by copying it).
* Open a terminal window and run:
  > ./BuildIOS.sh
  > ./BuildMacOS.sh  