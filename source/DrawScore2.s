.global DrawScore2

DrawScore2:
	push	{lr}
	push 	{r4-r10}
	mov	r9, #0
	ldr	r4, =gameState		// Load counter from mameries
	ldr	r4, [r4,#8]		// loads the score from memory
	
	push	{r0-r4}

	ldr	r1, =738
	ldr	r0, =886
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =box	
	bl	DrawPicture

	pop	{r0-r4}

	// FOR SINGLE DIGITS (put a ring on it)
	cmp 	r4, #10			// compare r4 to 10
	bge	greaterThanTen		// if r4 >= 10, go to greaterThanTen

	ldr 	r6, =738		// y coord of text
	ldr	r5, =886		// x coord of text
	add	r0, r4, #48		// get the digit (add 48)
	bl	begin			// branch to writing the text

	b 	endScore		// loop to end
	

	//********************************************FIX TO DISPLAY SINGLE DIGITS PROPERLY**************//

greaterThanTen:
	movge	r9, #1
	movge	r0, r4 			// if greate then  a two digit number so divide number by 10
	movge	r1, #10

	blge	newDiv			// result is in r0, remainder in r1
		
	mov	r10, r1			// keep track of remainder val

	ldr 	r6, =738 		// y coord of text
	ldr 	r5,=886  		// x coord of text
	add	r0, #48			// get ascci value of counter
	bl 	begin


	cmp	r9, #1			// check if the flag for 2 digit number is set
	addeq   r0, r10, #48		// store the ascii value in r0, using the remainder stored in r10



	addeq	r5, #9			// set the offset of the next digit by 9 pixels into r5
	bleq	begin			// branch into begin if 2 digit flag is set

endScore:
	pop	{r4-r10}
	pop	{lr}

	bx 	lr

//r6 is the y coord
//r5 is x coord

begin: 
	push	{lr}
	push	{r4-r10}
	mov	r3, r5
	ldr 	r4, =font 	// load address of font map
	add 	r4, r0, lsl #4	// char address = font base + (char * 16)

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

	pop 	{r4-r10}
	pop	{lr}
	bx	lr


haltLoop$:
	b 	haltLoop$

.section .data
	.align 4
font: 	.incbin "font.bin"
