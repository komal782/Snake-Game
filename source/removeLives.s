.global removeLives

removeLives:

	push 	{lr}
	push 	{r4-r10}
	
	ldr 	r4, =gameState
	ldr	r4, [r4, #12]

	cmp	r4, #3
	beq	removeLive3

	cmp	r4, #2
	beq	removeLive2

	cmp	r4, #1
	beq	removeLive1

endRemove:
	ldr 	r5, =gameState
	ldr	r4, [r5, #12]
	
	sub	r4, #1

	str	r4, [r5, #12]

	pop	{r4-r10}
	pop	{lr}

	bx	lr


removeLive3:
	mov 	r0, #128	// x coord
	mov 	r1, #736	// y coord
	mov 	r2, #32 	// width of image
	mov 	r3, #32		// length of image
	ldr 	r4, =box	// load image into reg

	bl	DrawPicture	// draw box for first live

	b	endRemove

removeLive2:
	mov 	r0, #96		// x coord
	mov 	r1, #736	// y coord
	mov 	r2, #32 	// width of image
	mov 	r3, #32		// length of image
	ldr 	r4, =box	// load image into reg

	bl	DrawPicture	// draw box for first live

	b	endRemove

removeLive1:
	mov 	r0, #64		// x coord
	mov 	r1, #736	// y coord
	mov 	r2, #32 	// width of image
	mov 	r3, #32		// length of image
	ldr 	r4, =box	// load image into reg

	bl	DrawPicture	// draw box for first live

	b	endRemove
