// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build ppc64 ppc64le

#include "textflag.h"

TEXT ·SwapInt32(SB),NOSPLIT,$0-20
	BR	·SwapUint32(SB)

TEXT ·SwapUint32(SB),NOSPLIT,$0-20
	MOVD	addr+0(FP), R3
	MOVW	new+8(FP), R4
	SYNC
	LWAR	(R3), R5
	STWCCC	R4, (R3)
	BNE	-3(PC)
	SYNC
	ISYNC
	MOVW	R5, old+16(FP)
	RET

TEXT ·SwapInt64(SB),NOSPLIT,$0-24
	BR	·SwapUint64(SB)

TEXT ·SwapUint64(SB),NOSPLIT,$0-24
	MOVD	addr+0(FP), R3
	MOVD	new+8(FP), R4
	SYNC
	LDAR	(R3), R5
	STDCCC	R4, (R3)
	BNE	-3(PC)
	SYNC
	ISYNC
	MOVD	R5, old+16(FP)
	RET

TEXT ·SwapUintptr(SB),NOSPLIT,$0-24
	BR	·SwapUint64(SB)

TEXT ·CompareAndSwapInt32(SB),NOSPLIT,$0-17
	BR	·CompareAndSwapUint32(SB)

TEXT ·CompareAndSwapUint32(SB),NOSPLIT,$0-17
	MOVD	addr+0(FP), R3
	MOVW	old+8(FP), R4
	MOVW	new+12(FP), R5
	SYNC
	LWAR	(R3), R6
	CMPW	R6, R4
	BNE	8(PC)
	STWCCC	R5, (R3)
	BNE	-5(PC)
	SYNC
	ISYNC
	MOVD	$1, R3
	MOVB	R3, swapped+16(FP)
	RET
	MOVB	R0, swapped+16(FP)
	RET

TEXT ·CompareAndSwapUintptr(SB),NOSPLIT,$0-25
	BR	·CompareAndSwapUint64(SB)

TEXT ·CompareAndSwapInt64(SB),NOSPLIT,$0-25
	BR	·CompareAndSwapUint64(SB)

TEXT ·CompareAndSwapUint64(SB),NOSPLIT,$0-25
	MOVD	addr+0(FP), R3
	MOVD	old+8(FP), R4
	MOVD	new+16(FP), R5
	SYNC
	LDAR	(R3), R6
	CMP	R6, R4
	BNE	8(PC)
	STDCCC	R5, (R3)
	BNE	-5(PC)
	SYNC
	ISYNC
	MOVD	$1, R3
	MOVB	R3, swapped+24(FP)
	RET
	MOVB	R0, swapped+24(FP)
	RET

TEXT ·AddInt32(SB),NOSPLIT,$0-20
	BR	·AddUint32(SB)

TEXT ·AddUint32(SB),NOSPLIT,$0-20
	MOVD	addr+0(FP), R3
	MOVW	delta+8(FP), R4
	SYNC
	LWAR	(R3), R5
	ADD	R4, R5
	STWCCC	R5, (R3)
	BNE	-4(PC)
	SYNC
	ISYNC
	MOVW	R5, ret+16(FP)
	RET

TEXT ·AddUintptr(SB),NOSPLIT,$0-24
	BR	·AddUint64(SB)

TEXT ·AddInt64(SB),NOSPLIT,$0-24
	BR	·AddUint64(SB)

TEXT ·AddUint64(SB),NOSPLIT,$0-24
	MOVD	addr+0(FP), R3
	MOVD	delta+8(FP), R4
	SYNC
	LDAR	(R3), R5
	ADD	R4, R5
	STDCCC	R5, (R3)
	BNE	-4(PC)
	SYNC
	ISYNC
	MOVD	R5, ret+16(FP)
	RET

TEXT ·LoadInt32(SB),NOSPLIT,$0-12
	BR	·LoadUint32(SB)

TEXT ·LoadUint32(SB),NOSPLIT,$0-12
	MOVD	addr+0(FP), R3
	SYNC
	MOVW	0(R3), R3
	CMPW	R3, R3, CR7
	BC	4, 30, 1(PC)	// bne- cr7,0x4
	ISYNC
	MOVW	R3, val+8(FP)
	RET

TEXT ·LoadInt64(SB),NOSPLIT,$0-16
	BR	·LoadUint64(SB)

TEXT ·LoadUint64(SB),NOSPLIT,$0-16
	MOVD	addr+0(FP), R3
	SYNC
	MOVD	0(R3), R3
	CMP	R3, R3, CR7
	BC	4, 30, 1(PC)	// bne- cr7,0x4
	ISYNC
	MOVD	R3, val+8(FP)
	RET

TEXT ·LoadUintptr(SB),NOSPLIT,$0-16
	BR	·LoadPointer(SB)

TEXT ·LoadPointer(SB),NOSPLIT,$0-16
	BR	·LoadUint64(SB)

TEXT ·StoreInt32(SB),NOSPLIT,$0-12
	BR	·StoreUint32(SB)

TEXT ·StoreUint32(SB),NOSPLIT,$0-12
	MOVD	addr+0(FP), R3
	MOVW	val+8(FP), R4
	SYNC
	MOVW	R4, 0(R3)
	RET

TEXT ·StoreInt64(SB),NOSPLIT,$0-16
	BR	·StoreUint64(SB)

TEXT ·StoreUint64(SB),NOSPLIT,$0-16
	MOVD	addr+0(FP), R3
	MOVD	val+8(FP), R4
	SYNC
	MOVD	R4, 0(R3)
	RET

TEXT ·StoreUintptr(SB),NOSPLIT,$0-16
	BR	·StoreUint64(SB)
