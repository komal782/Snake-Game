.global random

random:
	push 	{lr}
	push	{r0-r6}
resetRand:
	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******
	
	mov 	r1, #800			// maximum limit of x coords by 32
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of x coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)

	mov 	r0, r1			// copy remainder into r5
	mov	r1, #29

	bl	newDiv
	
	mov 	r5, r1			// copy reamainder into r6
	add 	r5, #1

	mov	r1, #32
	mul	r5, r1
	
	

	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******

	mov 	r1, #800		// maximum limit of y coords
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of y coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)


	mov 	r0, r1			// copy remainder into r5
	mov	r1, #20

	bl	newDiv


	mov 	r6, r1			// copy reamainder into r6
	add 	r6, #1

	mov	r1, #32
	mul	r6, r1
	

	mov	r0, r5			// x coord
	mov	r1, r6			// y coord


	mov	r2, #32			// size of bow
	mov	r3, #32			// size of bow
	ldr	r4, =bow		// address of bow
	
	push	{r0-r5}
	bl	DetectCollision
	
	cmp	r0, #0
	pop	{r0-r5}
	beq	resetRand
	


	bl	DrawPicture		// call drawpicture

	pop	{r0-r6}
	pop	{lr}
	bx 	lr


.global door

door:
	push 	{lr}
	push	{r0-r6}
resetRand2:
	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******
	
	mov 	r1, #800			// maximum limit of x coords by 32
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of x coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)

	mov 	r0, r1			// copy remainder into r5
	mov	r1, #29

	bl	newDiv
	
	mov 	r5, r1			// copy reamainder into r6
	add 	r5, #1

	mov	r1, #32
	mul	r5, r1
	
	

	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******

	mov 	r1, #800		// maximum limit of y coords
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of y coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)


	mov 	r0, r1			// copy remainder into r5
	mov	r1, #20

	bl	newDiv


	mov 	r6, r1			// copy reamainder into r6
	add 	r6, #1

	mov	r1, #32
	mul	r6, r1
	

	mov	r0, r5			// x coord
	mov	r1, r6			// y coord


	mov	r2, #32			// size of bow
	mov	r3, #64			// size of bow
	ldr	r4, =femalePepe		// address of bow
	

	push	{r0-r5}

	bl	DetectCollision

	cmp	r0, #0
	pop	{r0-r5}
	beq	resetRand2

	push	{r0-r5}

	add	r1, #32
	bl	DetectCollision

	cmp	r0, #0
	pop	{r0-r5}
	beq	resetRand2
	


	bl	DrawPicture		// call drawpicture

	pop	{r0-r6}
	pop	{lr}
	bx 	lr

.global ValPack
ValPack:
	push 	{lr}
	push	{r0-r6}
resetRand3:
	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******
	
	mov 	r1, #800			// maximum limit of x coords by 32
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of x coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)

	mov 	r0, r1			// copy remainder into r5
	mov	r1, #29

	bl	newDiv
	
	mov 	r5, r1			// copy reamainder into r6
	add 	r5, #1

	mov	r1, #32
	mul	r5, r1
	
	

	ldr 	r3, =0x20003004 	// address of the CLOCK			******
	ldr 	r0, [r3]		// read the clock and load into r1	******

	mov 	r1, #800		// maximum limit of y coords
	//push	{r0}			// push CLOCK into stack as (numerator)
	//push 	{r1}			// push max limit of y coords into stack (denominator)
	bl 	newDiv			// call divide
	//pop 	{r1}			// pop the remainder (mod)


	mov 	r0, r1			// copy remainder into r5
	mov	r1, #20

	bl	newDiv


	mov 	r6, r1			// copy reamainder into r6
	add 	r6, #1

	mov	r1, #32
	mul	r6, r1
	

	mov	r0, r5			// x coord
	mov	r1, r6			// y coord


	mov	r2, #32			// size of bow
	mov	r3, #32			// size of bow
	ldr	r4, =valueFork		// address of bow
	
	push	{r0-r5}
	bl	DetectCollision
	
	cmp	r0, #0
	pop	{r0-r5}
	beq	resetRand3
	


	bl	DrawPicture		// call drawpicture

	pop	{r0-r6}
	pop	{lr}
	bx 	lr


	// we know jenny commented this
