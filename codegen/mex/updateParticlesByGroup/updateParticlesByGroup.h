//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// updateParticlesByGroup.h
//
// Code generation for function 'updateParticlesByGroup'
//

#pragma once

// Include files
#include "rtwtypes.h"
#include "updateParticlesByGroup_types.h"
#include "emlrt.h"
#include "mex.h"
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Custom Header Code

#ifdef __CUDA_ARCH__
#undef printf
#endif

// Function Declarations
void updateParticlesByGroup(real_T cpu_pos[3000], real_T cpu_vel[3000],
                            const int32_T cpu_ids[1000],
                            const cell_wrap_0 cpu_forceMatrices[5], real_T dt,
                            real_T forceLevel);

// End of code generation (updateParticlesByGroup.h)
