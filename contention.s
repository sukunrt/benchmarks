	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 3
	.globl	_get_time_in_nsecs              ; -- Begin function get_time_in_nsecs
	.p2align	2
_get_time_in_nsecs:                     ; @get_time_in_nsecs
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32                    ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	mov	w8, #0
	mov	x0, x8
	add	x1, sp, #16                     ; =16
	bl	_clock_gettime
	ldr	x9, [sp, #16]
	mov	x10, #51712
	movk	x10, #15258, lsl #16
	mul	x9, x9, x10
	ldr	x10, [sp, #24]
	add	x9, x9, x10
	str	x9, [sp, #8]
	ldr	x9, [sp, #8]
	mov	x0, x9
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_pthread_barrier_init           ; -- Begin function pthread_barrier_init
	.p2align	2
_pthread_barrier_init:                  ; @pthread_barrier_init
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32                    ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #16]
	str	w1, [sp, #12]
	str	wzr, [sp, #8]
	ldr	x0, [sp, #16]
	mov	x8, #0
	mov	x1, x8
	bl	_pthread_mutex_init
	str	w0, [sp, #8]
	cbz	w0, LBB1_2
; %bb.1:
	ldr	w8, [sp, #8]
	stur	w8, [x29, #-4]
	b	LBB1_5
LBB1_2:
	ldr	x8, [sp, #16]
	add	x0, x8, #64                     ; =64
	mov	x8, #0
	mov	x1, x8
	bl	_pthread_cond_init
	str	w0, [sp, #8]
	cbz	w0, LBB1_4
; %bb.3:
	ldr	w8, [sp, #8]
	stur	w8, [x29, #-4]
	b	LBB1_5
LBB1_4:
	ldr	x8, [sp, #16]
	str	wzr, [x8, #112]
	ldr	x8, [sp, #16]
	str	xzr, [x8, #120]
	ldrsw	x8, [sp, #12]
	ldr	x9, [sp, #16]
	str	x8, [x9, #128]
	stur	wzr, [x29, #-4]
LBB1_5:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_pthread_barrier_wait           ; -- Begin function pthread_barrier_wait
	.p2align	2
_pthread_barrier_wait:                  ; @pthread_barrier_wait
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #48                     ; =48
	stp	x29, x30, [sp, #32]             ; 16-byte Folded Spill
	add	x29, sp, #32                    ; =32
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	str	x0, [sp, #16]
	str	wzr, [sp, #12]
	str	wzr, [sp, #8]
	ldr	x0, [sp, #16]
	bl	_pthread_mutex_lock
	str	w0, [sp, #12]
	cbz	w0, LBB2_2
; %bb.1:
	ldr	w8, [sp, #12]
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_2:
	ldr	x8, [sp, #16]
	ldr	w9, [x8, #112]
	str	w9, [sp, #8]
	ldr	x8, [sp, #16]
	ldr	x10, [x8, #120]
	add	x10, x10, #1                    ; =1
	str	x10, [x8, #120]
	ldr	x8, [sp, #16]
	ldr	x8, [x8, #120]
	ldr	x10, [sp, #16]
	ldr	x10, [x10, #128]
	subs	x8, x8, x10
	b.ne	LBB2_8
; %bb.3:
	ldr	x8, [sp, #16]
	str	xzr, [x8, #120]
	ldr	x8, [sp, #16]
	ldr	w9, [x8, #112]
	mov	w10, #1
	subs	w9, w10, w9
	ldr	x8, [sp, #16]
	str	w9, [x8, #112]
	ldr	x8, [sp, #16]
	add	x0, x8, #64                     ; =64
	bl	_pthread_cond_broadcast
	str	w0, [sp, #12]
	cbz	w0, LBB2_5
; %bb.4:
	ldr	w8, [sp, #12]
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_5:
	ldr	x0, [sp, #16]
	bl	_pthread_mutex_unlock
	str	w0, [sp, #12]
	cbz	w0, LBB2_7
; %bb.6:
	ldr	w8, [sp, #12]
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_7:
	mov	w8, #1
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_8:
LBB2_9:                                 ; =>This Inner Loop Header: Depth=1
	ldr	x8, [sp, #16]
	ldr	w9, [x8, #112]
	ldr	w10, [sp, #8]
	subs	w9, w9, w10
	b.ne	LBB2_13
; %bb.10:                               ;   in Loop: Header=BB2_9 Depth=1
	ldr	x8, [sp, #16]
	add	x0, x8, #64                     ; =64
	ldr	x1, [sp, #16]
	bl	_pthread_cond_wait
	str	w0, [sp, #12]
	ldr	w9, [sp, #12]
	cbz	w9, LBB2_12
; %bb.11:
	ldr	w8, [sp, #12]
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_12:                                ;   in Loop: Header=BB2_9 Depth=1
	b	LBB2_14
LBB2_13:
	b	LBB2_15
LBB2_14:                                ;   in Loop: Header=BB2_9 Depth=1
	b	LBB2_9
LBB2_15:
	ldr	x0, [sp, #16]
	bl	_pthread_mutex_unlock
	str	w0, [sp, #12]
	cbz	w0, LBB2_17
; %bb.16:
	ldr	w8, [sp, #12]
	stur	w8, [x29, #-4]
	b	LBB2_18
LBB2_17:
	stur	wzr, [x29, #-4]
LBB2_18:
	ldur	w0, [x29, #-4]
	ldp	x29, x30, [sp, #32]             ; 16-byte Folded Reload
	add	sp, sp, #48                     ; =48
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_loopFunc                       ; -- Begin function loopFunc
	.p2align	2
_loopFunc:                              ; @loopFunc
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #16                     ; =16
	.cfi_def_cfa_offset 16
	str	wzr, [sp, #12]
	str	wzr, [sp, #8]
LBB3_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #8]
	mov	w9, #38528
	movk	w9, #152, lsl #16
	subs	w8, w8, w9
	b.ge	LBB3_4
; %bb.2:                                ;   in Loop: Header=BB3_1 Depth=1
	ldr	w8, [sp, #12]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #12]
; %bb.3:                                ;   in Loop: Header=BB3_1 Depth=1
	ldr	w8, [sp, #8]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #8]
	b	LBB3_1
LBB3_4:
	add	sp, sp, #16                     ; =16
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_threadLoopFunc                 ; -- Begin function threadLoopFunc
	.p2align	2
_threadLoopFunc:                        ; @threadLoopFunc
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #80                     ; =80
	stp	x29, x30, [sp, #64]             ; 16-byte Folded Spill
	add	x29, sp, #64                    ; =64
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	stur	x0, [x29, #-8]
	adrp	x0, _barrier@GOTPAGE
	ldr	x0, [x0, _barrier@GOTPAGEOFF]
	bl	_pthread_barrier_wait
	bl	_get_time_in_nsecs
	stur	x0, [x29, #-16]
	bl	_loopFunc
	bl	_get_time_in_nsecs
	stur	x0, [x29, #-24]
	ldur	x8, [x29, #-24]
	ldur	x9, [x29, #-16]
	subs	x8, x8, x9
                                        ; kill: def $w8 killed $w8 killed $x8
	mov	w10, #16960
	movk	w10, #15, lsl #16
	sdiv	w8, w8, w10
	stur	w8, [x29, #-28]
	ldur	w8, [x29, #-28]
                                        ; implicit-def: $x0
	mov	x0, x8
	adrp	x9, l_.str@PAGE
	add	x9, x9, l_.str@PAGEOFF
	str	x0, [sp, #24]                   ; 8-byte Folded Spill
	mov	x0, x9
	mov	x9, sp
	ldr	x11, [sp, #24]                  ; 8-byte Folded Reload
	str	x11, [x9]
	mov	x12, #10
	str	x12, [x9, #8]
	bl	_printf
	mov	x9, #0
	mov	x0, x9
	ldp	x29, x30, [sp, #64]             ; 16-byte Folded Reload
	add	sp, sp, #80                     ; =80
	ret
	.cfi_endproc
                                        ; -- End function
	.globl	_main                           ; -- Begin function main
	.p2align	2
_main:                                  ; @main
	.cfi_startproc
; %bb.0:
	sub	sp, sp, #160                    ; =160
	stp	x29, x30, [sp, #144]            ; 16-byte Folded Spill
	add	x29, sp, #144                   ; =144
	.cfi_def_cfa w29, 16
	.cfi_offset w30, -8
	.cfi_offset w29, -16
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	stur	x8, [x29, #-8]
	str	wzr, [sp, #52]
	str	wzr, [sp, #48]
LBB5_1:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #48]
	cmp	w8, #10                         ; =10
	b.ge	LBB5_4
; %bb.2:                                ;   in Loop: Header=BB5_1 Depth=1
	bl	_loopFunc
; %bb.3:                                ;   in Loop: Header=BB5_1 Depth=1
	ldr	w8, [sp, #48]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #48]
	b	LBB5_1
LBB5_4:
	bl	_get_time_in_nsecs
	str	x0, [sp, #40]
	bl	_loopFunc
	bl	_get_time_in_nsecs
	str	x0, [sp, #32]
	ldr	x8, [sp, #32]
	ldr	x9, [sp, #40]
	subs	x8, x8, x9
                                        ; kill: def $w8 killed $w8 killed $x8
	mov	w10, #16960
	movk	w10, #15, lsl #16
	sdiv	w8, w8, w10
	str	w8, [sp, #28]
	ldr	w8, [sp, #28]
                                        ; implicit-def: $x0
	mov	x0, x8
	adrp	x9, l_.str.1@PAGE
	add	x9, x9, l_.str.1@PAGEOFF
	str	x0, [sp, #16]                   ; 8-byte Folded Spill
	mov	x0, x9
	mov	x9, sp
	ldr	x11, [sp, #16]                  ; 8-byte Folded Reload
	str	x11, [x9]
	bl	_printf
	adrp	x9, _barrier@GOTPAGE
	ldr	x9, [x9, _barrier@GOTPAGEOFF]
	mov	x0, x9
	mov	w1, #10
	bl	_pthread_barrier_init
	str	wzr, [sp, #24]
LBB5_5:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	cmp	w8, #10                         ; =10
	b.ge	LBB5_8
; %bb.6:                                ;   in Loop: Header=BB5_5 Depth=1
	ldrsw	x8, [sp, #24]
	add	x9, sp, #56                     ; =56
	add	x0, x9, x8, lsl #3
	mov	x8, #0
	mov	x1, x8
	adrp	x2, _threadLoopFunc@PAGE
	add	x2, x2, _threadLoopFunc@PAGEOFF
	mov	x3, x8
	bl	_pthread_create
; %bb.7:                                ;   in Loop: Header=BB5_5 Depth=1
	ldr	w8, [sp, #24]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #24]
	b	LBB5_5
LBB5_8:
	str	wzr, [sp, #24]
LBB5_9:                                 ; =>This Inner Loop Header: Depth=1
	ldr	w8, [sp, #24]
	cmp	w8, #10                         ; =10
	b.ge	LBB5_12
; %bb.10:                               ;   in Loop: Header=BB5_9 Depth=1
	ldrsw	x8, [sp, #24]
	add	x9, sp, #56                     ; =56
	ldr	x0, [x9, x8, lsl #3]
	mov	x8, #0
	mov	x1, x8
	bl	_pthread_join
; %bb.11:                               ;   in Loop: Header=BB5_9 Depth=1
	ldr	w8, [sp, #24]
	add	w8, w8, #1                      ; =1
	str	w8, [sp, #24]
	b	LBB5_9
LBB5_12:
	adrp	x8, ___stack_chk_guard@GOTPAGE
	ldr	x8, [x8, ___stack_chk_guard@GOTPAGEOFF]
	ldr	x8, [x8]
	ldur	x9, [x29, #-8]
	subs	x8, x8, x9
	b.ne	LBB5_14
; %bb.13:
	mov	w8, #0
	mov	x0, x8
	ldp	x29, x30, [sp, #144]            ; 16-byte Folded Reload
	add	sp, sp, #160                    ; =160
	ret
LBB5_14:
	bl	___stack_chk_fail
	.cfi_endproc
                                        ; -- End function
	.comm	_barrier,136,3                  ; @barrier
	.section	__TEXT,__cstring,cstring_literals
l_.str:                                 ; @.str
	.asciz	"Took %d msecs with %d threads\n"

l_.str.1:                               ; @.str.1
	.asciz	"Took %d msecs with only 1 thread running\n"

.subsections_via_symbols
