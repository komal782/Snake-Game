.global map
//SUBROUTINE 
map:
	push	{lr}

	mov 	r0, #224
	mov 	r1, #160
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick
	
	bl 	DrawPicture


	ldr 	r0, =768
	mov 	r1, #160
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick

	bl 	DrawPicture

	mov 	r0, #288
	ldr	r1, =608
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick
	mov 	r6, #0
	


maploop:	
	push {r0-r2}
	bl 	DrawPicture
	pop {r0-r2}

	add 	r0, #32
	sub 	r1, #32
	
	cmp 	r0, #352
	ble	maploop

line:
	push {r0-r2}

	bl 	DrawPicture

	pop {r0-r2}

	add 	r0, #32
	add 	r6, #1

	cmp	r6, #6
	bne 	line

	mov 	r6, #0

diagonal:
	
	push {r0-r2}

	bl 	DrawPicture

	pop {r0-r2}

	add 	r0, #32
	add	r1, #32
	add 	r6, #1

	cmp 	r6, #4	
	bne 	diagonal

	mov 	r6, #0

	mov 	r0, #416
	mov	r1, #256
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick


nose:
	push {r0-r2}

	bl 	DrawPicture

	pop {r0-r2}

	add	r6, #1
	add	r0, #32
	
	cmp	r6, #4
	ble	nose

	mov 	r6, #0
	mov 	r0, #416
	mov	r1, #288
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick


nose2:
	push {r0-r2}

	bl 	DrawPicture

	pop {r0-r2}

	add	r6, #1
	add	r0, #32
	
	cmp	r6, #4
	ble	nose2

	mov 	r6, #0
	mov 	r0, #416
	mov	r1, #320
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick

nose3:
	push {r0-r2}

	bl 	DrawPicture

	pop {r0-r2}

	add	r6, #1
	add	r0, #32
	
	cmp	r6, #4
	ble	nose3

	mov 	r0, #416
	mov	r1, #320
	mov	r2, #32 		// width of brick
	mov	r3, #32			// length of brick
	ldr	r4, =innerBrick		// r4 = address of brick

end:
	pop	{lr}
	bx	lr

