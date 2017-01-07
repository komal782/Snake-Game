.global startMenu


startMenu:
	push	{lr}
	push	{r0-r10}

	bl	disableIrq
	
	mov 	r0, #416
	mov	r1, #256
	mov	r2, #160
	mov	r3, #96
	ldr 	r4, =pauseMenu

	bl 	DrawPicture

	
	//DRAW INITIAL heart pointing up 
	// 288 is up, 320 is down
	mov	r0, #416
	mov	r1, #288

	mov	r8, r0			// store copy of previous x cord in r8
	mov	r9, r1			// store copy of previous y cord in r9
	mov	r10, #0			// use r10 to keep track of cursor position, 0 = UP = RESTART, 1 = DOWN = 						//QUIT
	

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =cursor

	bl	DrawPicture

	
	ldr	r0, =100000
	bl	Wait 			// delay so menu does not close immediatly from pressing start
					// initally



getInput:
	bl	ReadSnes		// get the user input	


	bl	GetMenuDirection	// get menu direction
	mov	r7, r0

	
	cmp	r7, #0			// if up is pressed
	beq	moveUp

	cmp	r7, #1			// if down is pressed
	beq	moveDown		// branch to move down

	cmp	r7, #4			// if 4 indicates start menu closes
	beq	end			// branch to end of subroutine

	cmp	r7, #2			// check if your ugly bitch err i mean... check if A is pressed #forgive me
	beq	endScreen
	
	b	getInput		// branch to get input if done

moveUp:
	cmp	r9, #288
	beq	getInput

	mov	r0, #416		// store copy of previous x cord in r8
	mov	r1, #320		// store copy of previous y cord in r9
	

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =cornerblack
	bl	DrawPicture

	mov	r8, #416
	mov	r9, #288

	
	mov	r1, r9
	mov	r0, r8
	

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =cursor

	bl	DrawPicture

	mov	r10, #0

	b	getInput	

moveDown:
	cmp	r9, #320		// check if the curosr is at the bottom
	beq	getInput		// if already down get input again

	
	mov	r0, #416			// store copy of previous x cord in r8
	mov	r1, #288			// store copy of previous y cord in r9
	

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =blackbox
	bl	DrawPicture

	
	mov	r8, #416
	mov	r9, #320

	mov	r1, r9
	mov	r0, r8
	
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =cornercursor

	bl	DrawPicture

	mov	r10, #1			//set cursor flag as 1 for down

	b	getInput

endScreen:
	ldr	r4, =gameState
	cmp	r10, #0			// check if cursor is up

	moveq	r0, #1			// set flag for cursor up
	movne	r0, #2			// set flag for cursor down

	streq	r0, [r4, #20]
	strne	r0, [r4, #20]



end:	


	bl	map

	bl	enableIrq
	
	pop	{r0-r10}
	pop	{lr}	

	bx	lr







	
