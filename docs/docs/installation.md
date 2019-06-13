---
layout: docs
title: Installation
position: 1
---

# {{page.title}}

This page presents how to get going with the **GEM Library**. Most users would consider installing the library from the binary release. The release contains binaries for most version of Matlab on Linux, Windows and MacOS, as well as Linux binaries for Octave 4.2. The first section explains how to do this. A full step by step procedure is [then](#installing-from-source) also described to install the full library from the source code.

## Installing a release

After downloading the [**latest**](https://github.com/gem-library/gem/releases) version of the library, uncompress it in a `desired_folder`. This created the folder `desired_folder/gem`.

### Setting up the path

The only step required to start using the libraries is to include the subfolder `desired_folder/gem/gem` to the Matlab/Octave path. This is achieved by running the command

```
addpath('desired_folder/gem/gem')
```

You can then follow the [**tutorial**](gettingStarted.html).


## Installing from source

You can also install the **GEM library** from the source code. This can be useful for development purpose. For this:

- Clone the library from GitHub using the following commands:

```
git clone https://www.github.com/gem-library/gem
cd gem
git submodules update --init
```

This creates a folder **gem** with most of the necessary code (including Eigen, Spectra, MOxUnit and MOcov). To compile the library, follow the [**detailed instructions**](compilationInstructions.html). Once the library is compiled, proceed with the following steps.


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

### Running the documentation locally

The documentation website can be run on a local machine thanks to the Jekyll. For this, install `jekyll` and `bundle` as explained on the [**Jekyll website**](https://jekyllrb.com). Then run

```
bundle exec jekyll serve
```

from within the `docs` subfolder. This command should provide you an IP address on which you can consult the website.
