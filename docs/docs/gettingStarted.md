---
layout: docs
title: Getting started
position: 2
---

# {{page.title}}

Here is a short introduction to the usage of **GEM Library**. This introduction assumes that the gem subfolder is already present in Matlab/Octave's path (see [**installation instructions**](installation.html) for more details).

## Creating High Precision Matrices

### Dense matrices

A matrix for high precision computation can be created from any Matlab/Octave matrix by calling the `gem` constructor.
 - `a = gem([1 2; 3 4+5i])`
 
     is a 2x2 gem object. This matrix can be manipulated like a conventional matrix. For instance, `a(2,2)` extracts the (2,2) element of the matrix: `4+5i`.

When constructing a gem object from a double-precision matrix, the first 15 digits of each component are taken into account and completed by trailing zeros (up to the precision of the gem object). This garantees that all numbers are transfered in a predictable manner, and that integers remain integers after conversion.

High precision objects can also be constructed by specifying all digits in a string. Numbers with more than 15 digits precision can be defined in this way, as in:
 - `gem('1.93754981629874513245725542343')`

    creates a 1x1 matrix (i.e. a scalar) with 30 non-trivial digits, the remaining digits being set to zeros.

When creating a number from a string which contains more digits than the default working precision defined by `gem.workingPrecision`, the precision of the created number is automatically adjusted to hold all specified digits. Therefore:
 - `precision(gem('1249087124971234.43728901872387540876540921694461877239047122'))`
 
     is `60` even if the current working precision is `50`.

All elements of a matrix can be individually initialized to an arbitrary precision by calling the constructor `gem` with a cell array containing the corresponding strings:
 - `gem({'1.321321123123321123' '456.4566544566544564'; '0.789987987789987789' '369.639369366963936'})`


### Sparse matrices

Just like in the case of dense matrices, sparse Matlab/Octave matrix are easily transfered to sparse gem object by calling the `sgem` constructor:
 - `sgem(speye(3))`
 
     is a sparse 3x3 identity matrix.

Sgem object can also be constructed by calling the `sparse(i,j,s,m,n)` function with a `gem` vector `s`:
 - `sparse([1 2], [1 3], gem({'123.45678901234567890' '987.653210987654321'}), 3, 3)`
 
     is a sparse matrix with two high precision components
 
 ... or by directly calling the constructor `sgem` in the same way:
 - `sgem([1 2], [1 3], [123 987]}), 3, 3)`
 
     is a sparse matrix with two high precision integer components
 
More generally, high precision objects can be constructed from either full or sparse Matlab/Octave matrices by calling the `gemify` function. When provided a full matrix, this function creates a `gem` object, when provided a sparse argument, it produces an `sgem` object.


### Special values

The following mathematical constants can be constructed explicitly
 - `gem('pi')` is 3.14159265...
 - `gem('e')` is 2.7182818...
 - `gem('log2')` is 0.69314718...
 - `gem('euler')` is 0.57721566...
 - `gem('catalan')` is 0.91596559...


## Precision

### Working precision

The **GEM Library** works with high precision numbers. The precision of these numbers is defined by the number of digits that are used to describe them (in basis 10). By default, the library takes into account 50 digits. This means that it can distinguish between numbers that differ at the 50th decimal place:
 - In double precision `(pi/10) - (pi/10 - 1e-17)` yields

        0

    but `(gem('pi')/10) - (gem('pi')/10 - 1e-50)` is

        1e-50 *

         1.0691058840368782585

The precision at which the **GEM Library** works can be adjusted throught the function `gem.workingPrecision`. Alternatively, it can be passed as a parameter when creating a `gem` object:
 - `gem(3.141592654,3)` yields just 

        3.14

    (the remaining digits are ignored)

When creating a `gem` object from a double, at most 15 digits are taken into account. When using strings of digits to specify a number, the precision is automatically adjusted to guarantee that all provided digits are taken into account, unless explicitely stated:
 - `gem('123456789012345678901234567890123456789012345678901234567891') - gem('123456789012345678901234567890123456789012345678901234567890')` produces the result

        1

    even though the relative difference, of the order of 1e-60, is smaller than the default working precision. The precision used here for the difference included all provided digits.

 - `gem('1234567890',3) - gem('1234567891',3)` produces

        0

    because the three first digits of both numbers are equal.

Note that the accuracy of the result of an operation is not only determined by the number of decimals used to define numbers, but it may also depend on the [number of elementary manipulations](https://en.wikipedia.org/wiki/Numerical_error) used to produce the result.

The `precision` function can be used to determine how many digits are used to describe a particular number. For instance,
 - `precision(gem('3.2'))` is

        50

    `precision(gem('123456789012345678901234567890123456789012345678901234567891'))` is

        60

    and `precision(gem('e',5))` is

        5


### Display precision

Printing long strings of digits can quickly become cumbersome. Therefore, only part of a high precision number is displayed by default. Even though all significant digits are not systematically printed, they are indeed kept in memory and used in the computations. The function `gem.displayPrecision` can be used to adjust the number of digits to be displayed by default. Alternatively, the display precision can also be directly specified as a second argument of the `disp` or `display` functions:
 - `disp(gem('pi'),50)` prints 50 digits:

        3.1415926535897932384626433832795028841971693993751

A *negative* display precision prints out all digits in memory:
 - `disp(gem('pi'),-1)` prints the same 50 digits as above.



## Functions

A list of the functions that can be applied to `gem` and `sgem` objects is available [**here**](functions.html). In general, these functions take the same arguments as their Matlab/Octave counterparts, and behave in the same way. For instance, the `max` function applied to a vector containing two complex numbers returns the complex number with largest magnitude, or the one with largest angle if both magnitudes are equal.

For some functions, all possible behaviors are not yet implemented. For instance, `mpower` currently only supports powers of +1 and -1. Anyone interested in a specific feature is invited to open an [**issue**](https://github.com/gem-library/gem/issues), and eventually consider contributing to this open source project by implementing some missing functionality and submitting a push request (please refer to [**this page**](howToContribute.html) for more ways to get involved).

Note that the default behavior of some `gem` functions does differ marginally from Matlab's implementation. This is the case for example for functions which don't preserve the sparsity when applied to sparse objects. This point is explained in the file `@gem/sparseLikeMatlab.m`. The default Matlab behavior is easily restored by calling `gem.sparseLikeMatlab(1)`.

