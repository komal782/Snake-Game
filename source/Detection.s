.global DetectBow

//r0 = x
// r1 = y
//r2 = width
// r3 = height
DetectBow:
	push	{lr}
	push	{r4-r10}
	
	mul	r4, r2, r3
	add	r5, r0, r2		// have xcord + width
	add	r6, r2, r3		// have y cord + hieght
	mov	r10, r0			// used to reset r0 once a row has finished being read
	mov	r7, #0			// counter for the number of pixels
	ldr	r8, =bow
loopDetectBow:
	cmp	r7, r4			// how many pixels to read
	movge	r0, #1			// return 1 if no collision
	bge	endDetectBowCollision
					// r1 has the y cord
					// r0 has x cord
	push	{r0}
	bl	LoadPixel

	//Get a pixel from the bow image (size is 32*32)


	ldrh	r9, [r8], #2 
			
	cmp	r0, r9			// check result pixel color (0 if baground)
	pop	{r0}			// preserve current row since Load pixel overwrites r0
	movne	r0, #0			// if it is not 0 move 0 into r0 and end
	bne	endDetectBowCollision

	add	r7, #1			// increment r7 by 1
	add	r0, #1			// increment r0 (x) by 1
	
	cmp	r0, r5			// check if the row has finished being read
	addeq	r1, #1			// if so add 1 to the y axis
	moveq	r0, r10			// also reset r0
	b	loopDetectBow		// go back to top of loop

endDetectBowCollision:

	pop	{r4-r10}
	pop	{lr}
	bx	lr	



.global DetectCollision

// r0 = x cord
// r1 = y cord
// r2 = width
// r3 = height
// returns 0 if a collision occured and 1 otherwise in r0
DetectCollision:

	push	{lr}
	push	{r4-r10}
	mov	r4, #0
	mul	r4, r2, r3
	add	r5, r0, r2		// have xcord + width
	add	r6, r2, r3		// have y cord + hieght
	mov	r10, r0			// used to reset r0 once a row has finished being read
	mov	r7, #0			// counter for the number of pixels

loopDetect:
	cmp	r7, r4			// how many pixels to read
	movge	r0, #1			// return 1 if no collision
	bge	endDetectCollision
					// r1 has the y cord
					// r0 has x cord
	push	{r0}
	bl	LoadPixel		
	cmp	r0, #0			// check result pixel color (0 if baground)
	pop	{r0}			// preserve current row since Load pixel overwrites r0
	movne	r0, #0			// if it is not 0 move 0 into r0 and end
	bne	endDetectCollision

	add	r7, #1			// increment r7 by 1
	add	r0, #1			// increment r0 (x) by 1
	
	cmp	r0, r5			// check if the row has finished being read
	addeq	r1, #1			// if so add 1 to the y axis
	moveq	r0, r10			// also reset r0
	b	loopDetect		// go back to top of loop

endDetectCollision:
	pop	{r4-r10}
	pop	{lr}
	bx	lr



.global DetectFemalePepe

// r0 = x cord
// r1 = y cord
// r2 = width
// r3 = height
// returns 0 if a collision occured and 1 otherwise in r0
	
DetectFemalePepe:
	push	{lr}
	push	{r4-r10}
	
	mul	r4, r2, r3
	add	r5, r0, r2		// have x cord + width
	add	r6, r2, r3		// have y cord + hieght
	mov	r10, r0			// used to reset r0 once a row has finished being read
	mov	r7, #0			// counter for the number of pixels
	ldr	r8, =femalePepe
loopDetectFemalePepe:
	cmp	r7, r4			// how many pixels to read
	movge	r0, #1			// return 1 if no collision
	bge	endDetectFemalePepeCollision
					// r1 has the y cord
					// r0 has x cord
	push	{r0}
	bl	LoadPixel

	//Get a pixel from the female pepe image (size is 64*32)

	ldrh	r9, [r8], #2 
			
	cmp	r0, r9			// check result pixel color (0 if baground)
	pop	{r0}			// preserve current row since Load pixel overwrites r0
	movne	r0, #0			// if it is not 0 move 0 into r0 and end
	bne	endDetectFemalePepeCollision

	add	r7, #1			// increment r7 by 1
	add	r0, #1			// increment r0 (x) by 1
	
	cmp	r0, r5			// check if the row has finished being read
	addeq	r1, #1			// if so add 1 to the y axis
	moveq	r0, r10			// also reset r0
	b	loopDetectFemalePepe	// go back to top of loop

endDetectFemalePepeCollision:

	pop	{r4-r10}
	pop	{lr}
	bx	lr



.global DetectValuePack

//r0 = x
// r1 = y
//r2 = width
// r3 = height
DetectValuePack:
	push	{lr}
	push	{r4-r10}
	
	mul	r4, r2, r3
	add	r5, r0, r2		// have xcord + width
	add	r6, r2, r3		// have y cord + hieght
	mov	r10, r0			// used to reset r0 once a row has finished being read
	mov	r7, #0			// counter for the number of pixels
	ldr	r8, =valueFork
loopDetectValue:
	cmp	r7, r4			// how many pixels to read
	movge	r0, #1			// return 1 if no collision
	bge	endDetectValuePack
					// r1 has the y cord
					// r0 has x cord
	push	{r0}
	bl	LoadPixel

	//Get a pixel from the bow image (size is 32*32)


	ldrh	r9, [r8], #2 
			
	cmp	r0, r9			// check result pixel color (0 if baground)
	pop	{r0}			// preserve current row since Load pixel overwrites r0
	movne	r0, #0			// if it is not 0 move 0 into r0 and end
	bne	endDetectValuePack

	add	r7, #1			// increment r7 by 1
	add	r0, #1			// increment r0 (x) by 1
	
	cmp	r0, r5			// check if the row has finished being read
	addeq	r1, #1			// if so add 1 to the y axis
	moveq	r0, r10			// also reset r0
	b	loopDetectValue		// go back to top of loop

endDetectValuePack:

	pop	{r4-r10}
	pop	{lr}
	bx	lr


