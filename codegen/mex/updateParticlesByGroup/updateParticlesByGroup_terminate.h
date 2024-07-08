//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// updateParticlesByGroup_terminate.h
//
// Code generation for function 'updateParticlesByGroup_terminate'
//

#pragma once

// Include files
#include "rtwtypes.h"
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
void updateParticlesByGroup_atexit();

void updateParticlesByGroup_terminate();

// End of code generation (updateParticlesByGroup_terminate.h)
