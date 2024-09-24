/*=========================================================
* dotProductComplexIC.c - Example to handle FORTRAN complex
* return type for function called from a C MEX file.
*
* X = dotProductComplexIC(A,B) computes the dot product of 
* each element of two complex vectors A and B 
* using BLAS routine ZDOTU: 
* DOUBLE COMPLEX FUNCTION ZDOTU(N,ZX,INCX,ZY,INCY)
*
* where:
* A and B are COMPLEX vectors of the same size  
* X is COMPLEX scalar
*
* This example uses interleaved complex representation for complex numbers.
* For an example using separate complex, see dotProductComplex.c.
*
* Use this command to build the MEX file using interleaved complex:
* mex('-R2018a','dotProductComplexIC.c','-lmwblas')
*
* This is a MEX file for MATLAB.
* Copyright 2021 The MathWorks, Inc.
*=======================================================*/
/* $Revision: */

#include "mex.h"
#include "blas.h"

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[])
{
  double *zinA, *zinB;  /* pointers to input matrices */
  doublecomplex *result; /* pointer to ZDOTU output */

  /* matrix dimensions */
  size_t nrowsA, ncolsA, nrowsB, ncolsB;

  /* additional inputs to ZDOTU */
  mwSignedIndex nElements;    /* Number of elements in vector */
  mwSignedIndex one = 1; 
  mwSignedIndex incx = one;   /* Increment between elements of x */
  mwSignedIndex incy = one;   /* Increment between elements of y */

  /* Check for proper number of arguments. */
  if ( nrhs != 2) {
    mexErrMsgIdAndTxt("MATLAB:dotProductComplexIC:rhs",
    "This function requires 2 input matrices.");
  }
  /* Check for complex values */
  if (!mxIsComplex(prhs[0]) || !mxIsComplex(prhs[1])) {
    mexErrMsgIdAndTxt("MATLAB:dotProductComplexIC:real",
    "Input matrices must be complex.");
  }

  /* Dimensions of input matrices A and B */
  nrowsA = mxGetM(prhs[0]);  
  ncolsA = mxGetN(prhs[0]);
  nrowsB = mxGetM(prhs[1]);  
  ncolsB = mxGetN(prhs[1]);
  
  /* Validate input arguments */
  if ((nrowsA > ncolsA ? ncolsA : nrowsA) > 1 || 
      (nrowsB > ncolsB ? ncolsB : nrowsB) > 1) {
    mexErrMsgIdAndTxt("MATLAB:dotProductComplexIC:matrix",
    "Input must be vectors."); 
  }
  if ((nElements = (nrowsA > ncolsA ? nrowsA : ncolsA)) != 
      (nrowsB > ncolsB ? nrowsB : ncolsB) ) {
    mexErrMsgIdAndTxt("MATLAB:dotProductComplexIC:unequal",
     "Input vectors must be equal size.");
  }

  plhs[0] = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxCOMPLEX);
  
  /* Convert complex data into appropriate type */
  zinA = (double *)(mxGetData(prhs[0]));
  zinB = (double *)(mxGetData(prhs[1]));
  result = (doublecomplex *)(mxGetComplexDoubles(plhs[0]));  

  /* Call BLAS function */
  zdotu(result, &nElements, zinA, &incx, zinB, &incy);
}
