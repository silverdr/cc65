;
; Startup code for cc65 (Apple2 version)
;
; This must be the *first* file on the linker command line
;

	.export		_exit
	.import	   	initlib, donelib
	.import	   	zerobss, push0
	.import		_main

	.include	 "apple2.inc"

; ------------------------------------------------------------------------
; Define and export the ZP variables for the C64 runtime

	.exportzp	sp, sreg, regsave
  	.exportzp	ptr1, ptr2, ptr3, ptr4
  	.exportzp	tmp1, tmp2, tmp3, tmp4
  	.exportzp	regbank, zpspace

; These zero page entries overlap with the sweet-16 registers in
; the standard apple2 linker config. They must be changed if sweet-16
; is to be supported

.zeropage

zpstart	= *
sp:	      	.res   	2 	; Stack pointer
sreg:	      	.res	2	; Secondary register/high 16 bit for longs
regsave:      	.res	2	; slot to save/restore (E)AX into
ptr1:	      	.res	2
ptr2:	      	.res	2
ptr3:	      	.res	2
ptr4:	      	.res	2
tmp1:	      	.res	1
tmp2:	      	.res	1
tmp3:	      	.res	1
tmp4:	      	.res	1
regbank:      	.res	6	; 6 byte register bank

zpspace	= * - zpstart		; Zero page space allocated

.code

; ------------------------------------------------------------------------
; Actual code

       	ldx	#zpspace-1
L1:	lda	sp,x
   	sta	zpsave,x	; Save the zero page locations we need
	dex
       	bpl	L1

; Clear the BSS data

	jsr	zerobss

; Save system stuff and setup the stack

       	tsx
       	stx    	spsave 		; Save the system stack ptr

	lda    	#<TOPMEM
	sta	sp
	lda	#>TOPMEM
       	sta	sp+1   		; Set argument stack ptr

; Call module constructors

	jsr	initlib

; Initialize conio stuff

	lda	#$ff
	sta	TEXTTYP

; Set up to use Apple ROM $C000-$CFFF

	;; 	sta    	USEROM

; Pass an empty command line

	jsr	push0  	 	; argc
	jsr	push0  	 	; argv

	ldy	#4     	 	; Argument size
       	jsr    	_main  	 	; call the users code

; Call module destructors. This is also the _exit entry.

_exit:	jsr	donelib
		       
; Restore system stuff

	lda	#$ff  		; Reset text mode
	sta	TEXTTYP

	ldx	spsave
	txs	       		; Restore stack pointer

; Copy back the zero page stuff

	ldx	#zpspace-1
L2:	lda	zpsave,x
	sta	sp,x
	dex
       	bpl	L2

; Reset changed vectors, back to basic

	jmp	RESTOR


.data

zpsave:	.res	zpspace

.bss

spsave:	.res	1
