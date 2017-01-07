.global map2

map2:
	push	{lr}

	mov 	r0, #496
	mov 	r1, #96
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =brick		// r4 = address of brick

	push	{r0-r4}
	bl 	DrawPicture
	pop	{r0-r4}
	
	mov 	r0, #480
	mov 	r1, #128
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =brick		// r4 = address of brick
	mov 	r6, #0

	push	{r0-r4}
	bl 	DrawPicture
	pop	{r0-r4}

	add	r0, #32


maploop2:
	push	{r0-r4}
	bl 	DrawPicture
	pop	{r0-r4}

	add 	r0, #32
	add 	r1, #32
	add 	r6, #1

	cmp 	r6, #10
	bne	maploop2

	mov 	r0, #480
	mov 	r1, #128
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =brick		// r4 = address of brick
	mov 	r6, #0

rightdiag:
	push	{r0-r4}
	bl 	DrawPicture
	pop	{r0-r4}

	sub 	r0, #32
	add 	r1, #32
	add 	r6, #1

	cmp 	r6, #10
	bne	rightdiag

	//add 	r0, #32
	add 	r1, #64
	mov 	r6, #0

line2:
	push	{r0-r4}
	bl 	DrawPicture
	pop	{r0-r4}

	add 	r0, #32
	add 	r6, #1
	
	cmp	r6, #22
	bne 	line2	

	pop	{lr}
	bx	lr
