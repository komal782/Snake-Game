
.global Border
Border:
	push	{lr}
	mov 	r0, #0 			// X COORD
	mov 	r1, #0			// Y COORD
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =brick		// r4 = address of brick
	mov 	r10, #0 		// horizontal border counter
	mov 	r9, #0			// column border counter

borderloop:
	push	{r0-r10}
	bl 	DrawPicture
	pop	{r0-r10}

	cmp 	r10, #31
	beq 	rightcolumn

	add 	r0, #32
	add 	r10, #1

	b 	borderloop
	
rightcolumn:
	push	{r0-r10}
	bl 	DrawPicture
	pop	{r0-r10}

	cmp 	r9, #22
	beq	bottomborder

	add 	r1, #32
	add 	r9, #1

	b 	rightcolumn

bottomborder:
	push	{r0-r10}
	bl 	DrawPicture
	pop	{r0-r10}

	cmp 	r0, #0
	beq	leftborder

	sub 	r0, #32
	sub 	r10, #1

	b	bottomborder

leftborder:
	push	{r0-r10}
	bl 	DrawPicture
	pop	{r0-r10}

	cmp 	r1, #0
	beq	next

	sub	r1, #32
	sub 	r9, #1
	
	b	leftborder
next:
	pop	{lr}
	bx	lr



