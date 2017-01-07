.global drawLives

drawLives:
	mov 	r0, #64 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture

	mov 	r0, #96 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture

	mov 	r0, #128 	// x coord
	mov 	r1, #736	// y coord
	mov	r2, #32		// width of image
	mov 	r3, #32		// height of image
	ldr 	r4, =heart	// load image into reg
	bl 	DrawPicture	// call draw picture

	bx 	lr
