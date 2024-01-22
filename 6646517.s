;Ekin Tasyurek 150190108
		AREA DATA, DATA, READWRITE	; DATA section for read-write data
array_size	EQU 400         ; Define the size of the array
buffer_size	EQU 0x100       ; Define the buffer size
start_time	DCD 0           ; Initialize start_time to 0
execution_time	DCD 0       ; Initialize execution_time to 0
filename	DCB  "array.txt", 0 ; Define the filename

        AREA CODE, CODE, READONLY	; CODE section for read-only code
__main  FUNCTION
        EXPORT __main

		; Open the file for reading
		LDR R0, =filename        ; Load the address of the filename into R0
		MOVS R1, #0x0            ; O_RDONLY (read-only mode)
		MOVS R7, #5              ; syscall number for open
		SWI 0                    ; Execute the open syscall

		MOV R4, R0               ; Save file descriptor in R4

		; Read data from the file into the buffer
		MOVS R0, R4              ; File descriptor
		MOVS R1, R2              ; Buffer address
		LDR R2, =buffer_size     ; Load buffer size into R2
		MOVS R7, #3              ; syscall number for read
		SWI 0                    ; Execute the read syscall

		; Close the file
		MOVS R0, R4              ; File descriptor
		MOVS R7, #6              ; syscall number for close
		SWI 0                    ; Execute the close syscall

		
		BL Init_Systick_Timer	; Initialize SysTick Timer

		
		BL Save_Start_Time		; Save the start time

		MOVS R0, #0              ; Initialize loop counter to 0
		LDR R3, =array_size      ; Load the address of array_size into R3
		SUBS R3, R3, #4          ; Adjust array size to iterate over elements

L1  CMP R0, R3              ; Compare current index with array size
    BEQ Save_Execution_Time ; If equal, branch to save execution time
    MOVS R1, #4             ; Set R1 to 4 (size of array elements)
    MOVS R4, R3             ; Copy array size to R4
    SUBS R4, R4, R0         ; Calculate remaining elements to process

L2  CMP R1, R4           ; Compare inner loop counter with remaining elements
    BEQ EndL2            ; If equal, exit inner loop
    LDR R5, [R2, R1]     ; Load element at current index
    ADDS R1, R1, #4      ; Move to next element
    LDR R6, [R2, R1]     ; Load next element
    CMP R5, R6           ; Compare current and next elements
    BEQ L2               ; If equal, continue to the next iteration
    ; Swap elements in the array
    STR R5, [R2, R1]     ; Store the next element at the current index
    SUBS R1, R1, #4      ; Move back to the current element
    STR R6, [R2, R1]     ; Store the current element at the next index
    ADDS R1, R1, #4      ; Move to the next index
    B L2                 ; Repeat the inner loop

EndL2   ADDS R0, R0, #4  ; Increment the outer loop index
        B L1             ; Repeat the outer loop

Init_Systick_Timer	PUSH {LR}                   ; Save the link register
					LDR R0, =0xE000E010         ; Load the base address of SysTick control and status register
					LDR R1, =639999             ; Load the reload value to R1
					STR R1, [R0, #4]            ; Set the reload value to Reload Value Register
					MOVS R1, #0                 ; Clear R1
					STR R1, [R0, #8]            ; Set the current value register
					MOVS R1, #7                 ; Set the control and status register (enable, interrupt, and clock source)
					STR R1, [R0]				; Store R1 into the control and status register
					POP {PC}                    ; Restore the program counter

Save_Start_Time	PUSH {LR}                   ; Save the link register
				LDR R0, =start_time         ; Load the address of start_time into R0
				LDR R1, =0xE000E018         ; Load the current value of the SysTick counter into R1
				STR R1, [R0]                ; Store the current value of the SysTick counter into start_time
				POP {PC}                    ; Restore the program counter

Save_Execution_Time	LDR R0, =execution_time     ; Load the address of execution_time into R0
					LDR R1, =start_time         ; Load the address of start_time into R1
					LDR R2, =0xE000E018         ; Load the current value of the SysTick counter into R2
					SUBS R2, R2, R1             ; Calculate the execution time by subtracting start_time from the current value of the SysTick counter
					STR R2, [R0]                ; Store the execution time into the execution_times array at the appropriate index
					B   Stop_Systick_Timer

Stop_Systick_Timer	LDR R0, =0xE000E010         ; Load the base address of SysTick control and status register
					MOVS R1, #0                 ; Clear the control register (disable SysTick)
					STR R1, [R0, #4]            ; Clear the reload value register
					STR R1, [R0, #8]            ; Clear the control value register
					STR R1, [R0]				; Clear the control and status register
					B stop

stop	B stop	; Infinite loop to keep the program halted at this point

        ENDFUNC ; Finish function
        END ; Finish assembly file
