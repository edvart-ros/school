C=========================================================
C dotProductComplexIC.F - Example to handle FORTRAN complex
C return type for function called from a FORTRAN MEX file.
C
C X = dotProductComplexIC(A,B) computes the dot product of 
C each element of two complex vectors A and B 
C using BLAS routine ZDOTC: 
C DOUBLE COMPLEX FUNCTION ZDOTC(N,ZX,INCX,ZY,INCY)
C
C where:
C A and B are COMPLEX vectors of the same size  
C X is COMPLEX scalar
C
C This example uses interleaved complex representation for complex numbers.
C Use this command to build the MEX file on Windows and macOS platforms:
C mex('-R2018a','dotProductComplexIC.F','-lmwblas')
C
C Use this command to build the MEX file on Linux platforms:
C mex("FFLAGS='$FFLAGS -ff2c -fno-second-underscore'",'-R2018a','dotProductComplexIC.F','-lmwblas')
C
C This is a MEX file for MATLAB.
C Copyright 2021 The MathWorks, Inc.
C========================================================

#include "fintrf.h" 

      subroutine mexFunction(nlhs, plhs, nrhs, prhs)

C     Declarations
      implicit none

C     mexFunction arguments:
      mwPointer plhs(*), prhs(*)
      integer nlhs, nrhs

C     Function declarations:  
      mwPointer mxGetM, mxGetN
      mwPointer mxGetComplexDoubles, mxCreateDoubleMatrix
      integer*4 status, mxCopyPtrToComplex16, mxCopyComplex16ToPtr
      complex*16 zdotc

C     Arguments for computational routine: 
      complex*16, dimension (:,:), allocatable :: zinA   
      complex*16, dimension (:,:), allocatable :: zinB 
      complex*16 result

C     Pointers to input/output mxArrays: 
      mwPointer A_ptr, B_ptr, result_ptr

C     Array information:
      mwPointer nrowsA, ncolsA, nrowsB, ncolsB, sizeA, sizeB

C     Variables representing smaller dimension of input objects
      mwPointer tempA, tempB


C     Check for proper number of arguments. 
      if(nrhs .ne. 2) then
         call mexErrMsgIdAndTxt('MATLAB:dotProductComplexIC:nInput',
     +                          'One input required.')
      elseif(nlhs .gt. 1) then
         call mexErrMsgIdAndTxt('MATLAB:dotProductComplexIC:nOutput',
     +                          'Too many output arguments.')
      endif

C     Dimensions of input matrices A and B
      nrowsA = mxGetM(prhs(1))
      ncolsA = mxGetN(prhs(1))
      nrowsB = mxGetM(prhs(2))
      ncolsB = mxGetN(prhs(2))

C     Validate input arguments
      if (nrowsA .gt. ncolsA) then
            sizeA = nrowsA
            tempA = ncolsA
      else 
            sizeA = ncolsA
            tempA = nrowsA
      endif

      if (nrowsB .gt. ncolsB) then
            sizeB = nrowsB
            tempB = ncolsB
      else 
            sizeB = ncolsB
            tempB = nrowsB
      endif

      if((tempA .gt. 1) .or. (tempB .gt. 1)) then
          call mexErrMsgIdAndTxt('MATLAB:dotProductComplexIC:nInput',
     +                           'Input must be vectors.')
      endif
      if((sizeA .ne. sizeB)) then
         call mexErrMsgIdAndTxt('MATLAB:dotProductComplexIC:nOutput',
     +                           'Input vectors must be equal size.')
      endif
    
C     Allocate array space      
      allocate(zinA(sizeA, 1))
      allocate(zinB(sizeB, 1))
    
      A_ptr = mxGetComplexDoubles(prhs(1))
      B_ptr = mxGetComplexDoubles(prhs(2))
      
      plhs(1) = mxCreateDoubleMatrix(1, 1, 1)
      status = mxCopyPtrToComplex16(A_ptr, zinA, sizeA)
      status = mxCopyPtrToComplex16(B_ptr, zinB, sizeB)

C     Call BLAS function
      result = zdotc(sizeA, zinA, 1, zinB, 1)
    
      result_ptr = mxGetComplexDoubles(plhs(1))
      status = mxCopyComplex16ToPtr(result, result_ptr, 1)
    
      return
      end