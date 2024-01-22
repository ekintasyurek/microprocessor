        AREA example, CODE, READONLY    ;Declare new area
        ENTRY                           ;Declare as an entry point
        ALIGN                           ;Ensures that __main addresses the following instruction

__main  FUNCTION                        ;Enable Debug
        EXPORT __main                   ;Make __main as global to access from startup file
        MOVS  R0, #2                    ;Move 2=>R0 (base)
        MOVS  R1, #4                    ;Move 4=>R1 (exponent)
        BL   power_recursive            ;Branch power_recursive subroutine
        B    stop                       ;Branch stop

power_recursive
        PUSH {LR}                       ;Push the return address to the stack
        CMP  R1, #0                     ;Compare R1 (exponent) with 0
        BEQ  end_power                  ;Branch end_power subroutine
        MOVS  R2, R0                    ;Move R0(base)=>R2
        SUBS R1, R1, #1                 ;Decrement exponent
        BL   power_recursive            ;Branch power_recursive subroutine
        MULS  R0, R2, R0                ;Multiply R0 and R2, move the result to R0
        POP {PC}                        ;Pop the return address and return

end_power
        MOVS  R0, #1                    ;Move 1=>R0
        POP {PC}                        ;Pop the return address and return

stop    B    stop                       ;Branch stop

        ENDFUNC                         ;Finish function
        END                             ;Finish assembly file