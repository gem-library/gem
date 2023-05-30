---
layout: docs
title: Compilation instructions
position: 5
---

How to compile the GEM Library
==============================

The **GEM Library** can be downloaded and installed without compilation on most platforms, as described in the [**installation**](installation.html) section. It is however also possible to compile the library from scratch. This document describes how to do that on various platforms.


Steps to compile the GEM Library on *Ubuntu* :
----------------------------------------------

The following steps work equally well for Matlab and Octave, except if you are using Octave within a closed environment such as [flatpak](https://flathub.org/apps/details/org.octave.Octave). In this case, follow the "macOS" section below.

1. Download the latest library repository with the following command: `git clone --recursive https://www.github.com/gem-library/gem`. This creates a folder called `gem`.
2. Install the *gmp*, *mpfr* and *mpfrc++* libraries with the command
`sudo apt install libmpfrc++-dev libgmp-dev`
3. Start Matlab or Octave and go to the gem folder.
4. Type `make`. This will launch the compilation of the library. If everything goes fine, the program will conclude with the message '**Compilation successful**'. Otherwise, a message should inform you about what is missing.
5. Add the gem subfolder to your Matlab/Octave path as described [**here**](installation.html). You can now perform your favorite computation in high precision!

### Note on the compiler version

Matlab uses its own version of `libstdc++` at runtime, which is typically behind the version provided by the latest [`g++`](https://gcc.gnu.org/onlinedocs/libstdc++/manual/abi.html). Ubuntu is generarally more up to date, and may thus compile binaries that Matlab is unable to run. A simple way to fix this situation, when it happens, consists in installing an older version of GCC on ubuntu with the following commands (the version of `libstdc++` shipped with latest Matlab is compatible with GCC 8):
```
sudo apt install gcc-8 g++-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/g++-8 8
```
In order to still be able to use the native compiler version, the last two lines should also be executed with the latest version, e.g. GCC 9 if on Ubuntu 20.04:
```
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/g++-9 9
```
It is then possible to change between GCC versions (setting it to an older version to compile binaries that Matlab can run, then restoring the native version) by running the following commands:
```
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```


Steps to compile the GEM Library on *Windows* (64 bits) :
---------------------------------------------------------

The following was only tested on Matlab.


1. In Matlab's Add-Ons, install the **MinGW** compiler (called "MATLAB Support for MinGW-w64 C/C++ Compiler")
2. Install MSYS version 1 (can be downloaded from [here](https://sourceforge.net/projects/mingw/files/MSYS/Base/msys-core/msys-1.0.11/MSYS-1.0.11.exe/download)). When asked whether you already have a C++ compiler, answer yes and provide the directory matlab's MinGW compiler (e.g. 'c:/ProgramData/MATLAB/SupportPackages/R2023a/3P.instrset/mingw_w64.instrset').
3. Launch the MSYS terminal and go to a local folder (likely located in `/c/Users/...`)
4. Download the latest library repository with the following command: `git clone --recursive https://www.github.com/gem-library/gem`. This creates a folder called `gem`.
5. Move to the `gem/external/gmp` subfolder and compile the *GMP* library with the following commands:
    - ``./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries/windows``
    - `make && make check && make install`
6. Move to the `gem/external/mpfr` subfolder and compile the *MPFR* library with the following commands:
    - ``./autogen.sh``
    - ``./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries/windows --with-gmp=`pwd`/../staticLibraries/windows``
    - `make && make check && make install`
7. Launch matlab and verify that it is configured to use the MinGW compiler with the command `mex -setup cpp`
6. Move to the gem folder and type `make(1,0)` to compile the library.
7. Add the gem subfolder to your Matlab/Octave path as described [**here**](installation.html). You can now perform your favorite computation in high precision!



Steps to compile the GEM Library on *macOS* (tested on high sierra 10.13.2) :
-----------------------------------------------------------------------------

### Instructions for Octave
These instructions were tested for a version of Octave installed as an [App Bundle](https://octave-app.org/Download.html).

1. Download the latest library repository with the following command: `git clone --recursive https://www.github.com/gem-library/gem`. This creates a folder called `gem`.
2. Start Octave and go to the gem folder.
3. Type `make(1,0)`. This will launch the compilation of the library. If everything goes fine, the program will conclude with the message '**Compilation successful**'. Otherwise, a message should inform you about what is missing.
4. Add the gem subfolder to your Octave path as described [**here**](installation.html). You can now perform your favorite computation in high precision!


### Instructions for Matlab

Tentative roadmap:

1. Install *Xcode* and the *Xcode command line tools*.
2. Install [Homebrew](https://brew.sh/)
3. Add the Homebrew path in priority by adding the line `export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"` in `~/.bashrc`
4. Install *gcc* through homebrew with `brew install gcc` (you may also consider installing a few [additional packages](https://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/))
5. Add reference to gcc and g++ in the folder /usr/local/bin with `ln -s gcc-9 gcc` and `ln -s g++-9 g++`
6. Download the latest library repository with the following command: `git clone --recursive https://www.github.com/gem-library/gem`. This creates a folder called `gem`.
7. Download *GMP* from [https://gmplib.org/#DOWNLOAD](https://gmplib.org/#DOWNLOAD) and place it into gem's 'external' folder
8. Download *MPFR* from [http://www.mpfr.org/mpfr-current/#download](http://www.mpfr.org/mpfr-current/#download) and place it into gem's 'external' folder
9. Download *MPFR-C++* from [http://www.holoborodko.com/pavel/mpfr/](http://www.holoborodko.com/pavel/mpfr/
) and place it into gem's 'external' folder6. Launch Matlab from the terminal, so that /usr/local/bin is the first folder looked for when running `unix(‘which g++’)` in Matlab
10. Launch Matlab from a terminal with the command `/Applications/MATLAB2020a/bin/matlab`. The command `unix(which g++')` should return `/usr/local/bin/g++`.
11. Type `mex -setup` to ensure Matlab found a working compiler
12. Type `make(1,0)` from  within the gem folder (or `make(0,0)` to create a portable library)
13. Add the gem subfolder to your Matlab path as described [**here**](installation.html). You can now perform your favorite computation in high precision!


Failsafe mode
----------------

Because every system installation is different... When calling the command `make` from within Matlab/Octave, setting the third option `genericBuild` to `1` triggers the build with a simple function, which might help to avoid configuration-related troubles in some situations. This compilation procedure is slower, and can produce surprising results such as ~100Mb output files.
