.global DrawChar

DrawChar:
	push	{lr}
	push 	{r0-r10}

	// WRITE LIVES:

	ldr 	r6, =738 	// y coord of text
	mov 	r5, #0  	// x coord of text
	mov 	r9, #'L'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'I'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'V'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'E'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'S'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #':'
	bl 	begin

	// WRITE SCORE:

	ldr 	r6, =738	// y coord
	mov 	r5, #832	// x coord
	mov 	r9, #'S'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'C'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'O'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'R'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #'E'
	bl 	begin

	ldr 	r6, =738
	add 	r5, #9 
	mov 	r9, #':'
	bl 	begin

	pop	{r0-r10}
	pop	{lr}

	bx 	lr

//r6 is the y coord
//r5 is x coord
begin: 
	push	{lr}
	push	{r4-r8}
	mov	r3, r5
	ldr 	r4, =font 	// load address of font map
	add 	r4, r9, lsl #4	// char address = font base + (char * 16)

charLoop:
	mov 	r5, r3

	mov 	r8, #0x01	// bitmask (least sig bit)

	ldrb 	r7, [r4], #1 	// load row byte, post incre r5 (font map address)

rowLoop:
	tst 	r7, r8 		// test row & bit mask
	beq	noPixel

	mov 	r0, r5		// move px (r5) to r0
	mov 	r1, r6		// move py (r6) to r1
	ldr	r2, =0xFFFF 	// MAKE THE FONT WHITE
	bl 	DrawPixel

noPixel: 
	add 	r5, #1 		// increment px (r5)
	lsl 	r8, #1		// left shift bitmask left by 1

	tst 	r8, #0x100	// test to see if mask is shifted 8 times
	beq 	rowLoop 	// if it has reached the left most side, go to rowLoop

	add 	r6, #1		// increment py (r6)

	tst 	r4, #0xF	// test font map to 1111
	bne 	charLoop

	pop 	{r4-r8}
	pop	{lr}
	bx	lr

haltLoop$:
	b 	haltLoop$

.section .data
	.align 4
font: 	.incbin "font.bin"
