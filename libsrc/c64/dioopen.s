;
; dhandle_t __fastcall__ dio_open (unsigned char device);
;

        .export         _dio_open
        .import         return0, __oserror, _select_lfn
        .include        "c64.inc"
        .include        "errno.inc"

_dio_open:
        jsr _select_lfn

        ; Return oserror
        lda     #ENODEV
        sta     __oserror
        jmp     return0

        ; Return success
        txa
        asl
        asl
        asl
        asl
        ldx     #$00
        stx     __oserror
        rts
