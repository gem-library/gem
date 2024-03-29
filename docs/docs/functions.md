---
layout: docs
title: Available functions
position: 3
---

# {{page.title}}

Here is a list of the functions currently implemented in the **GEM Library**. The first table shows static functions which can be called without reference to a gem/sgem object. These functions allow to create a high precision matrix or to adjust some library parameters.


| function | full support | sparse support | remarks |
|----------|---|---|---|
| gem | ✔ | ✔ | gem object constructor |
| sgem | ✔ | ✔ | sparse gem object constructor |
| gemify | ✔ | ✔ | converts a matrix to gem or sgem object, preserving its sparsity |
| gem.rand / sgem.rand | ✔ | ✔ | generates high precision random numbers |
| gem.randn / sgem.randn | ✔ | ✔ | generates high precision random numbers following a gaussian distribution |
| gem.rng | ✔ | ✔ | gem.rand random seed |
| gem.workingPrecision | ✔ | ✔ | sets the working precision of the library |
| gem.displayPrecision | ✔ | ✔ | sets the precision used when displaying gem and sgem objects |
| gem.sparseLikeMatlab | ✗ | ✔ | sets whether functions not preserving zeros should be allowed to produce sparse matrices |
| make | ✔ | ✔ | compiles the library |


List of methods:
----------------

The following function can be applied to gem/sgem objects directly.

| methods | full support | sparse support | remarks |
|----------|---|---|---|
| abs  | ✔  | ✔  |   |
| all  | ✔  | ✔  |   |
| and  | ✔  | ✔  |   |
| any  | ✔  | ✔  |   |
| acos | ✔ | ✔ |  |
| acot | ✔ | ✔ |  |
| acsc | ✔ | ✔ |  |
| and | ✔ | ✔ |  |
| angle | ✔ | ✔ |  |
| asec | ✔ | ✔ |  |
| asin | ✔ | ✔ |  |
| atan | ✔ | ✔ |  |
| cat | ✔ | ✔ |  |
| cbrt | ✔ | ✔ |  |
| clean | ✗ | ✔ |  |
| ceil | ✔ | ✔ |  |
| colon | ✔ | ✔ |  |
| complex | ✔ | ✔ |  |
| cond | ✔ | ✔ |  |
| conj | ✔ | ✔ |  |
| cos | ✔ | ✔ |  |
| cot | ✔ | ✔ |  |
| csc | ✔ | ✔ |  |
| ctranspose | ✔ | ✔ |  |
| diag | ✔ | ✔ |  |
| disp | ✔ | ✔ |  |
| display | ✔ | ✔ |  |
| diff | ✔ | ✔ |  |
| double | ✔ | ✔ |  |
| eig | ✔ | ✗ |  |
| eigs | ✔ | ✔ |  |
| eps | ✔ | ✔ |  |
| end | ✔ | ✔ |  |
| eq | ✔ | ✔ |  |
| exp | ✔ | ✔ |  |
| find | ✔ | ✔ |  |
| fix | ✔ | ✔ |  |
| floor | ✔ | ✔ |  |
| full | ✔ | ✔ |  |
| ge | ✔ | ✔ |  |
| gt | ✔ | ✔ |  |
| horzcat | ✔ | ✔ |  |
| imag | ✔ | ✔ |  |
| inv | ✔ | ✔ |  |
| isempty | ✔ | ✔ |  |
| isequal | ✔ | ✔ |  |
| isequaln | ✔ | ✔ |  |
| isfinite | ✔ | ✔ |  |
| isfloat | ✔ | ✔ |  |
| ishermitian | ✔ | ✔ |  |
| isinf | ✔ | ✔ |  |
| isinteger | ✔ | ✔ |  |
| isnan | ✔ | ✔ |  |
| isnumeric | ✔ | ✔ |  |
| isreal | ✔ | ✔ |  |
| issorted | ✔ | ✔ |  |
| issparse | ✔ | ✔ |  |
| issymmetric | ✔ | ✔ |  |
| kron | ✔ | ✔ | supports more than 2 inputs, as in kron(A,B,C) or kron({A,B,C}) |
| ldivide | ✔ | ✔ |  |
| le | ✔ | ✔ |  |
| length | ✔ | ✔ |  |
| loadobj | ✔ | ✔ |  |
| log | ✔ | ✔ |  |
| log10 | ✔ | ✔ |  |
| log2 | ✔ | ✔ |  |
| logical | ✔ | ✔ |  |
| lt | ✔ | ✔ |  |
| max | ✔ | ✔ |  |
| min | ✔ | ✔ |  |
| minus | ✔ | ✔ |  |
| mldivide | ✔ | ✔ |  |
| mod | ✔ | ✔ |  |
| mpower | ✔ | ✔ | supports two scalars, or matrices with +/-1 exponent |
| mrdivide | ✔ | ✔ |  |
| mtimes | ✔ | ✔ |  |
| ne | ✔ | ✔ |  |
| nnz | ✔ | ✔ |  |
| nonzeros | ✔ | ✔ |  |
| norm | ✔ | ✔ |  |
| not | ✔ | ✔ |  |
| null | ✔ | ✗ |  |
| numel | ✔ | ✔ |  |
| num2str | ✔ | ✔ |  through matlab's implementation and sprintf |
| or | ✔ | ✔ |  |
| pinv | ✔ | ✗ |  through matlab's implementation |
| plot | ✔ | ✔ |  |
| plus | ✔ | ✔ |  |
| power | ✔ | ✔ |  |
| precision | ✔ | ✔ |  |
| prod | ✔ | ✔ |  |
| rank | ✔ | ✔ |  |
| rdivide | ✔ | ✔ |  |
| real | ✔ | ✔ |  |
| reshape | ✔ | ✔ |  |
| round | ✔ | ✔ |  |
| saveobj | ✔ | ✔ |  |
| sec | ✔ | ✔ |  |
| sign | ✔ | ✔ |  |
| sin | ✔ | ✔ |  |
| size | ✔ | ✔ |  |
| sort | ✔ | ✔ |  |
| sortrows | ✔ | ✔ |  through matlab's implementation |
| sortrowsc | ✔ | ✗ |  |
| sparse | ✔ | ✔ |  |
| sprintf | ✔ | ✔ |  currently only supports a few digits of precision; use toStrings to extract the full precision in string format |
| sqrt | ✔ | ✔ |  |
| subsasgn | ✔ | ✔ |  |
| subsref | ✔ | ✔ |  |
| sum | ✔ | ✔ |  |
| svd | ✔ | ✗ |  |
| svds | ✔ | ✔ |  |
| tan | ✔ | ✔ |  |
| times | ✔ | ✔ |  |
| toStrings | ✔ | ✔ |  |
| transpose | ✔ | ✔ |  |
| uminus | ✔ | ✔ |  |
| unique | ✔ | ✔ |  through matlab's implementation |
| uplus | ✔ | ✔ |  |
| vertcat | ✔ | ✔ |  |
| xor | ✔ | ✔ |  |

