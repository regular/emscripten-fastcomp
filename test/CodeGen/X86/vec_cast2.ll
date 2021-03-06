; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=corei7-avx -mattr=+avx | FileCheck %s
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mcpu=corei7-avx -mattr=+avx -x86-experimental-vector-widening-legalization | FileCheck %s --check-prefix=CHECK-WIDE

define <8 x float> @foo1_8(<8 x i8> %src) {
; CHECK-LABEL: foo1_8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm1 = xmm0[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-NEXT:    vpslld $24, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-NEXT:    vpslld $24, %xmm1, %xmm1
; CHECK-NEXT:    vpsrad $24, %xmm1, %xmm1
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo1_8:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vpmovzxbd {{.*#+}} xmm1 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-WIDE-NEXT:    vpslld $24, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpsrad $24, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpunpcklbw {{.*#+}} xmm0 = xmm0[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7]
; CHECK-WIDE-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4,4,5,5,6,6,7,7]
; CHECK-WIDE-NEXT:    vpslld $24, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; CHECK-WIDE-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-WIDE-NEXT:    retl
  %res = sitofp <8 x i8> %src to <8 x float>
  ret <8 x float> %res
}

define <4 x float> @foo1_4(<4 x i8> %src) {
; CHECK-LABEL: foo1_4:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpslld $24, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo1_4:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-WIDE-NEXT:    vpslld $24, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vpsrad $24, %xmm0, %xmm0
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = sitofp <4 x i8> %src to <4 x float>
  ret <4 x float> %res
}

define <8 x float> @foo2_8(<8 x i8> %src) {
; CHECK-LABEL: foo2_8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-NEXT:    vpunpckhwd {{.*#+}} xmm0 = xmm0[4,4,5,5,6,6,7,7]
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; CHECK-NEXT:    vandps LCPI2_0, %ymm0, %ymm0
; CHECK-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo2_8:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vpmovzxbd {{.*#+}} xmm1 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-WIDE-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[4],zero,zero,zero,xmm0[5],zero,zero,zero,xmm0[6],zero,zero,zero,xmm0[7],zero,zero,zero
; CHECK-WIDE-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; CHECK-WIDE-NEXT:    vcvtdq2ps %ymm0, %ymm0
; CHECK-WIDE-NEXT:    retl
  %res = uitofp <8 x i8> %src to <8 x float>
  ret <8 x float> %res
}

define <4 x float> @foo2_4(<4 x i8> %src) {
; CHECK-LABEL: foo2_4:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vandps LCPI3_0, %xmm0, %xmm0
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo2_4:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-WIDE-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = uitofp <4 x i8> %src to <4 x float>
  ret <4 x float> %res
}

define <8 x i8> @foo3_8(<8 x float> %src) {
; CHECK-LABEL: foo3_8:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvttps2dq %ymm0, %ymm0
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm1
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; CHECK-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; CHECK-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; CHECK-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo3_8:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %eax
; CHECK-WIDE-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm1
; CHECK-WIDE-NEXT:    vmovshdup %xmm0, %xmm2    ## xmm2 = xmm0[1,1,3,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $1, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilpd $1, %xmm0, %xmm2 ## xmm2 = xmm0[1,0]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $2, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilps $231, %xmm0, %xmm2 ## xmm2 = xmm0[3,1,2,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $3, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %eax
; CHECK-WIDE-NEXT:    vpinsrb $4, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vmovshdup %xmm0, %xmm2    ## xmm2 = xmm0[1,1,3,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $5, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilpd $1, %xmm0, %xmm2 ## xmm2 = xmm0[1,0]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $6, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilps $231, %xmm0, %xmm0 ## xmm0 = xmm0[3,1,2,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %eax
; CHECK-WIDE-NEXT:    vpinsrb $7, %eax, %xmm1, %xmm0
; CHECK-WIDE-NEXT:    vzeroupper
; CHECK-WIDE-NEXT:    retl
  %res = fptosi <8 x float> %src to <8 x i8>
  ret <8 x i8> %res
}

define <4 x i8> @foo3_4(<4 x float> %src) {
; CHECK-LABEL: foo3_4:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    retl
;
; CHECK-WIDE-LABEL: foo3_4:
; CHECK-WIDE:       ## BB#0:
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %eax
; CHECK-WIDE-NEXT:    vpinsrb $0, %eax, %xmm0, %xmm1
; CHECK-WIDE-NEXT:    vmovshdup %xmm0, %xmm2    ## xmm2 = xmm0[1,1,3,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $1, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilpd $1, %xmm0, %xmm2 ## xmm2 = xmm0[1,0]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm2, %eax
; CHECK-WIDE-NEXT:    vpinsrb $2, %eax, %xmm1, %xmm1
; CHECK-WIDE-NEXT:    vpermilps $231, %xmm0, %xmm0 ## xmm0 = xmm0[3,1,2,3]
; CHECK-WIDE-NEXT:    vcvttss2si %xmm0, %eax
; CHECK-WIDE-NEXT:    vpinsrb $3, %eax, %xmm1, %xmm0
; CHECK-WIDE-NEXT:    retl
  %res = fptosi <4 x float> %src to <4 x i8>
  ret <4 x i8> %res
}

