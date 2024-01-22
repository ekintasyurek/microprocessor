        AREA example, CODE, READONLY    ;Declare new area
        ENTRY                           ;Declare as an entry point
        ALIGN                           ;Ensures that __main addresses the following instruction

__main  FUNCTION                        ;Enable Debug
        EXPORT __main                   ;Make __main as global to access from startup file
        MOVS R0, #0x49                  ;Move 0x49=>R0
        MOVS R1, #0xFF                  ;Move 0xFF=>R0
        EORS R1, R0, R1                 ;Bitwise exclusive OR (XOR) R0 and R1, result in R1
        B    stop                       ;Branch stop

stop	B    stop						;Branch stop

        ENDFUNC                         ;Finish function
        END                             ;Finish assembly files