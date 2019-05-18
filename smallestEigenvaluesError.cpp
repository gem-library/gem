#include <iostream>
#include <Eigen/MPRealSupport>
#include <Spectra/SymEigsSolver.h>
#include <Spectra/GenEigsSolver.h>
#include <Spectra/SymEigsShiftSolver.h>
#include <Spectra/GenEigsComplexShiftSolver.h>
#include <Spectra/MatOp/DenseSymShiftSolve.h>
#include <Spectra/MatOp/DenseGenComplexShiftSolve.h>

/*
  This file seems to highlight a bug in Spectra`
*/

using namespace std;
using namespace mpfr;
using namespace Eigen;

int main () {


    { // This works
        std::cout << "-- test 1 --" << std::endl << std::flush;
        Matrix< mpreal, 8, 8> mat;
        mat <<  "0", "0", "0", "0", "0", "-2.4475453650814500000", "-3.5205938631136300000", "-1.0524810451403000000",
                "0", "0", "0", "0", "2.4475453650814500000", "0", "-1.5069700890882000000", "-1.8131783397941900000",
                "0", "0", "0", "0", "3.5205938631136300000", "1.5069700890882000000", "0", "2.4080291768596200000",
                "0", "0", "0", "0", "1.0524810451403000000", "1.8131783397941900000", "-2.4080291768596200000", "0",
                "0", "2.4475453650814500000", "3.5205938631136300000", "1.0524810451403000000", "0", "0", "0", "0",
                "-2.4475453650814500000", "0", "1.5069700890882000000", "1.8131783397941900000", "0", "0", "0", "0",
                "-3.5205938631136300000", "-1.5069700890882000000", "0", "-2.4080291768596200000", "0", "0", "0", "0",
                "-1.0524810451403000000", "-1.8131783397941900000", "2.4080291768596200000", "0", "0", "0", "0", "0";

        // Desired number of eigenvalues
        int nbEigenvalues(1);

        // Construct eigen solver object, requesting desired eigenvalues
        Spectra::DenseSymMatProd<mpreal> op(mat);
        int ncv(std::min(3+std::max(1+nbEigenvalues,2*nbEigenvalues), 8));
        Spectra::SymEigsSolver< mpreal, Spectra::LARGEST_MAGN, Spectra::DenseSymMatProd<mpreal> > eigs(&op, nbEigenvalues, ncv);

        // Initialize and compute
        std::cout << "Before initialization" << std::endl << std::flush;
        eigs.init();
        std::cout << "Initialization completed" << std::endl << std::flush;

        int maxIter(1000);
        mpreal tolerance(pow(10,-mpfr::bits2digits(mpfr::mpreal::get_default_prec())));
        int nconv = eigs.compute(maxIter, tolerance, Spectra::LARGEST_MAGN);
        std::cout << "eigenvalues computed" << std::endl << std::flush;
    }

    { // This already doesn't work...
        std::cout << std::endl << "-- test 2 --" << std::endl << std::flush;
        Matrix< double, 8, 8> mat;
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
        Spectra::SymEigsShiftSolver< double, Spectra::LARGEST_MAGN, Spectra::DenseSymShiftSolve<double> > eigs(&op, nbEigenvalues, ncv, 1);

        // Initialize and compute
        std::cout << "Before initialization" << std::endl << std::flush;
        eigs.init();
        std::cout << "Initialization completed" << std::endl << std::flush;

        int maxIter(1000);
        int nconv = eigs.compute(maxIter, 0.000001, Spectra::LARGEST_MAGN);
        std::cout << "eigenvalues computed in double" << std::endl << std::flush;
    }

    { // This fails
        std::cout << std::endl << "-- Test 3 --" << std::endl << std::flush;
        Matrix< mpreal, 8, 8> mat;
        mat <<  "0", "0", "0", "0", "0", "-2.4475453650814500000", "-3.5205938631136300000", "-1.0524810451403000000",
                "0", "0", "0", "0", "2.4475453650814500000", "0", "-1.5069700890882000000", "-1.8131783397941900000",
                "0", "0", "0", "0", "3.5205938631136300000", "1.5069700890882000000", "0", "2.4080291768596200000",
                "0", "0", "0", "0", "1.0524810451403000000", "1.8131783397941900000", "-2.4080291768596200000", "0",
                "0", "2.4475453650814500000", "3.5205938631136300000", "1.0524810451403000000", "0", "0", "0", "0",
                "-2.4475453650814500000", "0", "1.5069700890882000000", "1.8131783397941900000", "0", "0", "0", "0",
                "-3.5205938631136300000", "-1.5069700890882000000", "0", "-2.4080291768596200000", "0", "0", "0", "0",
                "-1.0524810451403000000", "-1.8131783397941900000", "2.4080291768596200000", "0", "0", "0", "0", "0";

        // Desired number of eigenvalues
        int nbEigenvalues(1);

        // Construct eigen solver object, requesting desired eigenvalues
        Spectra::DenseSymShiftSolve<mpreal> op(mat);
        int ncv(std::min(3+std::max(1+nbEigenvalues,2*nbEigenvalues), 8));
        Spectra::SymEigsShiftSolver< mpreal, Spectra::LARGEST_MAGN, Spectra::DenseSymShiftSolve<mpreal> > eigs(&op, nbEigenvalues, ncv, mpreal("1"));

        // Initialize and compute
        std::cout << "Before initialization" << std::endl << std::flush;
        eigs.init();
        std::cout << "Initialization completed" << std::endl << std::flush;

        int maxIter(1000);
        mpreal tolerance(pow(10,-mpfr::bits2digits(mpfr::mpreal::get_default_prec())));
        int nconv = eigs.compute(maxIter, tolerance, Spectra::LARGEST_MAGN);
        std::cout << "eigenvalues computed" << std::endl << std::flush;
    }


    return 0;
}
