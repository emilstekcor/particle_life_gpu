//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// _coder_updateParticlesByGroup_api.cu
//
// Code generation for function '_coder_updateParticlesByGroup_api'
//

// Include files
#include "_coder_updateParticlesByGroup_api.h"
#include "rt_nonfinite.h"
#include "updateParticlesByGroup.h"
#include "updateParticlesByGroup_data.h"
#include "updateParticlesByGroup_types.h"

// Function Declarations
static int32_T (*b_emlrt_marshallIn(const mxArray *b_nullptr,
                                    const char_T *identifier))[1000];

static int32_T (*b_emlrt_marshallIn(const mxArray *u,
                                    const emlrtMsgIdentifier *parentId))[1000];

static void b_emlrt_marshallIn(const mxArray *src,
                               const emlrtMsgIdentifier *msgId, real_T ret[36]);

static real_T c_emlrt_marshallIn(const mxArray *b_nullptr,
                                 const char_T *identifier);

static real_T c_emlrt_marshallIn(const mxArray *u,
                                 const emlrtMsgIdentifier *parentId);

static real_T (*d_emlrt_marshallIn(const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[3000];

static int32_T (*e_emlrt_marshallIn(const mxArray *src,
                                    const emlrtMsgIdentifier *msgId))[1000];

static real_T (*emlrt_marshallIn(const mxArray *b_nullptr,
                                 const char_T *identifier))[3000];

static real_T (*emlrt_marshallIn(const mxArray *u,
                                 const emlrtMsgIdentifier *parentId))[3000];

static void emlrt_marshallIn(const mxArray *b_nullptr, const char_T *identifier,
                             cell_wrap_0 y[5]);

static void emlrt_marshallIn(const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             cell_wrap_0 y[5]);

static void emlrt_marshallIn(const mxArray *u,
                             const emlrtMsgIdentifier *parentId, real_T y[36]);

static void emlrt_marshallOut(const real_T u[3000], const mxArray *y);

static real_T f_emlrt_marshallIn(const mxArray *src,
                                 const emlrtMsgIdentifier *msgId);

// Function Definitions
static int32_T (*b_emlrt_marshallIn(const mxArray *b_nullptr,
                                    const char_T *identifier))[1000]
{
  emlrtMsgIdentifier thisId;
  int32_T(*y)[1000];
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = b_emlrt_marshallIn(emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static int32_T (*b_emlrt_marshallIn(const mxArray *u,
                                    const emlrtMsgIdentifier *parentId))[1000]
{
  int32_T(*y)[1000];
  y = e_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void b_emlrt_marshallIn(const mxArray *src,
                               const emlrtMsgIdentifier *msgId, real_T ret[36])
{
  static const int32_T dims[2]{6, 6};
  real_T(*r)[36];
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 2U,
                          (const void *)&dims[0]);
  r = (real_T(*)[36])emlrtMxGetData(src);
  for (int32_T i{0}; i < 36; i++) {
    ret[i] = (*r)[i];
  }
  emlrtDestroyArray(&src);
}

static real_T c_emlrt_marshallIn(const mxArray *b_nullptr,
                                 const char_T *identifier)
{
  emlrtMsgIdentifier thisId;
  real_T y;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = c_emlrt_marshallIn(emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real_T c_emlrt_marshallIn(const mxArray *u,
                                 const emlrtMsgIdentifier *parentId)
{
  real_T y;
  y = f_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static real_T (*d_emlrt_marshallIn(const mxArray *src,
                                   const emlrtMsgIdentifier *msgId))[3000]
{
  static const int32_T dims[2]{1000, 3};
  real_T(*ret)[3000];
  int32_T iv[2];
  boolean_T bv[2]{false, false};
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 2U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret = (real_T(*)[3000])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static int32_T (*e_emlrt_marshallIn(const mxArray *src,
                                    const emlrtMsgIdentifier *msgId))[1000]
{
  static const int32_T dims[1]{1000};
  int32_T(*ret)[1000];
  int32_T iv[1];
  boolean_T bv[1]{false};
  emlrtCheckVsBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "int32", false, 1U,
                            (const void *)&dims[0], &bv[0], &iv[0]);
  ret = (int32_T(*)[1000])emlrtMxGetData(src);
  emlrtDestroyArray(&src);
  return ret;
}

static real_T (*emlrt_marshallIn(const mxArray *b_nullptr,
                                 const char_T *identifier))[3000]
{
  emlrtMsgIdentifier thisId;
  real_T(*y)[3000];
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  y = emlrt_marshallIn(emlrtAlias(b_nullptr), &thisId);
  emlrtDestroyArray(&b_nullptr);
  return y;
}

static real_T (*emlrt_marshallIn(const mxArray *u,
                                 const emlrtMsgIdentifier *parentId))[3000]
{
  real_T(*y)[3000];
  y = d_emlrt_marshallIn(emlrtAlias(u), parentId);
  emlrtDestroyArray(&u);
  return y;
}

static void emlrt_marshallIn(const mxArray *b_nullptr, const char_T *identifier,
                             cell_wrap_0 y[5])
{
  emlrtMsgIdentifier thisId;
  thisId.fIdentifier = const_cast<const char_T *>(identifier);
  thisId.fParent = nullptr;
  thisId.bParentIsCell = false;
  emlrt_marshallIn(emlrtAlias(b_nullptr), &thisId, y);
  emlrtDestroyArray(&b_nullptr);
}

static void emlrt_marshallIn(const mxArray *u,
                             const emlrtMsgIdentifier *parentId,
                             cell_wrap_0 y[5])
{
  emlrtMsgIdentifier thisId;
  int32_T iv[2];
  char_T str[11];
  boolean_T bv[2];
  thisId.fParent = parentId;
  thisId.bParentIsCell = true;
  bv[0] = false;
  iv[0] = 1;
  bv[1] = false;
  iv[1] = 5;
  emlrtCheckCell(emlrtRootTLSGlobal, parentId, u, 2U, &iv[0], &bv[0]);
  for (int32_T i{0}; i < 5; i++) {
    emlrtMexSnprintf(&str[0], (size_t)11U, "%d", i + 1);
    thisId.fIdentifier = &str[0];
    emlrt_marshallIn(
        emlrtAlias(emlrtGetCell(emlrtRootTLSGlobal, parentId, u, i)), &thisId,
        y[i].f1);
  }
  emlrtDestroyArray(&u);
}

static void emlrt_marshallIn(const mxArray *u,
                             const emlrtMsgIdentifier *parentId, real_T y[36])
{
  b_emlrt_marshallIn(emlrtAlias(u), parentId, y);
  emlrtDestroyArray(&u);
}

static void emlrt_marshallOut(const real_T u[3000], const mxArray *y)
{
  static const int32_T iv[2]{1000, 3};
  emlrtMxSetData((mxArray *)y, (void *)&u[0]);
  emlrtSetDimensions((mxArray *)y, &iv[0], 2);
}

static real_T f_emlrt_marshallIn(const mxArray *src,
                                 const emlrtMsgIdentifier *msgId)
{
  static const int32_T dims{0};
  real_T ret;
  emlrtCheckBuiltInR2012b(emlrtRootTLSGlobal, msgId, src, "double", false, 0U,
                          (const void *)&dims);
  ret = *static_cast<real_T *>(emlrtMxGetData(src));
  emlrtDestroyArray(&src);
  return ret;
}

void updateParticlesByGroup_api(const mxArray *const prhs[6], int32_T nlhs,
                                const mxArray *plhs[2])
{
  cell_wrap_0 forceMatrices[5];
  const mxArray *prhs_copy_idx_0;
  const mxArray *prhs_copy_idx_1;
  real_T(*pos)[3000];
  real_T(*vel)[3000];
  real_T dt;
  real_T forceLevel;
  int32_T(*ids)[1000];
  prhs_copy_idx_0 = emlrtProtectR2012b(prhs[0], 0, true, -1);
  prhs_copy_idx_1 = emlrtProtectR2012b(prhs[1], 1, true, -1);
  // Marshall function inputs
  pos = emlrt_marshallIn(emlrtAlias(prhs_copy_idx_0), "pos");
  vel = emlrt_marshallIn(emlrtAlias(prhs_copy_idx_1), "vel");
  ids = b_emlrt_marshallIn(emlrtAlias(prhs[2]), "ids");
  emlrt_marshallIn(emlrtAliasP(prhs[3]), "forceMatrices", forceMatrices);
  dt = c_emlrt_marshallIn(emlrtAliasP(prhs[4]), "dt");
  forceLevel = c_emlrt_marshallIn(emlrtAliasP(prhs[5]), "forceLevel");
  // Invoke the target function
  updateParticlesByGroup(*pos, *vel, *ids, forceMatrices, dt, forceLevel);
  // Marshall function outputs
  emlrt_marshallOut(*pos, prhs_copy_idx_0);
  plhs[0] = prhs_copy_idx_0;
  if (nlhs > 1) {
    emlrt_marshallOut(*vel, prhs_copy_idx_1);
    plhs[1] = prhs_copy_idx_1;
  }
}

// End of code generation (_coder_updateParticlesByGroup_api.cu)
