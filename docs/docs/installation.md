---
layout: docs
title: Installation
position: 1
---

# {{page.title}}

This page presents how to get going with the **GEM Library**. The easiest way to do so is by downloading the release package, as described in the [first section below](#installing-a-release). It is also possible to install the library from the source code as described in the [second section](#installing-from-source).

## Installing a release

The release includes binaries for Matlab on Linux, Windows and MacOS, as well as for Octave 4.2 on Linux. After [**downloading the latest release**](https://github.com/gem-library/gem/releases) of the library, uncompress it in a `desired_folder`. This created the folder `desired_folder/gem`.

### Setting up the path

The only step required to start using the libraries is to include the subfolder `desired_folder/gem/gem` to the Matlab/Octave path. This is achieved by running the command

```
addpath('desired_folder/gem/gem')
```

You can then follow the [**tutorial**](gettingStarted.html).


## Installing from source

Installing the **GEM library** from source can be useful or for development purpose. For this:

- Clone the library from GitHub using the command:

```
git clone --recursive https://www.github.com/gem-library/gem
```

This creates a folder **gem** with most of the necessary code (including Eigen, Spectra, MOxUnit and MOcov). To compile the library, follow the [**detailed instructions**](compilationInstructions.html). Once the library is compiled, proceed with the following steps.


### Setting up the path

To use the **GEM Library**, the `gem/gem` subfolder must be added in Matlab/Octave. This can be done through the command `addpath` as described above.


### Testing

The proper working of the **GEM Library** can be checked by running the test command:

```
run_tests
```

This runs a check on all features of the library.


### Compiling the documentation

The documentation can be compiled with the command

```
compile_doc
```

### Running the documentation locally

The documentation website can be run on a local machine thanks to Jekyll. For this, install `jekyll` and `bundle` as explained on the [**Jekyll website**](https://jekyllrb.com). Then run

```
bundle exec jekyll serve
```

from within the `docs` subfolder. This command should provide you an IP address on which you can consult the website.
