;// Select Logical File Number
; INPUTS: none
; RETURNS: A - first available logical file number (LFN) on success, A = 0 on failure
; REGISTERS AFFECTED: A, X, Y

.export _select_lfn
.include "c64.inc"

.segment "CODE"
_select_lfn:
        ldx LDTND                ; 152 / $98 - LDTND - Number of Open I/O Files/Index to the End of File Tables
        bne some_files_open      ; unless LDTND reads $00 there are some files open
        lda #$01                 ; but when it reads - means no files are open so we just take the first one
        bne exit_success         ; and report success

some_files_open:
        cpx #$0a                 ; maximal number of open files...
        bcs exit_failure         ; ... already reached!

        ldy #$01
another_filenumber:
        tya
        dex                      ; we have to index the table starting at zero
@loop0:
        cmp LAT,x                ; $0259 - X value initially taken from LDTND ($98)
        beq filenumber_excluded
        dex
        bpl @loop0               ; if we go through all the allocated numbers and none is the same as ours...
exit_success:
        clc                      ; ... we report the success!
        rts

filenumber_excluded:
        ldx LDTND       ; $98
        iny                      ; we should never get to the point of Y reaching $ff but in case
        bne another_filenumber   ; of something being utterly broken - here we stop automatically anyway

exit_failure:
        lda #$00
        sec
        rts
;/
