//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// updateParticlesByGroup_initialize.cu
//
// Code generation for function 'updateParticlesByGroup_initialize'
//

// Include files
#include "updateParticlesByGroup_initialize.h"
#include "_coder_updateParticlesByGroup_mex.h"
#include "rt_nonfinite.h"
#include "updateParticlesByGroup_data.h"

// Function Definitions
void updateParticlesByGroup_initialize()
{
  mex_InitInfAndNan();
  emlrtInitGPU(emlrtRootTLSGlobal);
  cudaGetLastError();
  mexFunctionCreateRootTLS();
  emlrtClearAllocCountR2012b(emlrtRootTLSGlobal, false, 0U, nullptr);
  emlrtEnterRtStackR2012b(emlrtRootTLSGlobal);
  emlrtLicenseCheckR2022a(emlrtRootTLSGlobal,
                          "EMLRT:runTime:MexFunctionNeedsLicense",
                          "distrib_computing_toolbox", 2);
  emlrtFirstTimeR2012b(emlrtRootTLSGlobal);
}

// End of code generation (updateParticlesByGroup_initialize.cu)
