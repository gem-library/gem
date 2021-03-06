---
layout: docs
title: How to contribute
position: 4
---

# {{page.title}}

This page presents some useful information for contributing to the **GEM Library**.


## Workflow

As usual with git projects, improvements to the code should be performed on a fork of the github repository, from which a pull request to the main repository can be done. If this procedure is new to you, check out [**available resources**](https://guides.github.com/activities/forking/) on how to start collaborating with git. In case you are wondering what kind of features could be still worth implementing in the library, a few ideas are listed at the [**end**](#desired-features) of this file.


## General code structure

Part of the source code of the **GEM Library** is written in Matlab/Octave and part is in C++. The C++ code is used for efficiency puspose, while the Matlab/Octave code is used for interface purpose and for higher-level programming.

Overall, the code is structured in 4 levels:

1. C++ methods in `src/gem.cpp` and `src/sgem.cpp` (plus the corresponding header files). This code is doing the actual job. Each full and sparse implementation (if applicable) is always provided in two forms:
    - as a function like `abs()` providing the ouput as an object
    - as a function like `abs_new()` providing the output as a reference to a new object

2. C++ files `src/gem_mex.cpp` and `src/sgem_mex.cpp`. These serve as dispatchers: receiving the direct instructions from Matlab/Octave, they instantiate the necessary objects and call the underlying C++ methods.
3. Methods in the folders `gem/@gem` and `gem/@sgem`. These are part of the definition of the `gem` and `sgem` classes which are run by Matlab/Octave directly. They can access the C++ functionalities through the function `gem_mex` and `sgem_mex`.
4. Test functions in the folder `tests` (each filename finishes with '_test.m'). Each of these functions is responsible for testing the proper behavior of the corresponding class method.

Every feature appears in all 4 levels. For instance, the code corresponding to the `abs` function is constituted of the following files/methods:

1. The `GmpEigenMatrix abs() const;`, `GmpEigenMatrix& abs_new() const;` in `src/gem.hpp` and `SparseGmpEigenMatrix abs() const;`, `SparseGmpEigenMatrix& abs_new() const;` in `src/sgem.hpp`. These functions perform the operation `abs` on the high precision C++ data structures.
2. The `if (!strcmp("abs", cmd))` clauses in `src/gem_mex.cpp` and `src/sgem_mex.cpp`. These receive the calls from Matlab/Octave.
3. `gem/gem/abs.m` and `gem/sgem/abs.m` are the `abs` Matlab/Octave methods for full and sparse objects respectively
4. The files `tests/gem/abs_test.m` and `tests/sgem/abs_test.m` test this functionality on `gem` and `sgem` objects


## Step by step implementation of a new functionality

Here is a guideline of the steps to follow to implement a new functionality. As mentioned earlier, it is best to do this on a forked version of the source code.

 - First of all, identify some general feature of the considered function:
    - How many parameters does the function depends on? Which of these parameters can be gem objects, which ones must be indices? If the function takes several gem parameters as inputs, do they all need to be of the same size, or can the function mix matrices and scalars?
    - How many outputs does this function produce? Which ones are gem objects or indices/doubles?
    - Does the function preserve sparsity? (i.e. are there sparse inputs which can produce sparse outputs? This is not the case of the cosine functions, for instance.)
 - Identify an existing gem function which has identical or similar properties (e.g. `tan(x)` is similar to `sin(x)`, `plus(x,y)` is _not_ similar to `find(x)`), and read the code related to this function (both the Matlab/Octave and C++ code in the four layers mentioned above).
 - Copy this function and rename it according to the new function. It can be helpful to this this first for the first three code layers and for dense objects only, i.e. in files `src/gem.hpp`, `src/gem.cpp`, `src/gem_mex.cpp` and in the `@gem` folder.
 - Now these new pieces of code can be modified to implement the new function.
 - Compile the code and test it.
 - It should now be straightforward to implement the function for sparse matrices as well by copying and modifying the files `src/sgem.hpp`, `src/sgem.cpp`, `src/sgem_mex.cpp` and the `@sgem` folder. Note that if the function never preserves sparsity, no modification of the src folder is required at this stage. Matlab code in the `@sgem` folder should be sufficient.
 - Compile and check the code written for sparse matrices.
 - Make sure that the code has a minimal amount of help information (including e.g. a usage example) and that it contains a few helpful comments that explain what is happening.
 - Add tests dedicated to this new function in the folders `tests/gem` and `tests/sgem`. Check that the tests are passed by the implementation. (Of course, if you are a fan of test-driven development, you could also start by writing the tests, but this might might be the easiest way to proceed the first time.)
 - When all is fine, send a pull request on github to add a new feature to the library!


## Further design considerations

- By default, truly sparse operations are implemented if there is a chance that the result of the operation applied to a sparse matrix produces a sparse result. This diverges from matlab's default behavior. However, matlab's default behavior can be restored through the function 'gem.sparseLikeMatlab'.

   This means that `sin(x)` has a sparse implementation, but not `cos(x)` (`sin(0) = 0`, but `cos(0)` is not `0`). The implementation of the cosine function for sparse objects thus starts by a casting of the input into a full matrix, before calling the full implementation of the cosine function (see `@sgem/cos.m` for an example). Also the matrix inverse function `inv(X)` admits a sparse implementation, even though the inverse of most sparse matrices is not sparse. This is because there exist sparse matrices X whose inverse is also sparse (e.g. `X = eye(d)`).

- The library uses the data type *mpreal* provided by the mpfrc++ library. Therefore, it deals with complex numbers by itself, storing the real and imaginary components of complex objects in two different matrices. In particular, all interactions with the Eigen library involve purely real numbers.

   According to http://www.holoborodko.com/pavel/mpfr/ (c.f. comment from April 20, 2016), relying on `std::complex` is risky, because several algorithms assume that `std::complex` comes with double precision, hence leading to a loss of precision. Since the complex algebra is contained in the matrix algebra, complex operations can be implemented as matrix operations.

- The fact that the library interfaces with Matlab/Octave requires a dynamical allocation of objects. This is taken care of by a class adapted from [this C++ class interface](https://fr.mathworks.com/matlabcentral/fileexchange/38964-example-matlab-class-wrapper-for-a-c++-class). One consequence of this approach is that most methods in the C++ code have two variants (as mentioned above) :
  - `method` which performs the required computation and returns the result in a static variable (this variable is cleared once the library returns to matlab).
  - `method_new` which performs the same operation but returns the result in a dynamic variable (this variable remains in memory between to calls from matlab).

  Apart from the difference variable definition, both functions should be strictly identical.

- The Matlab/Octave code is responsible of performing all parameters checks before calling the C++ library. So for instance it must check that the size of two matrices are compatible before asking the C++ library to multiply these matrices. No such checks should be expected to be performed on the C++ side. This allows to make the C++ code, which gets anyway easily complex, more transparent and lighter.


## Desired Features

Here is a partial list of features/functions that would be nice to add to the library.

 - Improve the function `sprintf` to return all digits
 - Implement the matrix `mpower` function for powers different from +/-1.
 - Implement the matrix exponential function `expm`
 - Implement the function `triu`, `tril`
 - Implement the Beta special functions: `beta`, `betainv`, `betainc`, `betaincinv`
 - Implement the factorial functions: `factorial`, `nchoosek`
 - Parallelize the for loops appearing in simple functions such as `sin`.
 - Refactor the code to avoid code duplication
 - Rely on the new high precision c++ library [MP++](https://github.com/bluescarni/mppp/) rather than [MPFR C++](https://github.com/advanpix/mpreal). This could easily give access to faster quadruple-precision types as well.
 - Systematically check the behavior of functions on `NaN`, `-Inf`, `Inf`
 - Define a strategy for empty matrices of various sizes, i.e. difference between 0x0, 1x0, 10x0, 0x1, ... empty matrices. Implement the behavior of all functions on these objects and implement the corresponding tests.
 - For more ways to contribute, have a look at the [**open issues**](http://github.com/gem-library/gem/issues)

