
.global InsertBody
InsertBody:

	push	{lr}
	push	{r4-r10}
	
	ldr	r5, =gameState
	ldr	r6, [r5, #4]

	add	r6, #1
	str	r6, [r5, #4]


	sub	r0, r6, #1
	mov	r1, #0
	mov	r2, #0
	bl	InsertPosition

	pop	{r4-r10}
	pop	{lr}

	bx	lr


// prints out the entire snake onto the screen

.global DrawSnake
DrawSnake:

	push	{lr}
	push	{r0-r10}
	
	mov	r5, #1			// counter for body of snake

	ldr	r6, =gameState		// load gameState adress
	ldr	r6, [r6, #4]		// get the length of the snake
	sub	r6, #2			// index of the last body of the snake
				
					// Before executing the drawing of the body, draw head
	mov	r0, #0
	bl	LoadPosition		//get snake head position, x in r0 and y in r1


	ldr 	r7, =gameState
	ldr 	r7, [r7]

	cmp 	r7, #0
	beq 	pepeheadup

	cmp 	r7, #1
	beq 	pepeheaddown

	cmp 	r7, #2
	beq 	pepeheadright

	cmp 	r7, #3
	beq 	pepeheadleft


pepeheadleft:
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =pepe

	bl	DrawPicture		//DRAW SNAKE HEAD
	b 	bodyLoop

pepeheadright:
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =peperight

	bl	DrawPicture		//DRAW SNAKE HEAD

	b 	bodyLoop

pepeheadup:
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =pepeup

	bl	DrawPicture		//DRAW SNAKE HEAD

	b 	bodyLoop

pepeheaddown:
	mov	r2, #32
	mov	r3, #32
	ldr	r4, =pepedown

	bl	DrawPicture		//DRAW SNAKE HEAD



bodyLoop:
	
	mov	r0, r5
	bl	LoadPosition		//get snake head position, x in r0 and y in r1

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =body


	bl	DrawPicture		//DRAW SNAKE HEAD
	
	add	r5, #1
	cmp	r5, r6
	ble	bodyLoop

endDrawSnake:


	mov	r0, r5
	bl	LoadPosition		//get snake head position, x in r0 and y in r1

	mov	r2, #32
	mov	r3, #32
	ldr	r4, =box

	bl	DrawPicture		//DRAW SNAKE HEAD

	
	pop	{r0-r10}
	pop	{lr}	

	bx	lr



// r0 new x coordinate for head
// r1 new y cooridnate for head
// takes the length of snake, stored in memory at gameState
.global UpdateSnake
UpdateSnake:
	push	{lr}	
	push	{r4-r10}

	mov	r5, r0		// r5 has the x cord
	mov	r6, r1		// r6 has the y coord
	
	ldr	r4, =gameState
	ldr	r4, [r4, #4]
	sub	r4, #1		//index for the last entry


updateLoop:
	
	
	sub	r0, r4, #1	//get the cell above


	cmp	r0, #0	
	blt	endUpdate
	mov	r7, r0		// keep track of cell index

	
	bl	LoadPosition	// position returned in r0 and r1

		
	mov	r2, r1
	mov	r1, r0
	mov	r0, r4

	bl	InsertPosition	// r0 has the x for this poisition
				// r1 has the y for this posiotopn

	sub	r4, #1
	b	updateLoop

endUpdate:
	mov	r0, #0			//update the array with the new head location
	mov	r1, r5
	mov	r2, r6

	bl	InsertPosition		//insert new head locations

	pop	{r4-r10}
	pop	{lr}
	bx	lr
	






// r0 number which is the index of the portion of the snake in question
// r1 the x coordinate to update
// r2 the y coordinate to update
.global InsertPosition
InsertPosition:

	push	{r4-r10}

	ldr	r3,=snake
	lsl	r0, #3			//each position offset by 8
	add	r3, r0

	str	r1, [r3], #4		//get correct offset for x cord
	str	r2, [r3]

	pop	{r4-r10}
	bx	lr


// r0 is the the index in which we want to return the locations x and y
// x value is returned into r0
// y value is returned into r1
.global LoadPosition
LoadPosition:
	push	{r4-r10}
	
	ldr	r3,=snake
	lsl	r0, #3
	add	r3, r0
	
	ldr	r0, [r3], #4
	ldr	r1, [r3]

	pop	{r4-r10}
	bx	lr
