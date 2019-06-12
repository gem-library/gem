---
layout: docs
title: Installation
position: 1
---

# {{page.title}}

This chapter explains the basics to get working with the **GEM Library**. We start with the standard method. A step by step method to do everything by hand is also described [below](#Alternate-method).

## Standard method

After downloading the [**latest**](https://github.com/gem-library/gem/releases) version of the library, uncompress it in a `desired_folder`. This created the folder `desired_folder/gem`. The release contains binaries for most version of Matlab on Linux, Windows and MacOS, as well as Linux binaries for Octave 4.2.

### Setting up the path

The only step required to start using the libraries is to include the subfolder `desired_folder/gem/gem` to the Matlab/Octave path. This is achieved by running the command

```
addpath('desired_folder/gem/gem')
```

You can then follow the [**tutorial**](gettingStarted.html).


## Installing from source

You can also install the **GEM library** from the source code. This is useful for development purpose. For this:

- Clone the library from GitHub using the following commands:

```
git clone https://www.github.com/gem-library/gem
cd gem
git submodules update --init
```

This will create a folder **gem** with most of the necessary code (including Eigen, Spectra, MOxUnit and MOcov). To compile the library, follow the detailed instructions given [here](compilationInstructions.html). Once the library is compiled, you can try the following


### Setting up the path

To use the **GEM Library**, the `gem` subfolder must be added in Matlab/Octave. This can be done through the command `addpath` as described above.


### Testing

The proper installation of the **GEM Library** can be checked by running the test command:

```
run_tests
```

This checks the proper working of the whole package.


### Compiling the documentation

The documentation can be compiled with the command

```
compile_doc
```
