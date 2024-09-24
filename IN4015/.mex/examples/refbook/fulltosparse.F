#include "fintrf.h"
C======================================================================
C
#if 0
C     
C     fulltosparse.F
C     .F file needs to be preprocessed to generate .for equivalent
C     
#endif
C     
C     fulltosparse.f
C     example for illustrating how to populate a sparse matrix.
C     For the purpose of this example, you must pass in a
C     non-sparse 2-dimensional argument of type real double.
C
C     NOTE: The subroutine loadsparse() is in the file called 
C     loadsparse.f. 
C
C     This is a MEX-file for MATLAB.
C     Copyright 1984-2023 The MathWorks, Inc.
C     
C======================================================================
C     Gateway routine
      subroutine mexFunction(nlhs, plhs, nrhs, prhs)

C     Declarations
      implicit none

C     mexFunction arguments:
      mwPointer plhs(*), prhs(*)
      integer nlhs, nrhs

C     Function declarations:

#if MX_HAS_INTERLEAVED_COMPLEX
      mwPointer mxGetDoubles
#else
      mwPointer mxGetPr
#endif

      mwPointer mxCreateSparse
      mwPointer mxGetIr, mxGetJc
      mwPointer mxGetM, mxGetN
      integer mxIsComplex
      integer mxIsDouble, mxGetNumberOfElements
      integer loadsparse

C     Pointers to input/output mxArrays:
      mwPointer pr, sr, irs, jcs
      real*8, dimension (:,:), allocatable :: tpr
      real*8, dimension (:,:), allocatable :: tsr
      real*8, dimension (:,:), allocatable :: tirs
      real*8, dimension (:,:), allocatable :: tjcs
      integer num

C     Array information:
      mwPointer m, n
      mwSize nzmax

C-----------------------------------------------------------------------
C     Check for proper number of arguments. 
      if (nrhs .ne. 1) then
         call mexErrMsgIdAndTxt ('MATLAB:fulltosparse:nInput',
     +                           'One input argument required.')
      endif
      if (nlhs .gt. 1) then
         call mexErrMsgIdAndTxt ('MATLAB:fulltosparse:nOutput',
     +                           'Too many output arguments.')
      endif

C     Validate inputs
C     Check data type of input argument
      if (mxIsDouble(prhs(1)) .eq. 0) then
         call mexErrMsgIdAndTxt ('MATLAB:fulltosparse:NonDouble',
     +                      'Input argument must be of type double.')
      endif
      if (mxIsComplex(prhs(1)) .eq. 1) then
         call mexErrMsgIdAndTxt ('MATLAB:fulltosparse:NonReal',
     +                           'Input argument must be real only')
      endif

C     Get the size and pointers to input data
      m = mxGetM(prhs(1))
      n = mxGetN(prhs(1))
	  
#if MX_HAS_INTERLEAVED_COMPLEX
      pr = mxGetDoubles(prhs(1))
#else
      pr = mxGetPr(prhs(1))
#endif

C     Allocate space
C     NOTE: Assume at most 20% of the data is sparse.
      nzmax = dble(m*n) *.20 + .5

C     NOTE: The maximum number of non-zero elements cannot be less
C     than the number of columns in the matrix
      if (n .gt. nzmax) then
         nzmax = n
      endif

      plhs(1) = mxCreateSparse(m,n,nzmax,0)
	  
#if MX_HAS_INTERLEAVED_COMPLEX
      sr = mxGetDoubles(plhs(1))
#else	  
      sr = mxGetPr(plhs(1))
#endif
      num = mxGetNumberOfElements(plhs(1));

      irs = mxGetIr(plhs(1))
      jcs = mxGetJc(plhs(1))

C     Load the sparse data
#ifdef NAGFOR
      allocate(tpr(m, n))
      allocate(tsr(m, n))
      allocate(tirs(m, n))
      allocate(tjcs(m, n))
      call mxCopyPtrToReal8(pr, tpr, num)
      call mxCopyPtrToReal8(sr, tsr, num)
      call mxCopyPtrToReal8(irs, tirs, num)
      call mxCopyPtrToReal8(jcs, tjcs, num)
      if (loadsparse(tpr,tsr,tirs,tjcs,m,n,nzmax)
     +     .eq. 1) then
            call mexPrintf('Truncating output, input is > 20%% sparse')
      endif
      call mxCopyReal8ToPtr(tsr, sr, num)
      call mxCopyReal8ToPtr(tirs, irs, num)
      call mxCopyReal8ToPtr(tjcs, jcs, num)
#else
      if (loadsparse(%VAL(pr),%VAL(sr),%VAL(irs),%VAL(jcs),m,n,nzmax)
     +     .eq. 1) then
         call mexPrintf('Truncating output, input is > 20%% sparse')
      endif
#endif         

      return
      end
