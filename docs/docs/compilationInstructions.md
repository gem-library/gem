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
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/g++-8 8
```
It is then possible to change between GCC versions (setting it to an older version to compile binaries that Matlab can run, then restoring the native version) by running the following commands:
```
sudo update-alternatives --config gcc
sudo update-alternatives --config g++
```


Steps to compile the GEM Library on *Windows* (64 bits) :
---------------------------------------------------------

The following was only tested on Matlab.

1. Download the latest library repository either with git (see the first Ubuntu instruction above) of from the [**release page**](https://github.com/gem-library/gem/releases).
2. Install *msys* on your system from [http://mingw.org/wiki/msys](http://mingw.org/wiki/msys)
3. Launch the *MinGW Installation Manager* and install packages `mingw-developer-toolkit` and `msys-base` 
4. Download *GMP* from [https://gmplib.org/#DOWNLOAD](https://gmplib.org/#DOWNLOAD) and place it into gem's 'external' folder
5. Download *MPFR* from [http://www.mpfr.org/mpfr-current/#download](http://www.mpfr.org/mpfr-current/#download) and place it into gem's 'external' folder
6. Download *MPFR-C++* from [http://www.holoborodko.com/pavel/mpfr/](http://www.holoborodko.com/pavel/mpfr/
) and place it into gem's 'external' folder
7. Create the folder 'external/staticLibraries'
8. From within msys (launch C:\MinGW\msys\1.0\msys.bat), go into the external/gmp folder (the `C:` drive is located in `/c/`) and run the following commands:
    - ``./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries``
    - `make && make check && make install`
9. From within msys, go into the external/mpfr folder and run the following commands:
    - ``./configure --disable-shared --enable-static CFLAGS=-fPIC --with-pic --prefix=`pwd`/../staticLibraries --with-gmp=`pwd`/../staticLibraries``
    - `make && make check && make install`
10. Install the *TDM64-GCC* compiler from [http://tdm-gcc.tdragon.net/download](http://tdm-gcc.tdragon.net/download), making sure you include the component `Components/gcc/openmp` in the TDM-GCC Setup. Configure it for Matlab by typing `setenv('MW_MINGW64_LOC','C:\TDM-GCC-64')` and `mex -setup cpp` in Matlab (see [**here**](https://fr.mathworks.com/help/matlab/matlab_external/compiling-c-mex-files-with-mingw.html) for more details).
11. Download the latest *Eigen* source code on [eigen.tuxfamily.org](http://eigen.tuxfamily.org) and place it into gem's 'external' folder.
12. Download the latest version of *Spectra* on [http://yixuan.cos.name/spectra/download.html](http://yixuan.cos.name/spectra/download.html) and place it into gem's 'external' folder.
13. In Matlab, go the the gem folder and type `make(1,0)` to compile the library.
14. Note: the objects compiled in this way may require the `libgomp` library, located in `C:\TDM-GCC-64\bin\libgomp_64-1.dll`. To make your compilation portable, copy this file into the gem subfolder.
15. Add the gem subfolder to your Matlab/Octave path as described [**here**](installation.html). You can now perform your favorite computation in high precision!


Steps to compile the GEM Library on *macOS* (tested on high sierra 10.13.2) :
-----------------------------------------------------------------------------

### Instructions for Octave
These instructions were tested for a version of Octave installed as an [App Bundle](https://octave-app.org/Download.html).

1. Download the latest library repository with the following command: `git clone --recursive https://www.github.com/gem-library/gem`. This creates a folder called `gem`.
2. Download *GMP* from [https://gmplib.org/#DOWNLOAD](https://gmplib.org/#DOWNLOAD) and place it into gem's 'external' folder
3. Download *MPFR* from [http://www.mpfr.org/mpfr-current/#download](http://www.mpfr.org/mpfr-current/#download) and place it into gem's 'external' folder
4. Download *MPFR-C++* from [http://www.holoborodko.com/pavel/mpfr/](http://www.holoborodko.com/pavel/mpfr/
) and place it into gem's 'external' folder
5. Start Octave and go to the gem folder.
6. Type `make(1,0)`. This will launch the compilation of the library. If everything goes fine, the program will conclude with the message '**Compilation successful**'. Otherwise, a message should inform you about what is missing.
7. Add the gem subfolder to your Octave path as described [**here**](installation.html). You can now perform your favorite computation in high precision!


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
