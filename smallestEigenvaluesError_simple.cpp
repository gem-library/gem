#include <iostream>
#include <Spectra/SymEigsShiftSolver.h>
#include <Spectra/MatOp/DenseSymShiftSolve.h>

/*
  This file seems to highlight a bug in Spectra`
*/

int main () {


    { // This doesn't seem to work
        std::cout << std::endl << "-- test --" << std::endl << std::flush;
        Eigen::Matrix< double, 8, 8> mat;
        mat <<                         0,                       0,                       0,                       0,                       0,  -2.4475453650814500000,  -3.5205938631136300000,  -1.0524810451403000000,
                                       0,                       0,                       0,                       0,   2.4475453650814500000,                       0,  -1.5069700890882000000,  -1.8131783397941900000,
                                       0,                       0,                       0,                       0,   3.5205938631136300000,   1.5069700890882000000,                       0,   2.4080291768596200000,
                                       0,                       0,                       0,                       0,   1.0524810451403000000,   1.8131783397941900000,  -2.4080291768596200000,                       0,
                                       0,   2.4475453650814500000,   3.5205938631136300000,   1.0524810451403000000,                       0,                       0,                       0,                       0,
                  -2.4475453650814500000,                       0,   1.5069700890882000000,   1.8131783397941900000,                       0,                       0,                       0,                       0,
                  -3.5205938631136300000,  -1.5069700890882000000,                       0,  -2.4080291768596200000,                       0,                       0,                       0,                       0,
                  -1.0524810451403000000,  -1.8131783397941900000,   2.4080291768596200000,                       0,                       0,                       0,                       0,                       0;

        // Desired number of eigenvalues
        int nbEigenvalues(1);

        // Construct eigen solver object, requesting desired eigenvalues
        Spectra::DenseSymShiftSolve<double> op(mat);
        int ncv(std::min(3+std::max(1+nbEigenvalues,2*nbEigenvalues), 8));
        Spectra::SymEigsShiftSolver< double, Spectra::LARGEST_MAGN, Spectra::DenseSymShiftSolve<double> > eigs(&op, nbEigenvalues, ncv, 1.0);

        // Initialize and compute
        std::cout << "Before initialization" << std::endl << std::flush;
        eigs.init();
        std::cout << "Initialization completed" << std::endl << std::flush;

        int maxIter(1000);
        int nconv = eigs.compute(maxIter, 0.000001, Spectra::LARGEST_MAGN);
        std::cout << "eigenvalues computed" << std::endl << std::flush;
    }

    return 0;
}
