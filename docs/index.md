---
layout: home
title:  "Home"
section: "Home"
position: 0
---

[![Build Status](https://travis-ci.org/gem-library/gem.svg?branch=master)](https://travis-ci.org/gem-library/gem) [![codecov](https://codecov.io/gh/gem-library/gem/branch/master/graph/badge.svg)](https://codecov.io/gh/gem-library/gem)

## What is this?

The **Gmp Eigen Matrix Library** is an open source solution for high precision numerical computation in [Matlab](http://www.mathworks.com/products/matlab/) and [GNU Octave](https://www.gnu.org/software/octave/)[^1].

The library implements two data types:
 - **gem** : high precision dense matrices
 - **sgem** : high precision sparse matrices

... and overloads [**a number of Matlab/Octave functions**](docs/functions.html). The full library can be [**downloaded here**](https://github.com/gem-library/gem/releases).



## Why the GEM Library?

Few solutions out there allow working seemlessly with high precision numbers and matrices. In particular, two common shortcomings, including for Matlab's [VPA class](https://www.mathworks.com/help/symbolic/vpa.html), are:

 - Exagerated slowness
 - No support for sparse matrices

The **GEM Library** attempts to mitigates these points, thereby providing a basis for easy high precision numerical computation.

Related open source libraries include:

 - [HPF - a big decimal class](https://www.mathworks.com/matlabcentral/fileexchange/36534-hpf-a-big-decimal-class?s_tid=FX_rc1_behav) by John D'Errico
 - [Multiple precision toolbox for Matlab](https://www.mathworks.com/matlabcentral/fileexchange/6446-multiple-precision-toolbox-for-matlab) by Ben Barrowes


## What does it look like?

- On Matlab/Octave, the command `sin(pi)` returns **1.2246e-16** because computations are limited to machine precision. With the **GEM Library**, `sin(gem('pi'))` returns by **4.3348e-51**, a value compatible with the default working precision of 50 digits.

- Matrix operations such as eigenvalue decompositions are computed straightforwardly. For instance, `eig(gem([1 1; 1 -1]))` computed the eigenvalues of a 2x2 integer matrix and returns a high precision decimal expansion of $$\sqrt{2}$$.

See the [**example page**](docs/publish/examples.html) for some usage illustrations.

## How to start using the GEM Library

See the [**installation guide**](docs/installation.html).


## Documentation

Check the [**tutorial**](docs/gettingStarted.html).


## Contributors

The C++ and Matlab/Octave code of the **GEM Library** was written by [Jean-Daniel Bancal](https://github.com/jdbancal).

The library currently relies on:
 - [GMP](https://gmplib.org/) for high precision arithmetic (through [MPFR](http://www.mpfr.org/), and [MPFR C++](http://www.holoborodko.com/pavel/mpfr/) by Pavel Holoborodko)
 - [Eigen](http://eigen.tuxfamily.org/), and [Spectra](http://yixuan.cos.name/spectra/) by Yixuan Qiu for matrix manipulations
 - [MOxUnit](https://github.com/MOxUnit/MOxUnit) and [MOcov](https://github.com/MOcov/MOcov) by Nikolaas N. Oosterhof for testing and code coverage monitoring

Feedback an suggestions are welcome. Contributions are als welcome through the [**github page**](https://github.com/gem-library/gem) (see [**how to contribute**](doc/howToContribute.md)). We ask participants to follow the guidelines of the [Typelevel Code of Conduct](https://typelevel.org/conduct.html).

## License

The **GEM Library** is an open source project. It can be use freely, including for academic use and proprietary applications (with some obligations). The source code is distributed under the MPL2 license ([**more details**](https://github.com/gem-library/gem/blob/master/COPYING.md)). It comes with no guarantee.


---

Background Photo by Andrea Sonda on Unsplash

[^1]: Octave version 4.2.2 is supported. Changes introduced in version 4.4 broke the support for `classdefs`. This should be restored in the upcoming Octave 6 ([status](https://savannah.gnu.org/bugs/?56385) of the main related issue)
