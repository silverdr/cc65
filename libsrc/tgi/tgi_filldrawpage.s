;
; Ullrich von Bassewitz, 21.06.2002
;
; void tgi_filldrawpage (unsigned char color);
; /* Fill the drawpage with given colour */

        .include        "tgi-kernel.inc"

_tgi_filldrawpage      = tgi_filldrawpage               ; Call the driver
