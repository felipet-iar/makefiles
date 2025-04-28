        #define SHT_PROGBITS 0x1

        PUBLIC foo


        SECTION `.text`:CODE:NOROOT(1)
        THUMB
foo:
        MOVS     R0,#+0x2A
        BX       LR               ;; return

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        END
