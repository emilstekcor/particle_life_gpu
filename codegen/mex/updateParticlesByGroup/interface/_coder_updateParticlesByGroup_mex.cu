//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_updateParticlesByGroup_mex.cu
//
// Code generation for function '_coder_updateParticlesByGroup_mex'
//

// Include files
#include "_coder_updateParticlesByGroup_mex.h"
#include "_coder_updateParticlesByGroup_api.h"
#include "rt_nonfinite.h"
#include "updateParticlesByGroup_data.h"
#include "updateParticlesByGroup_initialize.h"
#include "updateParticlesByGroup_terminate.h"
#include <stdexcept>

void emlrtExceptionBridge();
void emlrtExceptionBridge()
{
  throw std::runtime_error("");
}
// Function Definitions
void mexFunction(int32_T nlhs, mxArray *plhs[], int32_T nrhs,
                 const mxArray *prhs[])
{
  mexAtExit(&updateParticlesByGroup_atexit);
  // Module initialization.
  updateParticlesByGroup_initialize();
  try { // Dispatch the entry-point.
    unsafe_updateParticlesByGroup_mexFunction(nlhs, plhs, nrhs, prhs);
    // Module termination.
    updateParticlesByGroup_terminate();
  } catch (...) {
    emlrtCleanupOnException((emlrtCTX *)emlrtRootTLSGlobal);
    throw;
  }
}

emlrtCTX mexFunctionCreateRootTLS()
{
  emlrtCreateRootTLSR2022a(&emlrtRootTLSGlobal, &emlrtContextGlobal, nullptr, 1,
                           (void *)&emlrtExceptionBridge, "windows-1252", true);
  return emlrtRootTLSGlobal;
}

void unsafe_updateParticlesByGroup_mexFunction(int32_T nlhs, mxArray *plhs[2],
                                               int32_T nrhs,
                                               const mxArray *prhs[6])
{
  const mxArray *b_prhs[6];
  const mxArray *outputs[2];
  int32_T b;
  // Check for proper number of arguments.
  if (nrhs != 6) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal, "EMLRT:runTime:WrongNumberOfInputs",
                        5, 12, 6, 4, 22, "updateParticlesByGroup");
  }
  if (nlhs > 2) {
    emlrtErrMsgIdAndTxt(emlrtRootTLSGlobal,
                        "EMLRT:runTime:TooManyOutputArguments", 3, 4, 22,
                        "updateParticlesByGroup");
  }
  // Call the function.
  for (int32_T c{0}; c < 6; c++) {
    b_prhs[c] = prhs[c];
  }
  updateParticlesByGroup_api(b_prhs, nlhs, outputs);
  // Copy over outputs to the caller.
  if (nlhs < 1) {
    b = 1;
  } else {
    b = nlhs;
  }
  emlrtReturnArrays(b, &plhs[0], &outputs[0]);
}

// End of code generation (_coder_updateParticlesByGroup_mex.cu)
