.global DrawPixel

/* Draw Pixel
 *  r0 - x
 *  r1 - y
 *  r2 - color
 */

DrawPixel:
	push	{r4}


	offset	.req	r4

	// offset = (y * 1024) + x = x + (y << 10)
	add		offset,	r0, r1, lsl #10
	// offset *= 2 (for 16 bits per pixel = 2 bytes per pixel)
	lsl		offset, #1
	
	// store the colour (half word) at framebuffer pointer + offset

	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	strh	r2, [r0, offset]

	pop		{r4}
	bx		lr


// r0 x origin
// r1 y origin
// r2 width
// r3 height
// r4 address of the picture
.global DrawPicture
DrawPicture:
	push 	{r4-r10}
	mul 	r5,r2,r3 		//r5 is the counter end value
	mov	r6, #0			//the counter
	add 	r8, r0, r2		//value of x origin + width
	add 	r9, r1, r3		//value of y origin + height
	mov 	r10, r0			//store the value of r0 to reset later


inner:	
	push	{r2}
	ldr 	r2, [r4], #2		//load color into r2, increment after by 2 (halfword)

	push	{lr}
	push	{r0}
	bl 	DrawPixel
	pop	{r0}
	pop	{lr}
	pop	{r2}

	add 	r0, #1
	cmp	r0, r8
	beq	outer

	add 	r6, #1

	cmp 	r6, r5
	blt	inner
	
outer:

	add 	r1, #1
	mov 	r0, r10
	cmp 	r1, r9
	blt	inner

	pop 	{r4-r10}
	bx	lr
	

.global LoadPixel
LoadPixel:

	push	{r4-r10}
	add	r4, r0, r1, lsl #10 
	lsl	r4, #1
	
	ldr	r0, =FrameBufferPointer
	ldr	r0, [r0]
	ldrh	r0, [r0, r4]

	pop	{r4-r10}
	bx	lr


