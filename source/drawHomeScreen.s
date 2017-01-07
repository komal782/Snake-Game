.global homescreenstart

homescreenstart:
	push 	{lr}
	push 	{r0-r10}
	


	mov	r0, #0			// start x coord is r0
	mov	r1, #0			// start y coord is r1
	mov 	r2, #1024		// x dimension 
	mov 	r3, #768		// y dimension
	ldr	r4, =homescreen		// addr of pic
	bl	DrawPicture



	mov 	r0, #9			// set line 9 (LATCH) to r0
	mov 	r1, #001		// set OUTPUT (001) as the function (r1)   
	bl	Init_GPIO		// call Initialize GPIO for line 9 (LATCH)

	mov 	r0, #10			// set line 10 (DATA) to r0
	mov 	r1, #000		// set INPUT (000) as the function (r1)
	bl	Init_GPIO 		// call Initialize GPIO for line 10 (DATA)

	mov 	r0, #11			// set line 11 (CLOCK) to r0
	mov 	r1, #001		// set OUTPUT (001) as the function (r1)
	bl	Init_GPIO		// call Initialize GPIO for line 11 (CLOCK)

	
	

	mov	r0, #600		// start x coord is r0
	ldr	r1, =598		// start y coord is r1

	
	mov	r9, r0			// copy r9 for x cord
	mov	r10, r1			// copy r10 for y cord
	
	mov 	r2, #32			// x dimension 
	mov 	r3, #32			// y dimension
	ldr	r4, =arrow		// addr of pic
	bl	DrawPicture		// Draw the start screen picture

getInput:
	bl	ReadSnes		// get the user input

	bl 	GetMenuDirection	// identify the menu direction
	mov	r7, r0			// copy menu direction into r7

	
	cmp	r7, #0			// if up is pressed
	moveq	r5, #0
	beq	moveUp			// branch to move up

	cmp	r7, #1			// if down button is pressed 
	moveq	r5, #1
	beq	moveDown

	cmp	r7, #2
	beq	select

	b	getInput
moveUp:
	ldr	r4, =598
	cmp	r10, r4		// check if the arrow is already up
	beq	getInput		// go back to getInput if this is true

	ldr	r1, =598		// 640 is down btw
	mov	r0, #600

	mov	r9, r0			// copy r9 for x cord
	mov	r10, r1			// copy r10 for y cord

	mov 	r2, #32			// x dimension 
	mov 	r3, #32			// y dimension
	ldr	r4, =arrow		// addr of pic
	bl	DrawPicture		// Draw the start screen picture

	// clear the previous arrow in the down position


	ldr	r1, =670		// erase the previous location
	mov	r0, #600
	mov 	r2, #32			// x dimension 
	mov 	r3, #32			// y dimension
	ldr	r4, =bluebox		// addr of pic
	bl	DrawPicture		// Draw the start screen picture	

	b	getInput


moveDown:
	ldr	r4, =670
	cmp	r10, r4		// check if the arrow is already up
	beq	getInput		// go back to getInput if this is true

	ldr	r1, =670		// 640 is down 
	mov	r0, #600		// 
	
	mov	r9, r0			// copy r9 for x cord
	mov	r10, r1			// copy r10 for y cord

	mov 	r2, #32			// x dimension 
	mov 	r3, #32			// y dimension
	ldr	r4, =arrow		// addr of pic
	bl	DrawPicture		// Draw the start screen picture

	// clear the previous arrow in the down position


	ldr	r1, =598		// erase the previous location
	mov	r0, #600
	mov 	r2, #32			// x dimension 
	mov 	r3, #32			// y dimension
	ldr	r4, =bluebox		// addr of pic
	bl	DrawPicture		// Draw the start screen picture	

	b	getInput



select:
	cmp	r5, #1
	
	bleq	disableIrq	
	bleq	clearScreen
	cmp	r5, #1
	beq	haltLoop$

	pop 	{r0-r10}
	pop	{lr}
	bx 	lr
