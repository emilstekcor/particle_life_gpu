//
// Academic License - for use in teaching, academic research, and meeting
// course requirements at degree granting institutions only.  Not for
// government, commercial, or other organizational use.
//
// updateParticlesByGroup.cu
//
// Code generation for function 'updateParticlesByGroup'
//

// Include files
#include "updateParticlesByGroup.h"
#include "rt_nonfinite.h"
#include "updateParticlesByGroup_data.h"
#include "updateParticlesByGroup_types.h"
#include "MWCudaDimUtility.hpp"
#include "MWCudaMemoryFunctions.hpp"
#include "stdio.h"
#include "stdlib.h"
#include "string.h"

// Function Declarations
static void checkCudaError(cudaError_t errCode, const char_T *file,
                           uint32_T b_line);

static void raiseCudaError(int32_T errCode, const char_T *file, uint32_T b_line,
                           const char_T *errorName, const char_T *errorString);

static __global__ void
updateParticlesByGroup_kernel1(const cell_wrap_0 forceMatrices[5],
                               const int32_T ids[1000], const real_T forceLevel,
                               const real_T vel[3000], const real_T pos[3000],
                               real_T forces[3000]);

static __global__ void updateParticlesByGroup_kernel2(const real_T dt,
                                                      const real_T forces[3000],
                                                      real_T pos[3000],
                                                      real_T vel[3000]);

// Function Definitions
static void checkCudaError(cudaError_t errCode, const char_T *file,
                           uint32_T b_line)
{
  if (errCode != cudaSuccess) {
    raiseCudaError(errCode, file, b_line, cudaGetErrorName(errCode),
                   cudaGetErrorString(errCode));
  }
}

static void raiseCudaError(int32_T errCode, const char_T *file, uint32_T b_line,
                           const char_T *errorName, const char_T *errorString)
{
  emlrtRTEInfo rtInfo;
  uint64_T len;
  char_T *brk;
  char_T *fn;
  char_T *pn;
  len = strlen(file);
  pn = static_cast<char_T *>(calloc(len + 1ULL, 1ULL));
  fn = static_cast<char_T *>(calloc(len + 1ULL, 1ULL));
  memcpy(pn, file, len);
  memcpy(fn, file, len);
  brk = strrchr(fn, '.');
  *brk = '\x00';
  brk = strrchr(fn, '/');
  if (brk == nullptr) {
    brk = strrchr(fn, '\\');
  }
  if (brk == nullptr) {
    brk = fn;
  } else {
    brk++;
  }
  rtInfo.lineNo = static_cast<int32_T>(b_line);
  rtInfo.colNo = 0;
  rtInfo.fName = brk;
  rtInfo.pName = pn;
  emlrtCUDAError(static_cast<uint32_T>(errCode), (char_T *)errorName,
                 (char_T *)errorString, &rtInfo, emlrtRootTLSGlobal);
}

static __global__ __launch_bounds__(128, 1) void updateParticlesByGroup_kernel1(
    const cell_wrap_0 forceMatrices[5], const int32_T ids[1000],
    const real_T forceLevel, const real_T vel[3000], const real_T pos[3000],
    real_T forces[3000])
{
  int32_T i;
  i = static_cast<int32_T>(mwGetGlobalThreadIndex());
  if (i < 1000) {
    real_T b_forceMatrices[6];
    real_T b_pos[6];
    //  This function is intended for GPU execution
    //  Marking it for GPU code generation
    //  Update each particle based on its group's force matrix
    b_pos[0] = pos[i];
    b_pos[3] = vel[i];
    b_pos[1] = pos[i + 1000];
    b_pos[4] = vel[i + 1000];
    b_pos[2] = pos[i + 2000];
    b_pos[5] = vel[i + 2000];
    for (int32_T i1{0}; i1 < 6; i1++) {
      real_T d;
      d = 0.0;
      for (int32_T b_i{0}; b_i < 6; b_i++) {
        d += forceMatrices[ids[i] - 1].f1[i1 + 6 * b_i] * b_pos[b_i];
      }
      b_forceMatrices[i1] = d;
    }
    forces[i] = forceLevel * b_forceMatrices[0];
    forces[i + 1000] = forceLevel * b_forceMatrices[1];
    forces[i + 2000] = forceLevel * b_forceMatrices[2];
  }
}

static __global__ __launch_bounds__(128, 1) void updateParticlesByGroup_kernel2(
    const real_T dt, const real_T forces[3000], real_T pos[3000],
    real_T vel[3000])
{
  int32_T i;
  i = static_cast<int32_T>(mwGetGlobalThreadIndex());
  if (i < 3000) {
    real_T d;
    //  Update velocities and positions
    d = vel[i] + forces[i] * dt;
    vel[i] = d;
    pos[i] += d * dt;
  }
}

void updateParticlesByGroup(real_T cpu_pos[3000], real_T cpu_vel[3000],
                            const int32_T cpu_ids[1000],
                            const cell_wrap_0 cpu_forceMatrices[5], real_T dt,
                            real_T forceLevel)
{
  cell_wrap_0(*gpu_forceMatrices)[5];
  real_T(*gpu_forces)[3000];
  real_T(*gpu_pos)[3000];
  real_T(*gpu_vel)[3000];
  int32_T(*gpu_ids)[1000];
  checkCudaError(mwCudaMalloc(&gpu_forces, 24000ULL), __FILE__, __LINE__);
  checkCudaError(mwCudaMalloc(&gpu_forceMatrices, 1440ULL), __FILE__, __LINE__);
  checkCudaError(mwCudaMalloc(&gpu_ids, 4000ULL), __FILE__, __LINE__);
  checkCudaError(mwCudaMalloc(&gpu_vel, 24000ULL), __FILE__, __LINE__);
  checkCudaError(mwCudaMalloc(&gpu_pos, 24000ULL), __FILE__, __LINE__);
  //  This function is intended for GPU execution
  //  Marking it for GPU code generation
  //  Update each particle based on its group's force matrix
  checkCudaError(cudaMemcpy(*gpu_forceMatrices, cpu_forceMatrices, 1440ULL,
                            cudaMemcpyHostToDevice),
                 __FILE__, __LINE__);
  checkCudaError(cudaMemcpy(*gpu_ids, cpu_ids, 4000ULL, cudaMemcpyHostToDevice),
                 __FILE__, __LINE__);
  checkCudaError(
      cudaMemcpy(*gpu_vel, cpu_vel, 24000ULL, cudaMemcpyHostToDevice), __FILE__,
      __LINE__);
  checkCudaError(
      cudaMemcpy(*gpu_pos, cpu_pos, 24000ULL, cudaMemcpyHostToDevice), __FILE__,
      __LINE__);
  updateParticlesByGroup_kernel1<<<dim3(8U, 1U, 1U), dim3(128U, 1U, 1U)>>>(
      *gpu_forceMatrices, *gpu_ids, forceLevel, *gpu_vel, *gpu_pos,
      *gpu_forces);
  //  Update velocities and positions
  updateParticlesByGroup_kernel2<<<dim3(24U, 1U, 1U), dim3(128U, 1U, 1U)>>>(
      dt, *gpu_forces, *gpu_pos, *gpu_vel);
  checkCudaError(
      cudaMemcpy(cpu_pos, *gpu_pos, 24000ULL, cudaMemcpyDeviceToHost), __FILE__,
      __LINE__);
  checkCudaError(
      cudaMemcpy(cpu_vel, *gpu_vel, 24000ULL, cudaMemcpyDeviceToHost), __FILE__,
      __LINE__);
  checkCudaError(mwCudaFree(*gpu_pos), __FILE__, __LINE__);
  checkCudaError(mwCudaFree(*gpu_vel), __FILE__, __LINE__);
  checkCudaError(mwCudaFree(*gpu_ids), __FILE__, __LINE__);
  checkCudaError(mwCudaFree(*gpu_forceMatrices), __FILE__, __LINE__);
  checkCudaError(mwCudaFree(*gpu_forces), __FILE__, __LINE__);
}

// End of code generation (updateParticlesByGroup.cu)
